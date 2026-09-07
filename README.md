This Repo is a downloadable Ansible Role that will build an On-Prem Kubernetes Cluster on REDHAT/ROCKY/CENTOS 9 Operating System

This ANSIBLE ROLE will build a Kubernetes Cluster with 1xMasterNode 3xWorkerNodes
This ANSIBLE ROLE also has the ability to Join a FreeIPA domain if you enable the variables and set variables for the server and credentials

I'm using Oracle Virtualbox on my Windows workstation to run all of the VM's talked about here.
All of the VM's NIC are set to "Promiscuous mode" and they are configured as a "Bridged Adapter" so that the VM's can fully interact with my home LAN

I have a total of 7 VM's running

1. ansible "server"
2. ipa server 1
3. ipa server 2
4. kubernetes master node
5. kubernetes worker1
6. kubernetes worker2
7. kubernetes worker3

Lab Setup:
1. Each VM is in the hosts file in this role via a template file
2. Each VM has a user with full sudo privileges. In my case the user is called "automation"
3. The "automation" user should be able to password-less ssh to all nodes listed above.



Ansible Collections needed:
* Look at the ansible.cfg file to figure out where to put the collections (-p option)
* ansible-galaxy collection install [collection_name_here] -p [path_from_ansiblecfg_file]
 1) ansible.posix
 2) community.general

The role provides a hosts file template amongst other templates.
The role goes through a "preliminary" stage where it's setting up Kubernetes requirements for the OS
There are quite a few changes that have to occur to CENTOS9 for various reasons.
I intend to document all of the nuances/challenges throughout this readme, but look at the code for the truth.

I attempted to add enough role variables to keep you involved with what the Ansible role is doing in the background.
The variables are in the order for which the tasks should be executed and that order should also be reflected in the ./tasks/main.yml file with respect to task ordering.

The Components of the Kubernetes Cluster:
* We're setting the Cluster up with the following:
  a) Podman
  b) Containerd
  c) Kube-Proxy
  d) Flannel CNI
  e) MetalLB LoadBalancer
  f) 

