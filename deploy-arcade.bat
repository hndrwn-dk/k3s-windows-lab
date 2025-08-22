@echo off
setlocal enabledelayedexpansion

echo ================================================
echo     🎮 KUBERNETES GAME ARCADE INSTALLER 🎮
echo     Complete Setup for K8s Learning Platform
echo ================================================
echo.

:: Check if master is running
vagrant status k3s-master | findstr "running" >nul
if %errorlevel% neq 0 (
    echo [ERROR] k3s-master is not running!
    echo Please start the cluster first using setup-k3s.bat
    echo.
    echo Would you like to start the cluster now? (y/N)
    set /p start_cluster=""
    if /i "!start_cluster!"=="y" (
        echo [INFO] Starting K3s cluster...
        call setup-k3s.bat
    ) else (
        pause
        exit /b 1
    )
)

echo [INFO] ✅ K3s cluster is running!
echo.

echo [STEP 1/5] 🏗️ Creating game namespaces...
vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: arcade
  labels:
    purpose: gaming
    environment: fun
    k8s-learning: 'true'
  annotations:
    description: 'Classic arcade games for K8s learning'
---
apiVersion: v1
kind: Namespace
metadata:
  name: educational
  labels:
    purpose: learning
    environment: educational
    k8s-learning: 'true'
  annotations:
    description: 'Educational games and tools for K8s mastery'
---
apiVersion: v1
kind: Namespace
metadata:
  name: puzzle
  labels:
    purpose: puzzle-games
    environment: fun
    k8s-learning: 'true'
  annotations:
    description: 'Puzzle games demonstrating K8s concepts'
EOF"

if %errorlevel% equ 0 (
    echo ✅ Namespaces created successfully!
) else (
    echo ❌ Failed to create namespaces
    goto error_exit
)

echo.
echo [STEP 2/5] 🎮 Deploying Game Dashboard...
vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: game-dashboard
  namespace: arcade
  labels:
    app: game-dashboard
    component: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: game-dashboard
  template:
    metadata:
      labels:
        app: game-dashboard
        component: frontend
    spec:
      containers:
      - name: dashboard
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: '32Mi'
            cpu: '25m'
          limits:
            memory: '64Mi'
            cpu: '50m'
        command: ['/bin/sh']
        args: ['-c', 'echo \"<!DOCTYPE html><html><head><title>K8s Game Arcade</title><style>*{margin:0;padding:0;box-sizing:border-box}body{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);color:#fff;font-family:Courier,monospace;min-height:100vh;padding:20px}.header{text-align:center;margin-bottom:30px}.header h1{font-size:3em;margin-bottom:10px;text-shadow:2px 2px 4px rgba(0,0,0,0.5);animation:glow 2s ease-in-out infinite alternate}@keyframes glow{from{text-shadow:2px 2px 4px rgba(0,0,0,0.5),0 0 10px #fff}to{text-shadow:2px 2px 4px rgba(0,0,0,0.5),0 0 20px #fff,0 0 30px #fff}}.games-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:20px;margin:30px 0}.game-card{background:rgba(0,0,0,0.4);border-radius:15px;padding:20px;border:2px solid rgba(255,255,255,0.2);transition:all 0.3s ease;cursor:pointer}.game-card:hover{transform:translateY(-5px);box-shadow:0 10px 25px rgba(0,0,0,0.3);border-color:#00ff88}.game-card h3{color:#00ff88;margin-bottom:10px;font-size:1.4em}.info{background:rgba(0,0,0,0.3);border-radius:10px;padding:20px;margin:20px 0}.access-info{background:rgba(0,0,0,0.5);padding:15px;border-radius:10px;margin:15px 0;border:2px solid #00ff88}</style></head><body><div class=header><h1>🎮 KUBERNETES GAME ARCADE 🎮</h1><p>Learn Kubernetes through retro gaming! Each game teaches different K8s concepts.</p></div><div class=access-info><h3>🚀 Quick Access</h3><p><strong>Game Dashboard:</strong> http://192.168.56.10:30000</p><p><strong>All games accessible at:</strong> http://192.168.56.10:[PORT]</p></div><div class=games-grid><div class=game-card><h3>🟡 Pac-Man</h3><p><strong>Port:</strong> 30001</p><p><strong>Learn:</strong> Pod networking, service discovery</p><p><strong>Difficulty:</strong> Easy</p></div><div class=game-card><h3>👾 Space Invaders</h3><p><strong>Port:</strong> 30002</p><p><strong>Learn:</strong> Security policies, cluster defense</p><p><strong>Difficulty:</strong> Medium</p></div><div class=game-card><h3>🧱 Breakout</h3><p><strong>Port:</strong> 30003</p><p><strong>Learn:</strong> Microservices, load balancing</p><p><strong>Difficulty:</strong> Medium</p></div><div class=game-card><h3>🐍 Snake</h3><p><strong>Port:</strong> 30004</p><p><strong>Learn:</strong> Horizontal scaling, HPA</p><p><strong>Difficulty:</strong> Easy</p></div><div class=game-card><h3>🧩 Tetris</h3><p><strong>Port:</strong> 30005</p><p><strong>Learn:</strong> Resource management, scheduling</p><p><strong>Difficulty:</strong> Hard</p></div><div class=game-card><h3>🎯 kubectl Trainer</h3><p><strong>Port:</strong> 30010</p><p><strong>Learn:</strong> Command line mastery</p><p><strong>Type:</strong> Educational</p></div></div><div class=info><h3>🎓 Kubernetes Concepts Covered</h3><p>🏗️ <strong>Architecture:</strong> Master/Worker nodes, Control plane</p><p>📦 <strong>Workloads:</strong> Pods, Deployments, Services</p><p>🌐 <strong>Networking:</strong> ClusterIP, NodePort, Ingress</p><p>🔒 <strong>Security:</strong> RBAC, Network Policies, Pod Security</p><p>📈 <strong>Observability:</strong> Monitoring, Metrics, Logging</p></div><div class=info><h3>🚀 Getting Started</h3><p>1. Start with the <strong>Game Dashboard</strong> for an overview</p><p>2. Try <strong>Pac-Man</strong> to learn networking basics</p><p>3. Use <strong>kubectl Trainer</strong> to practice commands</p><p>4. Challenge yourself with <strong>Tetris</strong> for advanced concepts</p></div></body></html>\" > /usr/share/nginx/html/index.html && nginx -g \"daemon off;\"']
---
apiVersion: v1
kind: Service
metadata:
  name: dashboard-service
  namespace: arcade
  labels:
    app: game-dashboard
spec:
  selector:
    app: game-dashboard
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30000
  type: NodePort
EOF"

if %errorlevel% equ 0 (
    echo ✅ Game Dashboard deployed!
) else (
    echo ❌ Failed to deploy dashboard
    goto error_exit
)

echo.
echo [STEP 3/5] 🟡 Deploying Pac-Man (Networking Demo)...
vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pacman-game
  namespace: arcade
  labels:
    app: pacman
    game-type: arcade
    k8s-concept: networking
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pacman
  template:
    metadata:
      labels:
        app: pacman
        game-type: arcade
    spec:
      containers:
      - name: pacman
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: '64Mi'
            cpu: '50m'
          limits:
            memory: '128Mi'
            cpu: '100m'
        command: ['/bin/sh']
        args: ['-c', 'cat > /usr/share/nginx/html/index.html << \"HTMLEOF\"
<!DOCTYPE html>
<html><head><title>Pac-Man K8s</title><style>body{background:#000;color:#ffff00;font-family:Courier;text-align:center;padding:20px}canvas{border:3px solid #0000ff;margin:20px}button{padding:10px 20px;background:#ffff00;color:#000;border:none;border-radius:5px;cursor:pointer;margin:5px}.info{background:#1a1a1a;padding:15px;margin:15px;border:2px solid #ffff00;border-radius:5px}</style></head><body><h1>🟡 PAC-MAN ON KUBERNETES 🟡</h1><div class=info><h3>🚀 Running on K3s Cluster</h3><p><strong>Namespace:</strong> arcade | <strong>Pod:</strong> pacman-game</p><p><strong>Learning:</strong> Pod networking and service discovery</p></div><canvas id=gameCanvas width=600 height=400></canvas><div>Score: <span id=score>0</span> | Lives: <span id=lives>3</span></div><div><button onclick=startGame()>START GAME</button> <button onclick=showHelp()>LEARN K8S</button> <button onclick=location.href=\"http://192.168.56.10:30000\">BACK TO ARCADE</button></div><script>const canvas=document.getElementById(\"gameCanvas\");const ctx=canvas.getContext(\"2d\");let pacman={x:300,y:200,size:15,dx:0,dy:0,direction:0};let dots=[];let ghosts=[];let gameRunning=false;let score=0;let lives=3;function initDots(){dots=[];for(let x=30;x<canvas.width-30;x+=40){for(let y=30;y<canvas.height-30;y+=40){if(Math.abs(x-pacman.x)>50||Math.abs(y-pacman.y)>50){dots.push({x:x,y:y,collected:false});}}}}function initGhosts(){ghosts=[{x:100,y:100,dx:2,dy:0,color:\"#ff0000\"},{x:500,y:100,dx:-2,dy:0,color:\"#ffb8ff\"},{x:100,y:300,dx:0,dy:-2,color:\"#00ffff\"}];}function drawPacman(){ctx.fillStyle=\"#ffff00\";ctx.beginPath();const mouthAngle=Math.sin(Date.now()*0.01)*0.5+0.5;const startAngle=(pacman.direction*Math.PI/2)+(mouthAngle*0.8);const endAngle=startAngle+(2*Math.PI-1.6);ctx.arc(pacman.x,pacman.y,pacman.size,startAngle,endAngle);ctx.lineTo(pacman.x,pacman.y);ctx.fill();}function drawDots(){ctx.fillStyle=\"#ffff00\";dots.forEach(dot=>{if(!dot.collected){ctx.beginPath();ctx.arc(dot.x,dot.y,3,0,2*Math.PI);ctx.fill();}});}function drawGhosts(){ghosts.forEach(ghost=>{ctx.fillStyle=ghost.color;ctx.beginPath();ctx.arc(ghost.x,ghost.y,12,0,2*Math.PI);ctx.fill();ctx.fillStyle=\"#fff\";ctx.beginPath();ctx.arc(ghost.x-4,ghost.y-4,2,0,2*Math.PI);ctx.arc(ghost.x+4,ghost.y-4,2,0,2*Math.PI);ctx.fill();});}function updateGame(){if(!gameRunning)return;ctx.clearRect(0,0,canvas.width,canvas.height);pacman.x+=pacman.dx;pacman.y+=pacman.dy;if(pacman.x<0)pacman.x=canvas.width;if(pacman.x>canvas.width)pacman.x=0;if(pacman.y<0)pacman.y=canvas.height;if(pacman.y>canvas.height)pacman.y=0;dots.forEach(dot=>{if(!dot.collected){const dist=Math.sqrt((pacman.x-dot.x)**2+(pacman.y-dot.y)**2);if(dist<20){dot.collected=true;score+=10;document.getElementById(\"score\").textContent=score;}}});ghosts.forEach(ghost=>{ghost.x+=ghost.dx;ghost.y+=ghost.dy;if(ghost.x<=15||ghost.x>=canvas.width-15)ghost.dx=-ghost.dx;if(ghost.y<=15||ghost.y>=canvas.height-15)ghost.dy=-ghost.dy;if(Math.random()<0.01){ghost.dx=(Math.random()-0.5)*4;ghost.dy=(Math.random()-0.5)*4;}const dist=Math.sqrt((pacman.x-ghost.x)**2+(pacman.y-ghost.y)**2);if(dist<25){lives--;document.getElementById(\"lives\").textContent=lives;if(lives<=0){alert(\"💀 Game Over! Pod terminated!\");resetGame();}else{pacman.x=300;pacman.y=200;pacman.dx=0;pacman.dy=0;}}});if(dots.every(dot=>dot.collected)){alert(\"🎉 Level Complete! Networking mastered!\");resetGame();}drawDots();drawPacman();drawGhosts();}function startGame(){if(gameRunning)return;gameRunning=true;initDots();initGhosts();setInterval(updateGame,1000/30);}function resetGame(){gameRunning=false;score=0;lives=3;document.getElementById(\"score\").textContent=score;document.getElementById(\"lives\").textContent=lives;pacman.x=300;pacman.y=200;pacman.dx=0;pacman.dy=0;ctx.clearRect(0,0,canvas.width,canvas.height);}function showHelp(){alert(\"🎯 Kubernetes Networking Concepts:\\n\\n• Pod Isolation: Each game runs in its own pod\\n• Service Discovery: Games find each other via DNS\\n• NodePort: External access to cluster services\\n• Container Lifecycle: Pods can be created/destroyed\\n\\nMove with arrow keys and collect dots!\");}document.addEventListener(\"keydown\",(e)=>{if(!gameRunning)return;const speed=3;switch(e.key){case \"ArrowUp\":pacman.dx=0;pacman.dy=-speed;pacman.direction=3;break;case \"ArrowDown\":pacman.dx=0;pacman.dy=speed;pacman.direction=1;break;case \"ArrowLeft\":pacman.dx=-speed;pacman.dy=0;pacman.direction=2;break;case \"ArrowRight\":pacman.dx=speed;pacman.dy=0;pacman.direction=0;break;}});resetGame();drawDots();</script></body></html>
HTMLEOF
nginx -g \"daemon off;\"']
---
apiVersion: v1
kind: Service
metadata:
  name: pacman-service
  namespace: arcade
spec:
  selector:
    app: pacman
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30001
  type: NodePort
EOF"

if %errorlevel% equ 0 (
    echo ✅ Pac-Man deployed!
) else (
    echo ❌ Failed to deploy Pac-Man
)

echo.
echo [STEP 4/5] 👾 Deploying Space Invaders (Security Demo)...
vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: space-invaders
  namespace: arcade
  labels:
    app: space-invaders
    k8s-concept: security
spec:
  replicas: 1
  selector:
    matchLabels:
      app: space-invaders
  template:
    metadata:
      labels:
        app: space-invaders
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
      containers:
      - name: space-invaders
        image: nginx:alpine
        ports:
        - containerPort: 80
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
          capabilities:
            drop: [\"ALL\"]
        command: ['/bin/sh']
        args: ['-c', 'mkdir -p /tmp/nginx && cat > /tmp/nginx/index.html << \"HTMLEOF\"
<!DOCTYPE html>
<html><head><title>Space Invaders K8s</title><style>body{background:#000;color:#00ff00;font-family:Courier;text-align:center;padding:20px}canvas{border:3px solid #00ff00;margin:20px}button{padding:10px 20px;background:#00ff00;color:#000;border:none;border-radius:5px;margin:5px;cursor:pointer}.info{background:#001100;padding:15px;margin:15px;border:2px solid #00ff00;border-radius:5px}</style></head><body><h1>👾 SPACE INVADERS - K8S SECURITY EDITION 👾</h1><div class=info><h3>🛡️ Cluster Defense Mission</h3><p><strong>Objective:</strong> Protect your pods from malicious containers!</p><p><strong>Security:</strong> Non-root user, no privileges, read-only filesystem</p></div><canvas id=gameCanvas width=800 height=500></canvas><div>Score: <span id=score>0</span> | Lives: <span id=lives>3</span> | Pods Saved: <span id=pods>0</span></div><div><button onclick=startGame()>DEPLOY DEFENSES</button> <button onclick=showSecurity()>LEARN SECURITY</button> <button onclick=location.href=\"http://192.168.56.10:30000\">BACK TO ARCADE</button></div><script>const canvas=document.getElementById(\"gameCanvas\");const ctx=canvas.getContext(\"2d\");let player={x:400,y:450,width:40,height:20,dx:0};let bullets=[];let invaders=[];let gameRunning=false;let score=0;let lives=3;let pods=0;function initInvaders(){invaders=[];for(let row=0;row<5;row++){for(let col=0;col<10;col++){invaders.push({x:50+col*60,y:50+row*40,width:30,height:20,alive:true,type:row%3});}}}function drawPlayer(){ctx.fillStyle=\"#00ff00\";ctx.fillRect(player.x-player.width/2,player.y,player.width,player.height);ctx.fillStyle=\"#ffffff\";ctx.font=\"10px Courier\";ctx.fillText(\"kubectl\",player.x-15,player.y+15);}function drawInvaders(){const colors=[\"#ff0000\",\"#ffff00\",\"#ff00ff\"];invaders.forEach(invader=>{if(invader.alive){ctx.fillStyle=colors[invader.type];ctx.fillRect(invader.x,invader.y,invader.width,invader.height);ctx.fillStyle=\"#ffffff\";ctx.font=\"8px Courier\";ctx.fillText(\"🐳\",invader.x+8,invader.y+15);}});}function drawBullets(){ctx.fillStyle=\"#00ffff\";bullets.forEach(bullet=>{ctx.fillRect(bullet.x-2,bullet.y,4,10);});}function updateGame(){if(!gameRunning)return;ctx.clearRect(0,0,canvas.width,canvas.height);player.x+=player.dx;if(player.x<20)player.x=20;if(player.x>canvas.width-20)player.x=canvas.width-20;bullets=bullets.filter(bullet=>{bullet.y-=8;if(bullet.y<0)return false;for(let invader of invaders){if(invader.alive&&bullet.x>invader.x&&bullet.x<invader.x+invader.width&&bullet.y>invader.y&&bullet.y<invader.y+invader.height){invader.alive=false;score+=10;pods++;document.getElementById(\"score\").textContent=score;document.getElementById(\"pods\").textContent=pods;return false;}}return true;});let moveDown=false;invaders.forEach(invader=>{if(invader.alive){invader.x+=1;if(invader.x>canvas.width-50){moveDown=true;}}});if(moveDown){invaders.forEach(invader=>{if(invader.alive)invader.y+=20;});}if(invaders.every(invader=>!invader.alive)){alert(\"🎉 Cluster Secured! All threats eliminated!\");resetGame();}drawPlayer();drawInvaders();drawBullets();}function startGame(){if(gameRunning)return;gameRunning=true;initInvaders();setInterval(updateGame,1000/60);}function resetGame(){gameRunning=false;score=0;lives=3;pods=0;bullets=[];document.getElementById(\"score\").textContent=score;document.getElementById(\"lives\").textContent=lives;document.getElementById(\"pods\").textContent=pods;player.x=400;player.dx=0;ctx.clearRect(0,0,canvas.width,canvas.height);}function showSecurity(){alert(\"🛡️ Kubernetes Security Concepts:\\n\\n• Pod Security Context: Run as non-root\\n• Capabilities: Drop unnecessary privileges\\n• Read-only filesystem: Prevent tampering\\n• Network Policies: Control traffic flow\\n• RBAC: Role-based access control\\n\\nUse A/D to move, SPACE to fire!\");}document.addEventListener(\"keydown\",(e)=>{if(!gameRunning)return;switch(e.key){case \"ArrowLeft\":case \"a\":player.dx=-5;break;case \"ArrowRight\":case \"d\":player.dx=5;break;case \"\":e.preventDefault();if(bullets.length<3)bullets.push({x:player.x,y:player.y});break;}});document.addEventListener(\"keyup\",(e)=>{if(e.key===\"ArrowLeft\"||e.key===\"a\"||e.key===\"ArrowRight\"||e.key===\"d\")player.dx=0;});resetGame();</script></body></html>
HTMLEOF
nginx -g \"daemon off;\"']
---
apiVersion: v1
kind: Service
metadata:
  name: space-invaders-service
  namespace: arcade
spec:
  selector:
    app: space-invaders
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30002
  type: NodePort
EOF"

if %errorlevel% equ 0 (
    echo ✅ Space Invaders deployed with security features!
) else (
    echo ❌ Failed to deploy Space Invaders
)

echo.
echo [STEP 5/5] 🎯 Deploying kubectl Trainer...
vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubectl-trainer
  namespace: educational
  labels:
    app: kubectl-trainer
    k8s-concept: cli-training
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kubectl-trainer
  template:
    metadata:
      labels:
        app: kubectl-trainer
    spec:
      containers:
      - name: trainer
        image: nginx:alpine
        ports:
        - containerPort: 80
        command: ['/bin/sh']
        args: ['-c', 'cat > /usr/share/nginx/html/index.html << \"HTMLEOF\"
<!DOCTYPE html>
<html><head><title>kubectl Trainer</title><style>body{background:#2c3e50;color:#ecf0f1;font-family:Courier;padding:20px;text-align:center}.terminal{background:#000;color:#00ff00;padding:20px;border-radius:10px;margin:20px 0;font-family:monospace;text-align:left;height:300px;overflow-y:auto}.command{background:#34495e;padding:10px;margin:10px;border-radius:5px;cursor:pointer;display:inline-block}.command:hover{background:#4a6741}button{padding:10px 20px;background:#3498db;color:#fff;border:none;border-radius:5px;margin:5px;cursor:pointer}.info{background:#34495e;padding:15px;margin:15px;border-radius:5px}</style></head><body><h1>🎯 KUBECTL TRAINING SIMULATOR 🎯</h1><div class=info><h3>🚀 Master Kubernetes CLI</h3><p>Practice kubectl commands in a safe environment!</p><p>Click commands below or use the terminal simulation</p></div><div class=terminal id=terminal>Welcome to kubectl trainer!<br>Click commands below to see their output:<br><br>$ _</div><div><div class=command onclick=runCommand(\"kubectl get nodes\")>kubectl get nodes</div><div class=command onclick=runCommand(\"kubectl get pods -A\")>kubectl get pods -A</div><div class=command onclick=runCommand(\"kubectl get services -A\")>kubectl get services -A</div><div class=command onclick=runCommand(\"kubectl get namespaces\")>kubectl get namespaces</div></div><div><div class=command onclick=runCommand(\"kubectl describe nodes\")>kubectl describe nodes</div><div class=command onclick=runCommand(\"kubectl get events -A\")>kubectl get events -A</div><div class=command onclick=runCommand(\"kubectl top nodes\")>kubectl top nodes</div><div class=command onclick=runCommand(\"kubectl get all -n arcade\")>kubectl get all -n arcade</div></div><div><button onclick=clearTerminal()>CLEAR TERMINAL</button> <button onclick=showHelp()>SHOW HELP</button> <button onclick=startChallenge()>START CHALLENGE</button> <button onclick=location.href=\"http://192.168.56.10:30000\">BACK TO ARCADE</button></div><script>let commandHistory=[];function runCommand(cmd){const terminal=document.getElementById(\"terminal\");terminal.innerHTML+=\"<br>$ \"+cmd+\"<br>\";commandHistory.push(cmd);switch(cmd){case \"kubectl get nodes\":terminal.innerHTML+=\"NAME         STATUS   ROLES                  AGE   VERSION<br>k3s-master   Ready    control-plane,master   1d    v1.32.6+k3s1<br>k3s-worker1  Ready    &lt;none&gt;                 1d    v1.32.6+k3s1<br>\";break;case \"kubectl get pods -A\":terminal.innerHTML+=\"NAMESPACE     NAME                      READY   STATUS    RESTARTS<br>arcade        pacman-game-xxx           1/1     Running   0<br>arcade        space-invaders-xxx        1/1     Running   0<br>arcade        game-dashboard-xxx        1/1     Running   0<br>educational   kubectl-trainer-xxx       1/1     Running   0<br>kube-system   traefik-xxx               1/1     Running   0<br>\";break;case \"kubectl get services -A\":terminal.innerHTML+=\"NAMESPACE     NAME                    TYPE        CLUSTER-IP      PORT(S)<br>arcade        pacman-service          NodePort    10.43.123.45    80:30001/TCP<br>arcade        space-invaders-service  NodePort    10.43.123.46    80:30002/TCP<br>arcade        dashboard-service       NodePort    10.43.123.47    80:30000/TCP<br>educational   kubectl-trainer-service NodePort    10.43.123.48    80:30010/TCP<br>\";break;case \"kubectl get namespaces\":terminal.innerHTML+=\"NAME          STATUS   AGE<br>default       Active   1d<br>arcade        Active   1h<br>educational   Active   1h<br>kube-system   Active   1d<br>\";break;case \"kubectl describe nodes\":terminal.innerHTML+=\"Name:               k3s-master<br>Roles:              control-plane,master<br>Conditions:         Ready<br>Capacity:           cpu: 2, memory: 2Gi<br>Allocatable:        cpu: 2, memory: 1.8Gi<br><br>Name:               k3s-worker1<br>Roles:              &lt;none&gt;<br>Conditions:         Ready<br>Capacity:           cpu: 1, memory: 1Gi<br>\";break;case \"kubectl get events -A\":terminal.innerHTML+=\"NAMESPACE   LAST SEEN   TYPE     REASON    OBJECT<br>arcade      1m          Normal   Created   pod/pacman-game-xxx<br>arcade      1m          Normal   Started   pod/space-invaders-xxx<br>\";break;case \"kubectl top nodes\":terminal.innerHTML+=\"NAME         CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%<br>k3s-master   150m         7%     800Mi           44%<br>k3s-worker1  100m         10%    400Mi           40%<br>\";break;case \"kubectl get all -n arcade\":terminal.innerHTML+=\"NAME                         READY   STATUS    RESTARTS   AGE<br>pod/pacman-game-xxx          1/1     Running   0          5m<br>pod/space-invaders-xxx       1/1     Running   0          3m<br>pod/game-dashboard-xxx       1/1     Running   0          8m<br><br>NAME                             TYPE       CLUSTER-IP     PORT(S)<br>service/pacman-service           NodePort   10.43.123.45   80:30001/TCP<br>service/space-invaders-service   NodePort   10.43.123.46   80:30002/TCP<br>service/dashboard-service        NodePort   10.43.123.47   80:30000/TCP<br>\";break;default:terminal.innerHTML+=\"Command executed successfully!<br>Try the commands above to explore the cluster.<br>\";}terminal.scrollTop=terminal.scrollHeight;}function clearTerminal(){document.getElementById(\"terminal\").innerHTML=\"kubectl trainer ready! Click commands above to practice.<br>$ _\";}function showHelp(){const terminal=document.getElementById(\"terminal\");terminal.innerHTML+=\"<br>=== KUBECTL COMMAND REFERENCE ===<br><br><strong>Resource Management:</strong><br>• kubectl get [resource] - List resources<br>• kubectl describe [resource] [name] - Detailed info<br>• kubectl apply -f [file] - Create/update resources<br>• kubectl delete [resource] [name] - Remove resources<br><br><strong>Common Resources:</strong><br>• nodes - Cluster machines<br>• pods - Running containers<br>• services - Network endpoints<br>• deployments - Pod management<br>• namespaces - Resource isolation<br><br><strong>Useful Flags:</strong><br>• -A, --all-namespaces - All namespaces<br>• -o wide - More details<br>• -w, --watch - Watch for changes<br>• -l, --selector - Filter by labels<br><br>\";}function startChallenge(){alert(\"🎯 kubectl Challenge!\\n\\n1. Find all running game pods\\n2. Get the NodePort for each service\\n3. Check which nodes the pods are running on\\n4. View the resource usage\\n\\nUse the commands above to complete the challenge!\");}</script></body></html>
HTMLEOF
cp /tmp/nginx/index.html /usr/share/nginx/html/ && nginx -g \"daemon off;\"']
---
apiVersion: v1
kind: Service
metadata:
  name: kubectl-trainer-service
  namespace: educational
spec:
  selector:
    app: kubectl-trainer
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30010
  type: NodePort
EOF"

if %errorlevel% equ 0 (
    echo ✅ kubectl Trainer deployed!
) else (
    echo ❌ Failed to deploy kubectl Trainer
)

echo.
echo [INFO] ⏳ Waiting for all pods to be ready...
vagrant ssh k3s-master -c "kubectl wait --for=condition=Ready pod -l app=game-dashboard -n arcade --timeout=120s"
vagrant ssh k3s-master -c "kubectl wait --for=condition=Ready pod -l app=pacman -n arcade --timeout=120s"
vagrant ssh k3s-master -c "kubectl wait --for=condition=Ready pod -l app=space-invaders -n arcade --timeout=120s"
vagrant ssh k3s-master -c "kubectl wait --for=condition=Ready pod -l app=kubectl-trainer -n educational --timeout=120s"

echo.
echo ================================================
echo     🎉 KUBERNETES GAME ARCADE DEPLOYED! 🎉
echo ================================================
echo.
echo 🎮 ACCESS YOUR GAMES:
echo ================================
echo 🏠 Main Dashboard:    http://192.168.56.10:30000
echo 🟡 Pac-Man:           http://192.168.56.10:30001
echo 👾 Space Invaders:    http://192.168.56.10:30002
echo 🎯 kubectl Trainer:   http://192.168.56.10:30010
echo.
echo 🎓 LEARNING PATH:
echo ================================
echo 1. Start with the Dashboard for an overview
echo 2. Play Pac-Man to learn networking basics
echo 3. Try Space Invaders for security concepts
echo 4. Use kubectl Trainer to practice commands
echo.
echo 🚀 WHAT'S DEPLOYED:
echo ================================
vagrant ssh k3s-master -c "kubectl get all -n arcade,educational"
echo.
echo 💡 TIP: Use fun-games.bat for more games and management options!
echo.
echo ================================================
echo     Happy Learning with Kubernetes! 🚀
echo ================================================

pause
exit /b 0

:error_exit
echo.
echo [ERROR] Deployment failed! Check the error messages above.
echo Try running the individual game deployments from fun-games.bat
pause
exit /b 1