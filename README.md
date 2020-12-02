[![Build Status](https://travis-ci.org/uniqconsulting.ag/ansible.otrs)]



Install OTRS with Ansible
=================

This Ansible Role install OTRS on Linux.

Requirements
------------

* Currently only tested with CentOS 7
* Ansible 2.4 or higher is required for this Ansible Role
* Working internet and proper repository configuration on machines.

Role Variables
--------------
Variables are self speaking or documented in:   
* `defaults/main.yml`
* `vars/main.yml`

Dependencies
------------

* role: uniqconsulting.mariadb if db install is selected.

Example Playbook
----------------

Example playbooks for this role are located in ´test´ folder:

License
--------------
https://opensource.org/licenses/LGPL-3.0    
