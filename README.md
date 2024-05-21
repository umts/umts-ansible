UMTS's [Ansible][ansible] collection.

Prerequisites
=============
If you're a Homebrew user, `brew bundle` will take care of these for you.

* Pipenv (for Python dependencies) on your workstation - `pip install pipenv`,
* (optional, but strongly recommended) [direnv][direnv] for automatic
  environment variable loading,
* [Vagrant][vagrant] for local testing,
* On MacOS, [VirtualBox][virtualbox], on Linux, libvirt works better — change
  the `VAGRANT_DEFAULT_PROVIDER` environment variable to `libvirt`.

Setup
=====
1. Clone this repository
2. `script/setup`
3. Edit your (gitignored) `.env` file as appropriate

[ansible]: https://www.ansible.com/
[direnv]: https://direnv.net/
[vagrant]: https://www.vagrantup.com/
[virtualbox]: https://www.virtualbox.org/
