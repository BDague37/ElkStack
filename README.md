## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

(Images/Elk_diagram.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook file may be used to install only certain pieces of it, such as Filebeat.

#### Playbook 1: RedTeam.yml
```
---
- name: Config Web VM with Docker
  hosts: webservers
  become: true
  tasks:
  - name: docker.io
    apt:
      force_apt_get: yes
      update_cache: yes
      name: docker.io
      state: present

  - name: Install pip3
    apt:
      force_apt_get: yes
      name: python3-pip
      state: present

  - name: Install Docker python module
    pip:
      name: docker
      state: present

  - name: download and launch a docker web container
    docker_container:
      name: dvwa
      image: cyberxsecurity/dvwa
      state: started
      published_ports: 80:80

  - name: Enable docker service
    systemd:
      name: docker
      enabled: yes
```
#### Playbook 2: elk-stack.yml
```
---
- name: Configure Elk VM with Docker
  hosts: elk
  become: true
  tasks:
    # Install Docker.io
    - name: Install docker.io
      apt:
        update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: present

    # Install Python3-pip
    - name: Install python3-pip
      apt:
        force_apt_get: yes
        name: python3-pip
        state: present

    # Uses pip3 module to setup Docker
    - name: Install Docker Module
      pip:
        name: docker
        state: present

    # Command To Increase Memory
    - name: Increase Virtual Memory
      command: sysctl -w vm.max_map_count=262144

    # Use Sysctl to Use More Memory
    - name: Uses More Memory
      sysctl:
        name: vm.max_map_count
        value: 262144
        state: present
        reload: yes

    # Uses Docker Container Module
    - name: Download Elk Container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        # Configured Elk Stack Port Mapping to following Ports:
        published_ports:
          -  5601:5601
          -  9200:9200
          -  5044:5044

    # Use the Ansible module systemd to make sure the docker service is running.
    - name: Enable docker service
      systemd:
        name: docker
        enabled: yes
```
#### Playbook 3: filebeat-playbook.yml
```
---
-
  name: installing and launching filebeat
  hosts: webservers
  become: yes
  tasks:

  - name: Download Filebeat
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb

  - name: Install Filebeat
    command: dpkg -i filebeat-7.4.0-amd64.deb

  - name: Drop filebeat.yml
    copy:
      src: /etc/ansible/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

  - name:
    command: filebeat modules enable system

  - name: setup filebeat
    command: filebeat setup

  - name: Start filebeat service
    command: service filebeat start
```

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly accessable, in addition to restricting traffic to the network.
- Load balancers protect network availability, allowing requests to be shared over different server setups.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the configuration and system files.
- 
- _TODO: What does Metricbeat record?_

The configuration details of each machine may be found below.
_Note: Use the [Markdown Table Generator](http://www.tablesgenerator.com/markdown_tables) to add/remove values from the table_.
```
| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway  | 10.0.0.4   | Linux            |
| Web-1    | DVWA     | 10.0.0.5   | Linux            |
| Web-2    | DVWA     | 10.0.0.6   | Linux            |
| Web-3    | DVWA     | 10.0.0.7   | Linux            |
| Elk-Stack| Elk      | 10.1.0.4   | Linux            |
```
### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the JumpBox machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- 69.242.126.8

Machines within the network can only be accessed by JumpBox.
- The only machine that can access the Elk VM (Elk-Stack) is the Jump Box (IP: 10.0.0.4)

A summary of the access policies in place can be found in the table below.
```
| Name     | Publicly Accessible | Allowed IP Addresses   |
|----------|---------------------|------------------------|
| Jump Box | Yes: SSH            | 69.242.126.8           |
| Web-1    | Yes: SSH/HTTP       | 10.0.0.4 / 69.242.126.8|
| Web-2    | Yes: SSH/HTTP       | 10.0.0.4 / 69.242.126.8|
| Web-3    | Yes: SSH/HTTP       | 10.0.0.4 / 69.242.126.8|
| Elk-Stack| Yes: SSH/HTTP       | 10.0.0.4 / 69.242.126.8|
```
### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...
- Easily and quickly deploys the build to each of the servers
- Consistant configuration of virtual machines and ensures all required applications are properly installed and updated.

The playbook implements the following tasks:
Playbook 1: RedTeam.yml
- Installs Python3
- Installs Docker
- Installs Python for Docker
- Downloads and installs DVWA Docker Container
- Enables the docker service

Playbook 2: Elk-Playbook.yml
- Installs Docker
- Installs Python3
- Installs Python for Docker
- Increases Virtual Memory
- Downloads and Installs Elk Playbook
- Enables the docker service

Playbook 3: filebeat-playbook.yml
- Downloads Filebeat
- Installs Filebeat
- Installs the filebeat-config.yml
- Enables the filebeat system
- Starts Filebeat setup
- Starts filebeat service 

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

(Images/docker_ps_output.png)
(Images/docker_ps_elk.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
```
- Web-1 10.0.0.5
- Web-2 10.0.0.6
- Web-3 10.0.0.7
```
We have installed the following Beats on these machines:
- Filebeat

These Beats allow us to collect the following information from each machine:
- Filebeat collects logs from the VMs and sends them to Kibana to be viewed.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the playbook files to Ansible Container.
- Update the /etc/Ansible/hosts file to include...
   ```
   - [webservers]
      10.0.0.4 ansible_python_interpreter=/usr/bin/python3
      10.0.0.5 ansible_python_interpreter=/usr/bin/python3
      10.0.0.6 ansible_python_interpreter=/usr/bin/python3

    - [elkservers]
      10.1.0.4 ansible_python_interpreter=/usr/bin/python3
      ```
```
- Run the playbook, and navigate to the terminal to check that the installation worked as expected.

- _Which file is the playbook? Where do you copy it?
    The RedTeam.yml and Elk-Playbook.yml playbook can be copied to the /etc/ansible/ folder/. The filebeat-playbook.yml should be placed in /etc/ansible/roles

- Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?
    To allow ansible to run on each of the machines, you need to update the /etc/ansible/hosts file. The header of each of the scripts tells ansible where to run the playbook.

- _Which URL do you navigate to in order to check that the ELK server is running?
    You would want to navigate to your machines "localhost:5601". In my case I navigate to: http://52.177.220.189:5601
```
