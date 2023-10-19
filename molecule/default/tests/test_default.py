import os
from pytest import fixture
from pathlib import Path

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(os.environ["MOLECULE_INVENTORY_FILE"]).get_hosts("all")


def find_git_root(path):
    parents = [Path(path).resolve()] + list(Path(path).resolve().parents)
    for p in parents:
        if (p / ".git").exists():
            return p
    return None


@fixture
def get_vars(host):
    git_root = find_git_root(__file__)
    defaults_files = f"file={git_root}/defaults/main.yml name=role_defaults"
    vars_files = f"file={git_root}/vars/main.yml name=role_vars"
    ansible_vars = host.ansible("include_vars", defaults_files)["ansible_facts"]["role_defaults"]
    ansible_vars.update(host.ansible("include_vars", vars_files)["ansible_facts"]["role_vars"])
    return ansible_vars


def test_exiftool(host):
    exiftool_command = host.file("/usr/local/bin/exiftool")

    assert exiftool_command.is_file
    assert exiftool_command.user == "root"
    assert exiftool_command.group == "root"
    assert exiftool_command.mode == 0o555


def test_correct_exiftool_version(get_vars, host):
    ver = host.run("exiftool -ver")
    assert ver.stdout.strip() == get_vars["exiftool_version"]
