# 🎮 Kubernetes Game Arcade - Learn K8s Through Gaming!

> 🚀 **The most fun way to learn Kubernetes! Retro games + K8s education on Windows 11**

[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Gaming](https://img.shields.io/badge/Gaming-FF6B6B?style=for-the-badge&logo=gamepad&logoColor=white)](#games)
[![Education](https://img.shields.io/badge/Education-4ECDC4?style=for-the-badge&logo=graduation-cap&logoColor=white)](#learning)
[![Vagrant](https://img.shields.io/badge/Vagrant-1868F2?style=for-the-badge&logo=vagrant&logoColor=white)](https://www.vagrantup.com/)
[![VirtualBox](https://img.shields.io/badge/VirtualBox-183A61?style=for-the-badge&logo=virtualbox&logoColor=white)](https://www.virtualbox.org/)
[![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows/)

**Learn Kubernetes through classic retro games!** This project transforms K3s cluster management into an engaging gaming experience. Each game teaches different Kubernetes concepts while you have fun playing nostalgic arcade classics.

## ☕ Support Me

If you find this project helpful, you can support me here:

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-yellow?style=for-the-badge&logo=buymeacoffee&logoColor=white)](https://buymeacoffee.com/hendrawan)


## 🎮 Games & Learning Features

- 🕹️ **Retro Game Arcade**: Pac-Man, Space Invaders, Breakout, Snake, Tetris & more!
- 🎓 **Educational Integration**: Each game teaches specific Kubernetes concepts
- 🎯 **Interactive Learning**: kubectl trainer, cluster monitoring games
- 🏗️ **Proper K8s Architecture**: Real deployments, services, ingress, security policies
- 🎪 **Game Dashboard**: Central hub to access all games and learning materials
- 🛡️ **Security Demos**: Games that demonstrate pod security, RBAC, network policies

## ✨ Technical Features

- 🎯 **Automated K3s Installation**: One-click cluster deployment
- 🖥️ **Multi-Node Support**: Master + up to 2 worker nodes
- 🎮 **Interactive Management**: Enhanced gaming-focused batch scripts
- 🪟 **Windows Integration**: kubectl setup and kubeconfig export for Windows
- 🔧 **Flexible Deployment**: Individual games or full arcade deployment
- 🌐 **NodePort Access**: Direct game access from Windows host

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

## 🚀 Quick Start - Deploy Your Game Arcade!

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/hndrwn-dk/k3s-windows-lab.git
cd k3s-windows-lab
```

### 2️⃣ Setup Your K3s Cluster
```cmd
setup-k3s.bat
```
Choose **Option 1** (Standard cluster) - 🌟 Recommended for gaming

### 3️⃣ Deploy the Game Arcade! 🎮
```cmd
deploy-arcade.bat
```
This deploys the complete gaming experience with educational content!

**OR** use the enhanced games menu:
```cmd
fun-games.bat
```

### 4️⃣ Start Playing & Learning! 🎓
- 🏠 **Main Dashboard**: http://192.168.56.10:30000
- 🟡 **Pac-Man** (Networking): http://192.168.56.10:30001
- 👾 **Space Invaders** (Security): http://192.168.56.10:30002
- 🎯 **kubectl Trainer**: http://192.168.56.10:30010

> **Installation Time**: 5-10 minutes for cluster + 2-3 minutes for games

## 🎮 Available Games & Learning Modules

### 🕹️ Arcade Games
| Game | Difficulty | K8s Concept | Port | Description |
|------|------------|-------------|------|-------------|
| 🟡 **Pac-Man** | Easy | Networking | 30001 | Learn pod networking and service discovery |
| 👾 **Space Invaders** | Medium | Security | 30002 | Master pod security and cluster defense |
| 🧱 **Breakout** | Medium | Microservices | 30003 | Break monoliths into microservices |
| 🐍 **Snake** | Easy | Scaling | 30004 | Understand horizontal pod autoscaling |
| 🧩 **Tetris** | Hard | Resources | 30005 | Master resource management and scheduling |
| 🐸 **Frogger** | Medium | Traffic | 30006 | Navigate network policies and traffic |

### 🎓 Educational Tools
| Tool | Purpose | Port | Features |
|------|---------|------|----------|
| 🏠 **Game Dashboard** | Main Hub | 30000 | Overview of all games and concepts |
| 🎯 **kubectl Trainer** | CLI Practice | 30010 | Interactive command line training |
| 📊 **Cluster Monitor** | Observability | 30020 | Real-time metrics visualization |

### 🎪 Game Management
The enhanced `fun-games.bat` script provides 20+ options including:
- Individual game deployment
- Full arcade setup
- Game management tools
- Troubleshooting utilities
- Educational content

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

### 🎮 Game Arcade Deployer
Deploy the complete gaming experience:
```cmd
deploy-arcade.bat
```
**Includes:**
- Complete game arcade setup
- Educational content integration
- Proper Kubernetes manifests
- Security policy demonstrations
- Resource management examples
- Interactive learning tools

### 🕹️ Enhanced Game Manager
Comprehensive game management:
```cmd
fun-games.bat
```
**Features:**
- 20+ deployment and management options
- Individual game controls
- Cluster monitoring games
- kubectl training simulator
- Troubleshooting utilities

## 🔧 Using kubectl from Windows

### 🎯 Option A: Use the Script (Recommended)
1. Run `setup-k3s.bat`
2. Choose option **13** to download kubectl
3. Choose option **12** to export kubeconfig
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

## 🎮 Playing & Learning

### 🚀 Quick Arcade Setup
```cmd
# Deploy the complete game arcade
deploy-arcade.bat
```
This will:
- Create gaming namespaces (arcade, educational, puzzle)
- Deploy core games with educational content
- Set up the main dashboard
- Configure proper K8s resources
- Provide access URLs for all games

### 🕹️ Individual Game Management
```cmd
# Interactive games menu with 20+ options
fun-games.bat
```
Choose from:
- Individual game deployment
- Educational modules
- Cluster monitoring tools
- kubectl training simulator
- Game management utilities

### 🎓 Learning Path Recommendations
1. **Start Here**: Game Dashboard (Port 30000)
2. **Networking**: Pac-Man game (Port 30001)
3. **Security**: Space Invaders (Port 30002)  
4. **CLI Practice**: kubectl Trainer (Port 30010)
5. **Advanced**: Tetris for resource management

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
├── README.md                  # Documentation
├── setup-k3s.bat              # Cluster setup
├── deploy-arcade.bat          # 🎮 Full arcade installer
├── fun-games.bat              # 🕹️ Enhanced game manager (20+ options)
├── check-components.bat       # Health checker  
├── quick-examples.bat         # Sample apps
├── Vagrantfile                # VM configuration
├── games/                     # 🎮 Game content & manifests
│   ├── manifests/             # Kubernetes YAML files
│   ├── web-content/           # Game HTML/JS files
│   ├── arcade/                # Classic arcade games
│   ├── puzzle/                # Puzzle games
│   └── educational/           # Learning-focused content
├── LICENSE.md                 # MIT license
└── .gitignore                 # Git rules
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

For more detailed troubleshooting, check our GitHub issues or discussions.

## 🎓 Educational Benefits

### 🎮 Learn Through Play
- **Hands-on Experience**: Real Kubernetes deployments, not simulations
- **Visual Learning**: See abstract concepts through game mechanics
- **Progressive Difficulty**: Start easy, advance to complex topics
- **Immediate Feedback**: Games respond to your K8s knowledge

### 📚 Kubernetes Concepts Covered
| Concept | Games Teaching It | Practical Skills |
|---------|-------------------|------------------|
| **Networking** | Pac-Man, Frogger | Services, DNS, NodePort, ClusterIP |
| **Security** | Space Invaders | Pod security, RBAC, Network policies |
| **Scaling** | Snake, Tetris | HPA, resource limits, scheduling |
| **Architecture** | Breakout | Microservices, load balancing |
| **CLI Mastery** | kubectl Trainer | Command practice, troubleshooting |
| **Observability** | Cluster Monitor | Metrics, logging, health checks |

## 🛠️ Technical Stack

- ☸️ **K3s v1.32.6**: Lightweight Kubernetes distribution
- 📦 **containerd**: Container runtime
- 🌐 **Traefik**: Ingress controller (default)
- 🔍 **CoreDNS**: Cluster DNS
- 📊 **Metrics Server**: Resource metrics API
- 💾 **Local Path Provisioner**: Dynamic volume provisioning
- 🎮 **Game Engine**: HTML5 Canvas + JavaScript
- 🏗️ **Manifests**: Proper Kubernetes YAML configurations

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

- 🐛 Create an [issue](https://github.com/hndrwn-dk/k3s-windows-lab/issues) for bug reports
- 💬 Start a [discussion](https://github.com/hndrwn-dk/k3s-windows-lab/discussions) for questions
- 📖 Check the troubleshooting section above for common issues

---

⭐ **Star this repository if it helped you!** ⭐