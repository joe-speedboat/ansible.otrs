[![Build Status](https://travis-ci.org/uniQconsulting-ag/ansible.otrs.svg?branch=master)](https://travis-ci.org/uniQconsulting-ag/ansible.otrs)

[![Alt text](https://www.uniqconsulting.ch/images/logo.png)](https://www.uniqconsulting.ch/)

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

* role: uniQconsulting.mariadb if db install is selected.

Example Playbook
----------------

Example playbooks for this role are located in ´test´ folder:

uniQconsulting ag
-----------------

uniQconsulting ag is a company in Switzerland with Offices in Bassersdorf, Basel and St. Gallen

License
--------------
https://opensource.org/licenses/LGPL-3.0    
Copyright (c) uniQconsulting ag - Chris Ruettimann <cruettimann@uniqconsulting.ch>
