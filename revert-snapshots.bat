vboxmanage controlvm worker1 poweroff
vboxmanage controlvm worker2 poweroff
vboxmanage controlvm worker3 poweroff
vboxmanage controlvm kubemaster poweroff

vboxmanage snapshot worker1 restore "Snapshot 1"
vboxmanage snapshot worker2 restore "Snapshot 1"
vboxmanage snapshot worker3 restore "Snapshot 1"
vboxmanage snapshot kubemaster restore "Snapshot 1"

vboxmanage startvm kubemaster --type headless
vboxmanage startvm worker1 --type headless
vboxmanage startvm worker2 --type headless
vboxmanage startvm worker3 --type headless
