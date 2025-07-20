# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Base box
  config.vm.box = "ubuntu/jammy64"
  config.vm.box_check_update = false

  # Master node configuration
  config.vm.define "k3s-master" do |master|
    master.vm.hostname = "k3s-master"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.network "forwarded_port", guest: 6443, host: 6443
    master.vm.network "forwarded_port", guest: 80, host: 8080
    master.vm.network "forwarded_port", guest: 443, host: 8443
    
    master.vm.provider "virtualbox" do |vb|
      vb.name = "k3s-master"
      vb.memory = "2048"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    master.vm.provision "shell", inline: <<-SHELL
      # Update system
      apt-get update
      apt-get upgrade -y

      # Install K3s master
      curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 --node-ip 192.168.56.10" sh -

      # Wait for K3s to be ready
      sleep 30

      # Copy kubeconfig for vagrant user
      mkdir -p /home/vagrant/.kube
      cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
      chown vagrant:vagrant /home/vagrant/.kube/config

      # Get node token for workers
      cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token

      # Install kubectl completion
      echo 'source <(kubectl completion bash)' >> /home/vagrant/.bashrc
      echo 'alias k=kubectl' >> /home/vagrant/.bashrc
      echo 'complete -F __start_kubectl k' >> /home/vagrant/.bashrc

      echo "K3s master installation completed!"
      echo "Cluster info:"
      kubectl get nodes
    SHELL
  end

  # Worker node configuration
  config.vm.define "k3s-worker1" do |worker|
    worker.vm.hostname = "k3s-worker1"
    worker.vm.network "private_network", ip: "192.168.56.11"
    
    worker.vm.provider "virtualbox" do |vb|
      vb.name = "k3s-worker1"
      vb.memory = "1024"
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    worker.vm.provision "shell", inline: <<-SHELL
      # Update system
      apt-get update
      apt-get upgrade -y

      # Wait for master to be ready and token to be available
      while [ ! -f /vagrant/node-token ]; do
        echo "Waiting for master node token..."
        sleep 10
      done

      # Install K3s worker
      curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.10:6443 K3S_TOKEN=$(cat /vagrant/node-token) INSTALL_K3S_EXEC="--node-ip 192.168.56.11" sh -

      echo "K3s worker1 installation completed!"
    SHELL
  end

  # Optional second worker node
  config.vm.define "k3s-worker2", autostart: false do |worker|
    worker.vm.hostname = "k3s-worker2"
    worker.vm.network "private_network", ip: "192.168.56.12"
    
    worker.vm.provider "virtualbox" do |vb|
      vb.name = "k3s-worker2"
      vb.memory = "1024"
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    worker.vm.provision "shell", inline: <<-SHELL
      # Update system
      apt-get update
      apt-get upgrade -y

      # Wait for master to be ready and token to be available
      while [ ! -f /vagrant/node-token ]; do
        echo "Waiting for master node token..."
        sleep 10
      done

      # Install K3s worker
      curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.10:6443 K3S_TOKEN=$(cat /vagrant/node-token) INSTALL_K3S_EXEC="--node-ip 192.168.56.12" sh -

      echo "K3s worker2 installation completed!"
    SHELL
  end
end
