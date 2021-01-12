# Concourse SSH Resource

[![CircleCI](https://circleci.com/gh/pyr-sh/concourse-ssh-resource.svg?style=shield)](https://circleci.com/gh/pyr-sh/concourse-ssh-resource)
[![codecov](https://codecov.io/gh/pyr-sh/concourse-ssh-resource/branch/master/graph/badge.svg)](https://codecov.io/gh/pyr-sh/concourse-ssh-resource)
[![goreportcard](https://goreportcard.com/badge/github.com/pyr-sh/concourse-ssh-resource)](https://goreportcard.com/report/github.com/pyr-sh/concourse-ssh-resource)
[![Docker Repository on Quay](https://quay.io/repository/pyr-sh/concourse-ssh-resource/status "Docker Repository on Quay")](https://quay.io/repository/pyr-sh/concourse-ssh-resource)
[![GitHub release](https://img.shields.io/github/release/pyr-sh/concourse-ssh-resource.svg)](https://github.com/pyr-sh/concourse-ssh-resource)
[![license](https://img.shields.io/github/license/pyr-sh/concourse-ssh-resource.svg)](https://github.com/pyr-sh/concourse-ssh-resource)
![stability-stable](https://img.shields.io/badge/stability-stable-green.svg)

> SSH resource for Concourse CI

## Source Configuration

* `host`: host name of remote machine
* `port`: port of SSH server on remote machine, `22` by default
* `user`: user for executing shell script on remote machine
* `password`: plain password for user on remote machine
* `private_key`: private SSH key for user on remote machine

### Caveats

According to [appleboy/easyssh-proxy](https://github.com/appleboy/easyssh-proxy/blob/b777a323265704a7015f3526c3fe31b4f0daa722/easyssh.go#L69-L105), if `password` and `private_key` both exists, `password` would be used first, then `private_key`.

## Behavior

This is a `put`-only resource, `check` and `in` does nothing.

### `out`: Run commands via SSH

Execute shell script on remote machine via SSH.

#### Parameters

* `interpreter`: string, path to interpreter on remote machine, e.g. `/usr/bin/python3`, `/bin/sh` by default
* `script`: string, shell script to run on remote machine
* `placeholders`: Map of `name` and either `value` for a static value, or `file` for a dynamic value read from a file. Every string matches `name` in your script defintion will then be replaced by either the `value` or the content of `file`. If `file` is used, **only the first line of file content would be used**. Example:

```yaml
---
- put: myserver
  params:
    interpreter: /bin/sh
    script: |
      echo "<MyPlaceHolder>"
      echo "|dynamicPlaceHolder|"
    placeholders:
      - name: "<MyPlaceHolder>"
        value: "somevalue"
      - name: "|dynamicPlaceHolder|"
        file: "myresource/somefile"
```

## Examples

```yaml
---
resource_types:
- name: ssh
  type: docker-image
  source:
    repository: quay.io/pyr-sh/concourse-ssh-resource

resources:
- name: staging-server
  type: ssh
  source:
    host: 127.0.0.1
    user: root
    password: ((ssh_password))

jobs:
- name: echo
  plan:
  # Basic usage
  - put: staging-server
    params:
      interpreter: /usr/bin/env python3
      script: |
        print("Hello, world!")
  # Placeholder usage
  - put: staging-server
    params:
      interpreter: /bin/sh
      script: |
        echo "<static_value>"
        echo "|dynamic_value|"
      placeholders:
        - name: "<static_value>"
          value: "foo"
        - name: "|dynamic_value|"
          file: "bar"
```

## How to Test

We need to start a simple SSH server first. I assume there is no SSH server currently running on your laptop or workstation. For more information about the SSH server, please checkout [pyr-sh/alpine-ssh](https://github.com/pyr-sh/alpine-ssh).

1. `docker run -d -p 22:22 quay.io/pyr-sh/alpine-ssh`
2. `make test`

## Contributors

> sorted in alphabetical order

* [@EugenMayer](https://github.com/EugenMayer)

## License

MIT
