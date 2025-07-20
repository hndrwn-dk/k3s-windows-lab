# ⚙️ K3s Kubernetes Lab on Windows 11

> 🚀 **Automated K3s Kubernetes cluster setup for Windows 11 using Vagrant & VirtualBox**

[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Vagrant](https://img.shields.io/badge/Vagrant-1868F2?style=for-the-badge&logo=vagrant&logoColor=white)](https://www.vagrantup.com/)
[![VirtualBox](https://img.shields.io/badge/VirtualBox-183A61?style=for-the-badge&logo=virtualbox&logoColor=white)](https://www.virtualbox.org/)
[![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows/)

A complete automated setup for running a K3s Kubernetes cluster on Windows 11 using Vagrant and VirtualBox.

## ✨ Features

- 🎯 **Automated K3s Installation**: One-click cluster deployment
- 🖥️ **Multi-Node Support**: Master + up to 2 worker nodes
- 🎮 **Interactive Management**: Easy-to-use batch script with menu system
- 🪟 **Windows Integration**: kubectl setup and kubeconfig export for Windows
- 🔧 **Flexible Deployment**: Start individual nodes or full clusters
- 🌐 **Port Forwarding**: Access cluster services from Windows host

## 📋 Prerequisites

- 🪟 Windows 11
- 📦 [Vagrant](https://www.vagrantup.com/downloads) 2.4.6+
- 💻 [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 6.1+
- 🧠 At least 4GB RAM available for VMs
- 🌐 Internet connection for downloading base images

## 🏗️ Architecture

| Component | IP Address | Resources | Role |
|-----------|------------|-----------|------|
| 🎯 k3s-master | 192.168.56.10 | 2GB RAM, 2 CPU | Control Plane |
| 👷 k3s-worker1 | 192.168.56.11 | 1GB RAM, 1 CPU | Worker Node |
| 👷 k3s-worker2 | 192.168.56.12 | 1GB RAM, 1 CPU | Worker Node (Optional) |

### 🔌 Port Forwards
- **6443**: Kubernetes API Server
- **8080**: HTTP services (port 80 in cluster)
- **8443**: HTTPS services (port 443 in cluster)

## 🚀 Quick Start

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/hndrwn-dk/k3s-windows-lab.git
cd k3s-windows-lab
```

### 2️⃣ Run the Setup Script
```cmd
setup-k3s.bat
```
> **Note**: The script works in the current directory (no subdirectories created)

### 3️⃣ Choose Your Configuration
- **Option 1**: Standard cluster (master + 1 worker) - 🌟 Recommended
- **Option 2**: Full cluster (master + 2 workers)
- **Option 3**: Master only (minimal setup)

### 4️⃣ Wait for Installation
- ⏬ First run downloads Ubuntu 22.04 image (~700MB)
- ⚙️ K3s installation takes 5-10 minutes
- ✅ Cluster ready when both nodes show "Ready" status

## 🎮 Management Options

The interactive script provides these options:

```
1️⃣  Start full cluster (master + 1 worker)
2️⃣  Start full cluster (master + 2 workers)
3️⃣  Start master only
4️⃣  Start worker1 only
5️⃣  Start worker2 only
6️⃣  Stop all VMs
7️⃣  Destroy all VMs
8️⃣  Check cluster status
9️⃣  SSH to master
🔟  SSH to worker1
1️⃣1️⃣  SSH to worker2
1️⃣2️⃣  Get kubeconfig
1️⃣3️⃣  Install kubectl on Windows
0️⃣  Exit
```

## 🛠️ Additional Helper Scripts

### 🔍 Component Status Checker
Quick health check for all K3s components:
```cmd
check-components.bat
```
**Features:**
- Real-time status of all system components
- Resource usage monitoring (CPU/Memory)
- Automated functionality testing
- DNS resolution testing
- Storage provisioning verification

### 🎯 Quick Examples Deployer
Deploy sample applications instantly:
```cmd
quick-examples.bat
```
**Includes:**
- Web applications with Traefik ingress
- Apps with persistent storage
- Load balancer demonstrations
- DNS testing tools
- Multi-pod applications
- Easy cleanup options

## 🔧 Using kubectl from Windows

### 🎯 Option A: Use the Script (Recommended)
1. Run `setup-k3s.bat`
2. Choose option **1️⃣3️⃣** to download kubectl
3. Choose option **1️⃣2️⃣** to export kubeconfig
4. Add kubectl to your PATH or use full path

### ⚙️ Option B: Manual Setup
```cmd
# Download kubectl
curl -LO "https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe"

# Export kubeconfig
vagrant ssh k3s-master -c "cat /home/vagrant/.kube/config" > kubeconfig

# Set environment variable
set KUBECONFIG=%CD%\kubeconfig
```

## 🧪 Testing Your Cluster

### 🚀 Quick Component Check
```cmd
# Check all components status
check-components.bat
```
This script will:
- Verify all K3s components are running
- Test DNS resolution
- Check resource usage
- Validate storage provisioning
- Provide useful commands

### 🎯 Deploy Sample Applications
```cmd
# Interactive examples menu
quick-examples.bat
```
Choose from ready-to-deploy examples:
- Web apps with ingress
- Apps with persistent storage
- Load balancer demos
- DNS testing tools

### 🛠️ Manual Testing
```bash
# SSH to master
vagrant ssh k3s-master

# Deploy nginx
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort

# Check deployment
kubectl get pods
kubectl get svc nginx
```

### 🌐 Access from Windows
```cmd
# Check cluster status
kubectl get nodes

# View all pods
kubectl get pods -A

# Port forward to access nginx
kubectl port-forward svc/nginx 8080:80
# Then visit http://localhost:8080
```

## 📁 File Structure

```
k3s-windows-lab/
├── README.md                 # This file
├── setup-k3s.bat            # Main automation script
├── Vagrantfile               # VM configuration
├── docs/
│   ├── troubleshooting.md    # Common issues and solutions
│   ├── advanced-usage.md     # Advanced configurations
│   └── examples/             # Example deployments
└── .gitignore                # Git ignore file
```

## 🔍 Common Commands

### 📦 Vagrant Management
```cmd
vagrant status                # Check VM status
vagrant up k3s-master        # Start master only
vagrant halt                 # Stop all VMs
vagrant destroy -f           # Delete all VMs
vagrant reload               # Restart VMs
```

### ☸️ Cluster Operations
```bash
kubectl get nodes            # List cluster nodes
kubectl get pods -A          # List all pods
kubectl cluster-info         # Cluster information
kubectl top nodes            # Resource usage
```

### 🛠️ Helper Scripts
```cmd
setup-k3s.bat               # Main cluster management
check-components.bat        # Component health check
quick-examples.bat          # Deploy sample apps
```

## 🛠️ Troubleshooting

### 🚫 VM Won't Start
- Ensure VirtualBox is running
- Check available RAM (need 4GB+)
- Try `vagrant reload`

### 🌐 Network Issues
- Verify Windows Firewall settings
- Check VirtualBox host-only network adapter
- Try `vagrant reload --provision`

### ⏳ Cluster Not Ready
- Wait 2-3 minutes after startup
- Check K3s logs: `vagrant ssh k3s-master -c "journalctl -u k3s"`
- Restart K3s: `vagrant ssh k3s-master -c "sudo systemctl restart k3s"`

For more detailed troubleshooting, see [docs/troubleshooting.md](docs/troubleshooting.md).

## 🎓 What's Included

- ☸️ **K3s v1.32.6**: Lightweight Kubernetes distribution
- 📦 **containerd**: Container runtime
- 🌐 **Traefik**: Ingress controller (default)
- 🔍 **CoreDNS**: Cluster DNS
- 📊 **Metrics Server**: Resource metrics API
- 💾 **Local Path Provisioner**: Dynamic volume provisioning

## 🤝 Contributing

1. 🍴 Fork the repository
2. 🌿 Create a feature branch (`git checkout -b feature/amazing-feature`)
3. 💾 Commit your changes (`git commit -m 'Add amazing feature'`)
4. 📤 Push to the branch (`git push origin feature/amazing-feature`)
5. 🔄 Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [K3s](https://k3s.io/) - Lightweight Kubernetes
- [Vagrant](https://www.vagrantup.com/) - Development environment automation
- [VirtualBox](https://www.virtualbox.org/) - Virtualization platform

## 📞 Support

- 🐛 Create an [issue](https://github.com/yourusername/k3s-windows-lab/issues) for bug reports
- 💬 Start a [discussion](https://github.com/yourusername/k3s-windows-lab/discussions) for questions
- 📖 Check [troubleshooting guide](docs/troubleshooting.md) for common issues

---

⭐ **Star this repository if it helped you!** ⭐