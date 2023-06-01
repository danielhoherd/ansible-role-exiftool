# ExifTool

<https://galaxy.ansible.com/danielhoherd/ansible_role_exiftool>

This is an Ansible role to install ExifTool (<https://exiftool.org>)

# Requirements

Ansible 2.x

# Role Variables

| Variable           | Description | Default |
| ------------------ | ----------- | ------- |
| `exiftool_version` |             | 12.60   |

# Dependencies

None.

# Example Playbook

```yml
- hosts: servers
  roles:
    - { role: danielhoherd.ansible-role-exiftool }
```

# Example requirements.yml

```yml
---
- name: exiftool
  scm: git
  src: git@github.com:danielhoherd/ansible-role-exiftool.git
  version: 43f5f894d42cbaf722299a7fb85b57f64181eb69
```

# License

BSD

# Authors

- Thomas Lehoux
- Daniel Hoherd

# Links

- Exiftool homepage: <https://exiftool.org>
- Exiftool release notes: <https://exiftool.org/history.html>
