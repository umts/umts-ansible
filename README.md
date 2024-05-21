UMTS's [Ansible][ansible] collection.

Prerequisites
=============

* Pipenv (for Python dependencies) on your workstation - `pip install pipenv`
* (optional) [direnv][direnv] for automatic environment variable loading

Setup
=====
1. Clone this repository
2. Install the required Python packages
    ```bash
    source .envrc # done automatically if you have direnv
    pipenv install --dev
    ```
3. Install the required Ansible roles and collections
    ```bash
    ansible-galaxy install -r requirements.yml
    ```

[ansible]: https://www.ansible.com/
[direnv]: https://direnv.net/

