This Repo is a downloadable Ansible Role that will build an On-Prem Kubernetes Cluster on REDHAT/ROCKY/CENTOS 9 Operating System

To EXECUTE the Ansible Role, "bash build.sh" but make sure you understand the lab as described below.
*NOTE: It's IMPERATIVE that tasks that are interacting with the Kubernetes cluster via kubectl NEVER run with become=true or they WILL FAIL. In this role, I only configure the automation user with kubernetes credentials.
* The Kubectl credentials can be modified or add new users to it....it might be in the kubelet.conf file ... can't remember but it's in the code just need to find it and see how its done. 

This ANSIBLE ROLE will build a Kubernetes Cluster with 1xMasterNode 3xWorkerNodes (might be scalable using the inventory groups - havent tried it yet)
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

The role provides a hosts file template amongst other templates.

Ansible Collections needed:
* Look at the ansible.cfg file to figure out where to put the collections (-p option)
* ansible-galaxy collection install [collection_name_here] -p [path_from_ansiblecfg_file]
* I like to make my collections path either in the directory i'm running the "bash build.sh" command or in my home directory. (on the ansible server of course, goofy)
 1) ansible-galaxy collection install ansible.posix -p ./collections/
 2) ansible-galaxy collection install community.general -p ./collections/

The role goes through a "preliminary" stage where it's setting up Kubernetes requirements for the OS
There are quite a few changes that have to occur to CENTOS9 for various reasons.
I intend to document all of the nuances/challenges throughout this readme, but look at the code for the truth. It's gonna take time to document every little trick/hack and why.

I attempted to add enough role variables to keep you involved with what the Ansible role is doing in the background.
The variables are in the order for which the tasks should be executed and that order should also be reflected in the ./tasks/main.yml file with respect to task ordering.

The Components of the Kubernetes Cluster:
* We're setting the Cluster up with the following:
  1) Containerd
  2) Kube-Proxy
  3) Kubelet
  4) Flannel CNI
  5) MetalLB LoadBalancer

  Let's talk about FIPS mode. The ONLY reason I baned to develop the FIPS stuff in this role was because my current deployment of a FreeIPA cluster was built with FIPS 140.2 enabled and designed to setup a two-way trust to Windows AD domain for SSO logins between domains (beyond this scope, I have that role developed too :) )
  The Kubernetes cluster nodes CENTOS9/RHEL9 default crypto-policy attempts to use a non-FIPS approved cipher when trying to join the FreeIPA servers and automatically fails.
  Therefore, we have to put the cluster in FIPS:AD-SUPPORT crypto policy so the ipa join will be forced at the kernel level to use a stronger cipher to talk to the server (whom is expecting a strong cipher thats not blocked by FIPS)
  sigh... I digress.

  I also spent a little time developing some playbooks to deploy some test pods for testing the Flannel installation as well as testing the MetalLB load-balancer installation. Both of which are variables that you can turn off easily.
  1) Testing Flannel CNI is working properly (eg - routing pod network traffic across nodes), you can make use of the "ping pods". Hint: 2 commands,  "kubectl get pods -o wide -n default"  -and- "kubectl exec [podname] -- ping -c 3 [IP's from 1st command]. You should be able to ping across worker nodes!
  2) Testing MetalLB load-balancer is working as expected, you can access the IP for the "Demo Webapp" from your browser and watch the IP's on the page change as MetalLB balances the traffic to the various containers running on different nodes.
  3) HeadLamp is running also. It is a Web Interface for Managing the Kubernetes Cluster and should have a Kubernetes Service using MetalLB to expose the app to external LAN. Hint: kubectl get svc -o wide --all-namespaces |grep -i headlamp
  
  More to come... it's late. I think next I'm going to use my Ansible server as a podman host for a Jenkins instance and tie it into this repo and set up a pipeline for deploying/testing the lab..

  Eventually move all of this to a VPC in Google Cloud and setup a IPSEC tunnel from home to my VPC. That way I can expand my cluster and lab easily into the cloud for a hybrid cloud approach.
  That's ambitious for 11:15 at night but I'll get there someday in the next month or two, hopefully.
  

# HEADLAMP NOTES:
If you're wondering how to Login to HeadLamp, you can generate a login token using this command: kubectl create token headlamp -n kube-system



  
