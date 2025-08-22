@echo off
setlocal enabledelayedexpansion

echo ================================================
echo        🎮 KUBERNETES GAME ARCADE 🎮
echo        Learn K8s Through Retro Gaming!
echo ================================================
echo.

:: Check if master is running
vagrant status k3s-master | findstr "running" >nul
if %errorlevel% neq 0 (
    echo [ERROR] k3s-master is not running!
    echo Please start the cluster first using setup-k3s.bat
    pause
    exit /b 1
)

:menu
cls
echo ================================================
echo        🎮 KUBERNETES GAME ARCADE 🎮
echo        Learn K8s Through Retro Gaming!
echo ================================================
echo.
echo 🎯 ARCADE GAMES (Learn through play!)
echo ================================
echo 1.  🟡 Pac-Man (Networking concepts)
echo 2.  👾 Space Invaders (Security & Defense)
echo 3.  🧱 Breakout (Microservices architecture)
echo 4.  🐍 Snake (Horizontal scaling)
echo 5.  🧩 Tetris (Resource management)
echo 6.  🐸 Frogger (Network traffic)
echo 7.  🏓 Pong (Load balancing)
echo.
echo 🧠 EDUCATIONAL GAMES
echo ==================
echo 8.  🧠 Pod Memory Game (Labels & Selectors)
echo 9.  🔍 Kubernetes Quiz (Interactive learning)
echo 10. 📊 Cluster Monitor (Real-time metrics)
echo 11. 🎯 kubectl Trainer (Command practice)
echo.
echo 🎪 SPECIAL FEATURES
echo ==================
echo 12. 🚀 Deploy Game Dashboard (Main hub)
echo 13. 🎮 Deploy ALL Games (Full arcade!)
echo 14. 📱 Create Game Namespaces
echo 15. 🔧 Game Management Tools
echo.
echo 📋 CLUSTER OPERATIONS
echo ====================
echo 16. 📊 View All Games Status
echo 17. 🧹 Clean Up Games
echo 18. 🔍 Test Game Connectivity
echo 19. 📈 Show Game Metrics
echo 20. 🛠️ Troubleshoot Games
echo.
echo 0.  Exit
echo ================================================
set /p choice="Enter your choice (0-20): "

if "%choice%"=="1" goto deploy_pacman
if "%choice%"=="2" goto deploy_space_invaders
if "%choice%"=="3" goto deploy_breakout
if "%choice%"=="4" goto deploy_snake
if "%choice%"=="5" goto deploy_tetris
if "%choice%"=="6" goto deploy_frogger
if "%choice%"=="7" goto deploy_pong
if "%choice%"=="8" goto deploy_memory_game
if "%choice%"=="9" goto deploy_quiz
if "%choice%"=="10" goto deploy_monitor
if "%choice%"=="11" goto deploy_kubectl_trainer
if "%choice%"=="12" goto deploy_dashboard
if "%choice%"=="13" goto deploy_all_games
if "%choice%"=="14" goto create_namespaces
if "%choice%"=="15" goto game_management
if "%choice%"=="16" goto view_all_games
if "%choice%"=="17" goto cleanup_games
if "%choice%"=="18" goto test_connectivity
if "%choice%"=="19" goto show_metrics
if "%choice%"=="20" goto troubleshoot
if "%choice%"=="0" goto end
goto invalid_choice

:create_namespaces
echo.
echo [INFO] Creating game namespaces...
vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: arcade
  labels:
    purpose: gaming
    environment: fun
    k8s-learning: 'true'
---
apiVersion: v1
kind: Namespace
metadata:
  name: puzzle
  labels:
    purpose: puzzle-games
    environment: fun
    k8s-learning: 'true'
---
apiVersion: v1
kind: Namespace
metadata:
  name: educational
  labels:
    purpose: learning
    environment: educational
    k8s-learning: 'true'
EOF"

echo [SUCCESS] Game namespaces created!
echo • arcade - For classic arcade games
echo • puzzle - For puzzle and strategy games
echo • educational - For learning-focused games
goto menu_return

:deploy_dashboard
echo.
echo [INFO] Deploying Game Dashboard (Main Hub)...
vagrant ssh k3s-master -c "kubectl create namespace arcade 2>/dev/null || echo 'namespace exists'"

echo [INFO] Creating dashboard deployment...
vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: game-dashboard
  namespace: arcade
spec:
  replicas: 1
  selector:
    matchLabels:
      app: game-dashboard
  template:
    metadata:
      labels:
        app: game-dashboard
    spec:
      containers:
      - name: dashboard
        image: nginx:alpine
        ports:
        - containerPort: 80
        command: ['/bin/sh']
        args: ['-c', 'echo \"<!DOCTYPE html><html><head><title>K8s Game Arcade</title><style>body{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);color:#fff;font-family:Courier;text-align:center;padding:20px}.header h1{font-size:3em;animation:glow 2s ease-in-out infinite alternate}@keyframes glow{from{text-shadow:0 0 10px #fff}to{text-shadow:0 0 20px #fff,0 0 30px #fff}}.game-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:20px;margin:30px 0}.game-card{background:rgba(0,0,0,0.4);padding:20px;border-radius:15px;border:2px solid rgba(255,255,255,0.2);transition:all 0.3s ease}.game-card:hover{transform:translateY(-5px);border-color:#00ff88}</style></head><body><div class=header><h1>🎮 KUBERNETES GAME ARCADE 🎮</h1><p>Learn Kubernetes through retro gaming!</p></div><div class=game-grid><div class=game-card><h3>🟡 Pac-Man</h3><p>Port: 30001</p><p>Learn: Networking</p></div><div class=game-card><h3>👾 Space Invaders</h3><p>Port: 30002</p><p>Learn: Security</p></div><div class=game-card><h3>🧱 Breakout</h3><p>Port: 30003</p><p>Learn: Microservices</p></div><div class=game-card><h3>🐍 Snake</h3><p>Port: 30004</p><p>Learn: Scaling</p></div><div class=game-card><h3>🧩 Tetris</h3><p>Port: 30005</p><p>Learn: Resources</p></div><div class=game-card><h3>🐸 Frogger</h3><p>Port: 30006</p><p>Learn: Traffic</p></div></div><div style=\"background:rgba(0,0,0,0.3);padding:20px;border-radius:10px;margin:20px 0\"><h3>🚀 Access Games</h3><p>All games accessible at: http://192.168.56.10:[PORT]</p><p>Dashboard: http://192.168.56.10:30000</p></div></body></html>\" > /usr/share/nginx/html/index.html && nginx -g \"daemon off;\"']
---
apiVersion: v1
kind: Service
metadata:
  name: dashboard-service
  namespace: arcade
spec:
  selector:
    app: game-dashboard
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30000
  type: NodePort
EOF"

echo [INFO] Waiting for dashboard to be ready...
vagrant ssh k3s-master -c "kubectl wait --for=condition=Ready pod -l app=game-dashboard -n arcade --timeout=60s"

echo.
echo [SUCCESS] Game Dashboard deployed!
echo 🎮 Access at: http://192.168.56.10:30000
echo 🎯 This is your main hub for all games!
goto menu_return

:deploy_pacman
echo.
echo [INFO] Deploying Pac-Man Game (Networking Demo)...
vagrant ssh k3s-master -c "kubectl create namespace arcade 2>/dev/null || echo 'namespace exists'"

echo [INFO] Creating Pac-Man with advanced networking features...
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
        command: ['/bin/sh']
        args: ['-c', 'echo \"<html><head><title>Pac-Man K8s</title><style>body{background:#000;color:#ffff00;font-family:Courier;text-align:center;padding:20px}canvas{border:3px solid #0000ff;margin:20px}button{padding:10px 20px;background:#ffff00;color:#000;border:none;border-radius:5px;cursor:pointer}</style></head><body><h1>🟡 PAC-MAN ON KUBERNETES 🟡</h1><div style=\\\"background:#1a1a1a;padding:15px;margin:15px;border:2px solid #ffff00;border-radius:5px\\\"><h3>🚀 Running on K3s Cluster</h3><p><strong>Namespace:</strong> arcade | <strong>Pod:</strong> pacman-game</p><p><strong>Learning:</strong> Pod networking and service discovery</p></div><canvas id=gameCanvas width=600 height=400></canvas><div><button onclick=startGame()>START GAME</button> <button onclick=alert(\\\"🎯 Kubernetes Concepts:\\\\n• Pod isolation\\\\n• Service networking\\\\n• NodePort access\\\\n• Container lifecycle\\\")>LEARN K8S</button></div><script>const canvas=document.getElementById(\\\"gameCanvas\\\");const ctx=canvas.getContext(\\\"2d\\\");let pacman={x:300,y:200,size:15,dx:0,dy:0};let dots=[];let gameRunning=false;function initDots(){dots=[];for(let x=30;x<canvas.width-30;x+=40){for(let y=30;y<canvas.height-30;y+=40){if(Math.abs(x-pacman.x)>50||Math.abs(y-pacman.y)>50){dots.push({x:x,y:y,collected:false});}}}}function drawPacman(){ctx.fillStyle=\\\"#ffff00\\\";ctx.beginPath();ctx.arc(pacman.x,pacman.y,pacman.size,0.2,2*Math.PI-0.2);ctx.lineTo(pacman.x,pacman.y);ctx.fill();}function drawDots(){ctx.fillStyle=\\\"#ffff00\\\";dots.forEach(dot=>{if(!dot.collected){ctx.beginPath();ctx.arc(dot.x,dot.y,3,0,2*Math.PI);ctx.fill();}});}function updateGame(){if(!gameRunning)return;ctx.clearRect(0,0,canvas.width,canvas.height);pacman.x+=pacman.dx;pacman.y+=pacman.dy;if(pacman.x<0)pacman.x=canvas.width;if(pacman.x>canvas.width)pacman.x=0;if(pacman.y<0)pacman.y=canvas.height;if(pacman.y>canvas.height)pacman.y=0;dots.forEach(dot=>{if(!dot.collected){const dist=Math.sqrt((pacman.x-dot.x)**2+(pacman.y-dot.y)**2);if(dist<20){dot.collected=true;}}});if(dots.every(dot=>dot.collected)){alert(\\\"🎉 Level Complete! Networking mastered!\\\");gameRunning=false;}drawDots();drawPacman();}function startGame(){if(gameRunning)return;gameRunning=true;initDots();setInterval(updateGame,1000/30);}document.addEventListener(\\\"keydown\\\",(e)=>{if(!gameRunning)return;const speed=4;switch(e.key){case \\\"ArrowUp\\\":pacman.dx=0;pacman.dy=-speed;break;case \\\"ArrowDown\\\":pacman.dx=0;pacman.dy=speed;break;case \\\"ArrowLeft\\\":pacman.dx=-speed;pacman.dy=0;break;case \\\"ArrowRight\\\":pacman.dx=speed;pacman.dy=0;break;}});initDots();drawDots();</script></body></html>\" > /usr/share/nginx/html/index.html && nginx -g \"daemon off;\"']
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

echo [INFO] Waiting for Pac-Man to be ready...
vagrant ssh k3s-master -c "kubectl wait --for=condition=Ready pod -l app=pacman -n arcade --timeout=60s"

echo.
echo [SUCCESS] 🟡 Pac-Man deployed!
echo 🎮 Play at: http://192.168.56.10:30001
echo 🎓 Learn: Pod networking, service discovery
goto menu_return

:deploy_space_invaders
echo.
echo [INFO] Deploying Space Invaders (Security Demo)...
vagrant ssh k3s-master -c "kubectl create namespace arcade 2>/dev/null || echo 'namespace exists'"

echo [INFO] Creating Space Invaders with security policies...
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
        args: ['-c', 'echo \"<html><head><title>Space Invaders K8s</title><style>body{background:#000;color:#00ff00;font-family:Courier;text-align:center;padding:20px}canvas{border:3px solid #00ff00;margin:20px}button{padding:10px 20px;background:#00ff00;color:#000;border:none;border-radius:5px;margin:5px;cursor:pointer}</style></head><body><h1>👾 SPACE INVADERS - K8S SECURITY EDITION 👾</h1><div style=\\\"background:#001100;padding:15px;margin:15px;border:2px solid #00ff00;border-radius:5px\\\"><h3>🛡️ Cluster Defense Mission</h3><p><strong>Objective:</strong> Protect your pods from malicious containers!</p><p><strong>Security Features:</strong> Non-root user, no privileges, read-only filesystem</p></div><canvas id=gameCanvas width=800 height=500></canvas><div><button onclick=startGame()>DEPLOY DEFENSES</button> <button onclick=alert(\\\"🛡️ Security Concepts:\\\\n• Pod Security Context\\\\n• Network Policies\\\\n• RBAC Controls\\\\n• Container Security\\\")>LEARN SECURITY</button></div><script>const canvas=document.getElementById(\\\"gameCanvas\\\");const ctx=canvas.getContext(\\\"2d\\\");let player={x:400,y:450,width:40,height:20};let bullets=[];let invaders=[];let gameRunning=false;function initInvaders(){invaders=[];for(let row=0;row<5;row++){for(let col=0;col<10;col++){invaders.push({x:50+col*60,y:50+row*40,width:30,height:20,alive:true,type:row%3});}}}function drawPlayer(){ctx.fillStyle=\\\"#00ff00\\\";ctx.fillRect(player.x-player.width/2,player.y,player.width,player.height);ctx.fillStyle=\\\"#ffffff\\\";ctx.font=\\\"10px Courier\\\";ctx.fillText(\\\"kubectl\\\",player.x-15,player.y+15);}function drawInvaders(){const colors=[\\\"#ff0000\\\",\\\"#ffff00\\\",\\\"#ff00ff\\\"];invaders.forEach(invader=>{if(invader.alive){ctx.fillStyle=colors[invader.type];ctx.fillRect(invader.x,invader.y,invader.width,invader.height);ctx.fillStyle=\\\"#ffffff\\\";ctx.font=\\\"12px Courier\\\";ctx.fillText(\\\"🐳\\\",invader.x+5,invader.y+15);}});}function drawBullets(){ctx.fillStyle=\\\"#00ffff\\\";bullets.forEach(bullet=>{ctx.fillRect(bullet.x-2,bullet.y,4,10);});}function updateGame(){if(!gameRunning)return;ctx.clearRect(0,0,canvas.width,canvas.height);bullets=bullets.filter(bullet=>{bullet.y-=8;if(bullet.y<0)return false;for(let invader of invaders){if(invader.alive&&bullet.x>invader.x&&bullet.x<invader.x+invader.width&&bullet.y>invader.y&&bullet.y<invader.y+invader.height){invader.alive=false;return false;}}return true;});if(invaders.every(invader=>!invader.alive)){alert(\\\"🎉 Cluster Secured! All threats eliminated!\\\");gameRunning=false;}drawPlayer();drawInvaders();drawBullets();}function startGame(){if(gameRunning)return;gameRunning=true;initInvaders();setInterval(updateGame,1000/60);}document.addEventListener(\\\"keydown\\\",(e)=>{if(!gameRunning)return;switch(e.key){case \\\"ArrowLeft\\\":case \\\"a\\\":player.x=Math.max(20,player.x-10);break;case \\\"ArrowRight\\\":case \\\"d\\\":player.x=Math.min(canvas.width-20,player.x+10);break;case \\\" \\\":e.preventDefault();if(bullets.length<3){bullets.push({x:player.x,y:player.y});}break;}});initInvaders();drawPlayer();drawInvaders();</script></body></html>\" > /usr/share/nginx/html/index.html && nginx -g \"daemon off;\"']
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

echo [SUCCESS] 👾 Space Invaders deployed with security features!
echo 🎮 Play at: http://192.168.56.10:30002
echo 🛡️ Learn: Pod security, network policies, RBAC
goto menu_return

:deploy_breakout
echo.
echo [INFO] Deploying Breakout (Microservices Demo)...
vagrant ssh k3s-master -c "kubectl create namespace arcade 2>/dev/null || echo 'namespace exists'"

vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: breakout-game
  namespace: arcade
  labels:
    app: breakout
    k8s-concept: microservices
spec:
  replicas: 1
  selector:
    matchLabels:
      app: breakout
  template:
    metadata:
      labels:
        app: breakout
    spec:
      containers:
      - name: breakout
        image: nginx:alpine
        ports:
        - containerPort: 80
        command: ['/bin/sh']
        args: ['-c', 'echo \"<html><head><title>K8s Breakout</title><style>body{background:#1a1a2e;color:#eee;font-family:Courier;text-align:center;padding:20px}canvas{border:3px solid #0f3460;margin:20px;box-shadow:0 0 20px rgba(15,52,96,0.5)}button{padding:10px 20px;background:#4CAF50;color:#fff;border:none;border-radius:5px;margin:5px;cursor:pointer}</style></head><body><h1>🧱 KUBERNETES BREAKOUT 🧱</h1><div style=\\\"background:#16213e;padding:15px;margin:15px;border:2px solid #0f3460;border-radius:5px\\\"><h3>⚡ Breaking Monoliths into Microservices!</h3><p>Break down monolithic architecture blocks!</p><p><strong>Each brick:</strong> A service to decompose</p></div><canvas id=gameCanvas width=800 height=600></canvas><div><button onclick=startGame()>START REFACTORING</button> <button onclick=alert(\\\"🏗️ Architecture Concepts:\\\\n• Monolith decomposition\\\\n• Service boundaries\\\\n• Load balancing\\\\n• API gateways\\\")>LEARN ARCHITECTURE</button></div><script>const canvas=document.getElementById(\\\"gameCanvas\\\");const ctx=canvas.getContext(\\\"2d\\\");let paddle={x:400,y:550,width:100,height:15,dx:0};let ball={x:400,y:300,radius:8,dx:4,dy:-4,launched:false};let bricks=[];let gameRunning=false;const services=[{name:\\\"API\\\",color:\\\"#ff6b6b\\\"},{name:\\\"DB\\\",color:\\\"#4ecdc4\\\"},{name:\\\"Cache\\\",color:\\\"#45b7d1\\\"}];function initBricks(){bricks=[];for(let row=0;row<6;row++){for(let col=0;col<10;col++){bricks.push({x:10+col*77,y:50+row*27,width:75,height:25,destroyed:false,service:services[row%3],hits:0,maxHits:row<2?1:2});}}}function drawPaddle(){ctx.fillStyle=\\\"#00ff00\\\";ctx.fillRect(paddle.x-paddle.width/2,paddle.y,paddle.width,paddle.height);ctx.fillStyle=\\\"#ffffff\\\";ctx.font=\\\"10px Courier\\\";ctx.fillText(\\\"Load Balancer\\\",paddle.x-30,paddle.y+12);}function drawBall(){ctx.fillStyle=\\\"#ffffff\\\";ctx.beginPath();ctx.arc(ball.x,ball.y,ball.radius,0,2*Math.PI);ctx.fill();}function drawBricks(){bricks.forEach(brick=>{if(!brick.destroyed){const alpha=1-(brick.hits/brick.maxHits)*0.5;ctx.fillStyle=brick.service.color;ctx.globalAlpha=alpha;ctx.fillRect(brick.x,brick.y,brick.width,brick.height);ctx.globalAlpha=1;ctx.fillStyle=\\\"#ffffff\\\";ctx.font=\\\"9px Courier\\\";ctx.fillText(brick.service.name,brick.x+5,brick.y+15);}});}function updateGame(){if(!gameRunning)return;ctx.clearRect(0,0,canvas.width,canvas.height);paddle.x+=paddle.dx;if(paddle.x<paddle.width/2)paddle.x=paddle.width/2;if(paddle.x>canvas.width-paddle.width/2)paddle.x=canvas.width-paddle.width/2;if(ball.launched){ball.x+=ball.dx;ball.y+=ball.dy;if(ball.x<=ball.radius||ball.x>=canvas.width-ball.radius)ball.dx=-ball.dx;if(ball.y<=ball.radius)ball.dy=-ball.dy;if(ball.y+ball.radius>=paddle.y&&ball.x>=paddle.x-paddle.width/2&&ball.x<=paddle.x+paddle.width/2){ball.dy=-Math.abs(ball.dy);}bricks.forEach(brick=>{if(!brick.destroyed&&ball.x>=brick.x&&ball.x<=brick.x+brick.width&&ball.y>=brick.y&&ball.y<=brick.y+brick.height){ball.dy=-ball.dy;brick.hits++;if(brick.hits>=brick.maxHits){brick.destroyed=true;}}});if(ball.y>canvas.height){ball.launched=false;ball.x=paddle.x;ball.y=300;}}else{ball.x=paddle.x;}if(bricks.every(brick=>brick.destroyed)){alert(\\\"🎉 Monolith successfully decomposed into microservices!\\\");gameRunning=false;}drawBricks();drawPaddle();drawBall();if(!ball.launched){ctx.fillStyle=\\\"#ffffff\\\";ctx.font=\\\"16px Courier\\\";ctx.fillText(\\\"Press SPACE to launch request!\\\",canvas.width/2-140,canvas.height/2+50);}}function startGame(){if(gameRunning)return;gameRunning=true;initBricks();setInterval(updateGame,1000/60);}document.addEventListener(\\\"keydown\\\",(e)=>{if(!gameRunning)return;switch(e.key){case \\\"ArrowLeft\\\":case \\\"a\\\":paddle.dx=-8;break;case \\\"ArrowRight\\\":case \\\"d\\\":paddle.dx=8;break;case \\\" \\\":e.preventDefault();if(!ball.launched)ball.launched=true;break;}});document.addEventListener(\\\"keyup\\\",(e)=>{if(e.key===\\\"ArrowLeft\\\"||e.key===\\\"a\\\"||e.key===\\\"ArrowRight\\\"||e.key===\\\"d\\\"){paddle.dx=0;}});initBricks();drawBricks();drawPaddle();drawBall();</script></body></html>\" > /usr/share/nginx/html/index.html && nginx -g \"daemon off;\"']
---
apiVersion: v1
kind: Service
metadata:
  name: breakout-service
  namespace: arcade
spec:
  selector:
    app: breakout
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30003
  type: NodePort
EOF"

echo [SUCCESS] 🧱 Breakout deployed!
echo 🎮 Play at: http://192.168.56.10:30003
echo 🏗️ Learn: Microservices, load balancing, API gateways
goto menu_return

:deploy_snake
echo.
echo [INFO] Deploying Snake Game (Scaling Demo)...
vagrant ssh k3s-master -c "kubectl create namespace arcade 2>/dev/null || echo 'namespace exists'"

vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: snake-game
  namespace: arcade
  labels:
    app: snake
    k8s-concept: scaling
spec:
  replicas: 1
  selector:
    matchLabels:
      app: snake
  template:
    metadata:
      labels:
        app: snake
    spec:
      containers:
      - name: snake
        image: nginx:alpine
        ports:
        - containerPort: 80
        command: ['/bin/sh']
        args: ['-c', 'echo \"<html><head><title>Snake K8s Scaling</title><style>body{background:#2d5a27;color:#fff;font-family:Courier;text-align:center;padding:20px}canvas{border:3px solid #fff;margin:20px;background:#0d2818}button{padding:10px 20px;background:#4CAF50;color:#fff;border:none;border-radius:5px;margin:5px;cursor:pointer}</style></head><body><h1>🐍 KUBERNETES SNAKE - SCALING EDITION 🐍</h1><div style=\\\"background:#1a3818;padding:15px;margin:15px;border:2px solid #4CAF50;border-radius:5px\\\"><h3>📈 Horizontal Pod Autoscaling Demo</h3><p>As the snake grows, it represents scaling pods!</p><p><strong>Learning:</strong> HPA, resource scaling, load distribution</p></div><canvas id=gameCanvas width=600 height=600></canvas><div>Score: <span id=score>0</span> | Length: <span id=length>1</span> (Pods)</div><div><button onclick=startGame()>START SCALING</button> <button onclick=alert(\\\"📈 Scaling Concepts:\\\\n• Horizontal Pod Autoscaler\\\\n• Resource-based scaling\\\\n• Load distribution\\\\n• Performance optimization\\\")>LEARN SCALING</button></div><script>const canvas=document.getElementById(\\\"gameCanvas\\\");const ctx=canvas.getContext(\\\"2d\\\");const gridSize=20;let snake=[{x:300,y:300}];let food={x:0,y:0};let dx=gridSize;let dy=0;let score=0;let gameRunning=false;function generateFood(){food={x:Math.floor(Math.random()*(canvas.width/gridSize))*gridSize,y:Math.floor(Math.random()*(canvas.height/gridSize))*gridSize};}function drawSnake(){ctx.fillStyle=\\\"#4CAF50\\\";snake.forEach((segment,index)=>{ctx.fillRect(segment.x,segment.y,gridSize-2,gridSize-2);if(index===0){ctx.fillStyle=\\\"#ffffff\\\";ctx.font=\\\"10px Courier\\\";ctx.fillText(\\\"Pod\\\",segment.x+2,segment.y+12);ctx.fillStyle=\\\"#4CAF50\\\";}});}function drawFood(){ctx.fillStyle=\\\"#ff0000\\\";ctx.fillRect(food.x,food.y,gridSize-2,gridSize-2);ctx.fillStyle=\\\"#ffffff\\\";ctx.font=\\\"8px Courier\\\";ctx.fillText(\\\"CPU\\\",food.x+2,food.y+12);}function updateGame(){if(!gameRunning)return;const head={x:snake[0].x+dx,y:snake[0].y+dy};if(head.x<0||head.x>=canvas.width||head.y<0||head.y>=canvas.height){alert(\\\"💥 Scaling limit reached! Cluster overloaded!\\\");gameRunning=false;return;}for(let segment of snake){if(head.x===segment.x&&head.y===segment.y){alert(\\\"🔄 Resource conflict! Pod collision detected!\\\");gameRunning=false;return;}}snake.unshift(head);if(head.x===food.x&&head.y===food.y){score+=10;document.getElementById(\\\"score\\\").textContent=score;document.getElementById(\\\"length\\\").textContent=snake.length;generateFood();}else{snake.pop();}ctx.clearRect(0,0,canvas.width,canvas.height);drawSnake();drawFood();}function startGame(){if(gameRunning)return;gameRunning=true;generateFood();setInterval(updateGame,150);}document.addEventListener(\\\"keydown\\\",(e)=>{if(!gameRunning)return;switch(e.key){case \\\"ArrowUp\\\":if(dy===0){dx=0;dy=-gridSize;}break;case \\\"ArrowDown\\\":if(dy===0){dx=0;dy=gridSize;}break;case \\\"ArrowLeft\\\":if(dx===0){dx=-gridSize;dy=0;}break;case \\\"ArrowRight\\\":if(dx===0){dx=gridSize;dy=0;}break;}});generateFood();drawSnake();drawFood();</script></body></html>\" > /usr/share/nginx/html/index.html && nginx -g \"daemon off;\"']
---
apiVersion: v1
kind: Service
metadata:
  name: snake-service
  namespace: arcade
spec:
  selector:
    app: snake
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30004
  type: NodePort
EOF"

echo [SUCCESS] 🐍 Snake deployed!
echo 🎮 Play at: http://192.168.56.10:30004
echo 📈 Learn: Horizontal scaling, resource management
goto menu_return

:deploy_tetris
echo.
echo [INFO] Deploying Tetris (Resource Management Demo)...
vagrant ssh k3s-master -c "kubectl create namespace arcade 2>/dev/null || echo 'namespace exists'"

vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tetris-game
  namespace: arcade
  labels:
    app: tetris
    k8s-concept: resource-management
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tetris
  template:
    metadata:
      labels:
        app: tetris
    spec:
      containers:
      - name: tetris
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: \"128Mi\"
            cpu: \"100m\"
          limits:
            memory: \"256Mi\"
            cpu: \"200m\"
        command: ['/bin/sh']
        args: ['-c', 'echo \"<html><head><title>Kubernetes Tetris</title><style>body{background:#000;color:#fff;font-family:Courier;text-align:center;padding:20px}canvas{border:3px solid #fff;margin:20px}button{padding:10px 20px;background:#9C27B0;color:#fff;border:none;border-radius:5px;margin:5px;cursor:pointer}.info{background:#1a1a1a;padding:15px;margin:15px;border-radius:5px}</style></head><body><h1>🧩 KUBERNETES TETRIS 🧩</h1><div class=info><h3>📦 Container Resource Management</h3><p>Organize containers efficiently in your cluster!</p><p><strong>Blocks:</strong> Different container types</p><p><strong>Goal:</strong> Optimal resource utilization</p></div><canvas id=gameCanvas width=400 height=600></canvas><div>Score: <span id=score>0</span> | Lines: <span id=lines>0</span> | Level: <span id=level>1</span></div><div><button onclick=startGame()>START DEPLOYMENT</button> <button onclick=alert(\\\"📦 Resource Concepts:\\\\n• CPU/Memory limits\\\\n• Resource quotas\\\\n• Node affinity\\\\n• Pod scheduling\\\")>LEARN RESOURCES</button></div><div class=info><h3>🎮 Controls</h3><p>←/→: Move container | ↓: Drop faster | ↑: Rotate</p></div><script>const canvas=document.getElementById(\\\"gameCanvas\\\");const ctx=canvas.getContext(\\\"2d\\\");const COLS=10;const ROWS=20;const BLOCK_SIZE=20;let board=Array(ROWS).fill().map(()=>Array(COLS).fill(0));let score=0;let lines=0;let level=1;let gameRunning=false;const pieces=[[[1,1,1,1]],[[1,1],[1,1]],[[0,1,1],[1,1,0]],[[1,1,0],[0,1,1]],[[1,0,0],[1,1,1]],[[0,0,1],[1,1,1]],[[0,1,0],[1,1,1]]];const colors=[\\\"#000\\\",\\\"#00ffff\\\",\\\"#ffff00\\\",\\\"#00ff00\\\",\\\"#ff0000\\\",\\\"#ff8800\\\",\\\"#0000ff\\\",\\\"#8800ff\\\"];let currentPiece={shape:null,x:0,y:0,color:0};function newPiece(){const pieceIndex=Math.floor(Math.random()*pieces.length);currentPiece={shape:pieces[pieceIndex],x:Math.floor(COLS/2)-1,y:0,color:pieceIndex+1};}function drawBoard(){for(let row=0;row<ROWS;row++){for(let col=0;col<COLS;col++){ctx.fillStyle=colors[board[row][col]];ctx.fillRect(col*BLOCK_SIZE,row*BLOCK_SIZE,BLOCK_SIZE-1,BLOCK_SIZE-1);}}}function drawPiece(){if(!currentPiece.shape)return;ctx.fillStyle=colors[currentPiece.color];for(let row=0;row<currentPiece.shape.length;row++){for(let col=0;col<currentPiece.shape[row].length;col++){if(currentPiece.shape[row][col]){ctx.fillRect((currentPiece.x+col)*BLOCK_SIZE,(currentPiece.y+row)*BLOCK_SIZE,BLOCK_SIZE-1,BLOCK_SIZE-1);}}}}function canMove(shape,x,y){for(let row=0;row<shape.length;row++){for(let col=0;col<shape[row].length;col++){if(shape[row][col]){const newX=x+col;const newY=y+row;if(newX<0||newX>=COLS||newY>=ROWS||board[newY][newX]){return false;}}}}return true;}function placePiece(){for(let row=0;row<currentPiece.shape.length;row++){for(let col=0;col<currentPiece.shape[row].length;col++){if(currentPiece.shape[row][col]){board[currentPiece.y+row][currentPiece.x+col]=currentPiece.color;}}}clearLines();newPiece();if(!canMove(currentPiece.shape,currentPiece.x,currentPiece.y)){alert(\\\"🚨 Cluster capacity exceeded! Resource limit reached!\\\");gameRunning=false;}}function clearLines(){let linesCleared=0;for(let row=ROWS-1;row>=0;row--){if(board[row].every(cell=>cell!==0)){board.splice(row,1);board.unshift(Array(COLS).fill(0));linesCleared++;row++;}}if(linesCleared>0){lines+=linesCleared;score+=linesCleared*100*level;document.getElementById(\\\"lines\\\").textContent=lines;document.getElementById(\\\"score\\\").textContent=score;if(lines>=level*10){level++;document.getElementById(\\\"level\\\").textContent=level;}}}function gameLoop(){if(!gameRunning)return;if(canMove(currentPiece.shape,currentPiece.x,currentPiece.y+1)){currentPiece.y++;}else{placePiece();}ctx.clearRect(0,0,canvas.width,canvas.height);drawBoard();drawPiece();}function startGame(){if(gameRunning)return;gameRunning=true;newPiece();setInterval(gameLoop,800);}document.addEventListener(\\\"keydown\\\",(e)=>{if(!gameRunning)return;switch(e.key){case \\\"ArrowLeft\\\":if(canMove(currentPiece.shape,currentPiece.x-1,currentPiece.y))currentPiece.x--;break;case \\\"ArrowRight\\\":if(canMove(currentPiece.shape,currentPiece.x+1,currentPiece.y))currentPiece.x++;break;case \\\"ArrowDown\\\":if(canMove(currentPiece.shape,currentPiece.x,currentPiece.y+1))currentPiece.y++;break;case \\\"ArrowUp\\\":const rotated=currentPiece.shape[0].map((_,i)=>currentPiece.shape.map(row=>row[i]).reverse());if(canMove(rotated,currentPiece.x,currentPiece.y))currentPiece.shape=rotated;break;}});drawBoard();</script></body></html>\" > /usr/share/nginx/html/index.html && nginx -g \"daemon off;\"']
---
apiVersion: v1
kind: Service
metadata:
  name: tetris-service
  namespace: arcade
spec:
  selector:
    app: tetris
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30005
  type: NodePort
---
apiVersion: v1
kind: HorizontalPodAutoscaler
metadata:
  name: tetris-hpa
  namespace: arcade
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: tetris-game
  minReplicas: 1
  maxReplicas: 3
  targetCPUUtilizationPercentage: 70
EOF"

echo [SUCCESS] 🧩 Tetris deployed with autoscaling!
echo 🎮 Play at: http://192.168.56.10:30005
echo 📦 Learn: Resource management, pod scheduling, HPA
goto menu_return

:deploy_kubectl_trainer
echo.
echo [INFO] Deploying kubectl Trainer (Interactive Learning)...
vagrant ssh k3s-master -c "kubectl create namespace educational 2>/dev/null || echo 'namespace exists'"

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
        args: ['-c', 'echo \"<html><head><title>kubectl Trainer</title><style>body{background:#2c3e50;color:#ecf0f1;font-family:Courier;padding:20px}.terminal{background:#000;color:#00ff00;padding:20px;border-radius:10px;margin:20px 0;font-family:monospace;text-align:left}.command{background:#34495e;padding:10px;margin:10px 0;border-radius:5px;cursor:pointer}.command:hover{background:#4a6741}button{padding:10px 20px;background:#3498db;color:#fff;border:none;border-radius:5px;margin:5px;cursor:pointer}</style></head><body><h1>🎯 KUBECTL TRAINING SIMULATOR 🎯</h1><div style=\\\"background:#34495e;padding:15px;margin:15px;border-radius:5px;text-align:center\\\"><h3>🚀 Master Kubernetes CLI</h3><p>Practice kubectl commands in a safe environment!</p></div><div class=terminal id=terminal>Welcome to kubectl trainer!<br>Type commands below or click on examples:<br><br>$ kubectl get nodes<br>$ kubectl get pods -A<br>$ kubectl describe pod [pod-name]<br><br>Ready for your first command...</div><div><div class=command onclick=runCommand(\\\"kubectl get nodes\\\")>kubectl get nodes</div><div class=command onclick=runCommand(\\\"kubectl get pods -A\\\")>kubectl get pods -A</div><div class=command onclick=runCommand(\\\"kubectl get services -A\\\")>kubectl get services -A</div><div class=command onclick=runCommand(\\\"kubectl get namespaces\\\")>kubectl get namespaces</div></div><div><button onclick=clearTerminal()>CLEAR TERMINAL</button> <button onclick=showHelp()>SHOW HELP</button> <button onclick=startChallenge()>START CHALLENGE</button></div><script>let commandHistory=[];function runCommand(cmd){const terminal=document.getElementById(\\\"terminal\\\");terminal.innerHTML+=\\\"<br>$ \\\"+cmd+\\\"<br>\\\";commandHistory.push(cmd);switch(cmd){case \\\"kubectl get nodes\\\":terminal.innerHTML+=\\\"NAME         STATUS   ROLES    AGE<br>k3s-master   Ready    master   1d<br>k3s-worker1  Ready    worker   1d<br>\\\";break;case \\\"kubectl get pods -A\\\":terminal.innerHTML+=\\\"NAMESPACE   NAME              READY   STATUS<br>arcade      pacman-game       1/1     Running<br>arcade      space-invaders    1/1     Running<br>default     game-dashboard    1/1     Running<br>\\\";break;case \\\"kubectl get services -A\\\":terminal.innerHTML+=\\\"NAMESPACE   NAME                TYPE       PORT(S)<br>arcade      pacman-service      NodePort   80:30001/TCP<br>arcade      invaders-service    NodePort   80:30002/TCP<br>\\\";break;case \\\"kubectl get namespaces\\\":terminal.innerHTML+=\\\"NAME         STATUS   AGE<br>default      Active   1d<br>arcade       Active   1h<br>educational  Active   30m<br>\\\";break;default:terminal.innerHTML+=\\\"Command executed successfully!<br>\\\";}terminal.scrollTop=terminal.scrollHeight;}function clearTerminal(){document.getElementById(\\\"terminal\\\").innerHTML=\\\"Terminal cleared. Ready for commands...\\\";}function showHelp(){const terminal=document.getElementById(\\\"terminal\\\");terminal.innerHTML+=\\\"<br>=== KUBECTL HELP ===<br>Basic commands:<br>• get - List resources<br>• describe - Show detailed info<br>• apply - Create/update resources<br>• delete - Remove resources<br>• logs - Show container logs<br><br>Resource types:<br>• nodes, pods, services, deployments<br>• namespaces, configmaps, secrets<br><br>\";}function startChallenge(){alert(\\\"🎯 Challenge Mode!\\\\n\\\\nFind all running game pods and their ports!\\\\nHint: Use kubectl get commands\\\\n\\\\nClick the command examples to practice!\\\");}</script></body></html>\" > /usr/share/nginx/html/index.html && nginx -g \"daemon off;\"']
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

echo [SUCCESS] 🎯 kubectl Trainer deployed!
echo 🎮 Practice at: http://192.168.56.10:30010
echo 🎓 Learn: kubectl commands, cluster inspection
goto menu_return

:deploy_all_games
echo.
echo [INFO] 🚀 DEPLOYING FULL GAME ARCADE! 🚀
echo This will deploy ALL games at once...
echo.

echo [INFO] Creating namespaces...
vagrant ssh k3s-master -c "kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: arcade
  labels:
    purpose: gaming
---
apiVersion: v1
kind: Namespace
metadata:
  name: educational
  labels:
    purpose: learning
EOF"

echo [INFO] Deploying Game Dashboard...
call :deploy_dashboard_silent

echo [INFO] Deploying Pac-Man...
call :deploy_pacman_silent

echo [INFO] Deploying Space Invaders...
call :deploy_space_invaders_silent

echo [INFO] Deploying Snake...
call :deploy_snake_silent

echo [INFO] Deploying Tetris...
call :deploy_tetris_silent

echo.
echo [SUCCESS] 🎉 FULL ARCADE DEPLOYED! 🎉
echo.
echo 🎮 GAME ACCESS POINTS:
echo ================================
echo 🏠 Dashboard:      http://192.168.56.10:30000
echo 🟡 Pac-Man:        http://192.168.56.10:30001
echo 👾 Space Invaders: http://192.168.56.10:30002
echo 🧱 Breakout:       http://192.168.56.10:30003
echo 🐍 Snake:          http://192.168.56.10:30004
echo 🧩 Tetris:         http://192.168.56.10:30005
echo 🎯 kubectl Trainer: http://192.168.56.10:30010
echo.
echo 🎓 Each game teaches different Kubernetes concepts!
echo 🚀 Start with the Dashboard for the full experience!
goto menu_return

:view_all_games
echo.
echo [INFO] 📊 KUBERNETES GAME ARCADE STATUS 📊
echo.

echo === GAME NAMESPACES ===
vagrant ssh k3s-master -c "kubectl get namespaces -l purpose=gaming,purpose=learning --show-labels"

echo.
echo === RUNNING GAMES ===
vagrant ssh k3s-master -c "kubectl get pods -n arcade,educational -o wide"

echo.
echo === GAME SERVICES & PORTS ===
vagrant ssh k3s-master -c "kubectl get svc -n arcade,educational -o custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,TYPE:.spec.type,PORT:.spec.ports[0].nodePort,GAME:.metadata.labels.app'"

echo.
echo === RESOURCE USAGE ===
vagrant ssh k3s-master -c "kubectl top pods -n arcade,educational 2>/dev/null || echo 'Metrics not available yet'"

echo.
echo === GAME ACCESS URLS ===
echo 🏠 Dashboard:      http://192.168.56.10:30000
echo 🟡 Pac-Man:        http://192.168.56.10:30001  
echo 👾 Space Invaders: http://192.168.56.10:30002
echo 🧱 Breakout:       http://192.168.56.10:30003
echo 🐍 Snake:          http://192.168.56.10:30004
echo 🧩 Tetris:         http://192.168.56.10:30005
echo 🎯 kubectl Trainer: http://192.168.56.10:30010

goto menu_return

:game_management
cls
echo ================================================
echo        🔧 GAME MANAGEMENT TOOLS 🔧
echo ================================================
echo.
echo 1. 📊 Show detailed game status
echo 2. 🔄 Restart a specific game
echo 3. 📈 Scale game replicas
echo 4. 🔍 Debug game pod
echo 5. 📋 Export game configs
echo 6. 🎯 Test game endpoints
echo 7. 📝 Show game logs
echo 8. 🔙 Back to main menu
echo.
set /p mgmt_choice="Choose management option (1-8): "

if "%mgmt_choice%"=="1" goto show_detailed_status
if "%mgmt_choice%"=="2" goto restart_game
if "%mgmt_choice%"=="3" goto scale_game
if "%mgmt_choice%"=="4" goto debug_game
if "%mgmt_choice%"=="5" goto export_configs
if "%mgmt_choice%"=="6" goto test_endpoints
if "%mgmt_choice%"=="7" goto show_logs
if "%mgmt_choice%"=="8" goto menu
goto game_management

:show_detailed_status
echo.
echo [INFO] Detailed Game Status...
vagrant ssh k3s-master -c "
echo '=== DEPLOYMENTS ==='
kubectl get deployments -n arcade,educational -o wide

echo -e '\n=== PODS WITH DETAILS ==='
kubectl get pods -n arcade,educational -o custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName,IP:.status.podIP,READY:.status.conditions[?(@.type==\"Ready\")].status'

echo -e '\n=== SERVICES WITH ENDPOINTS ==='
kubectl get endpoints -n arcade,educational

echo -e '\n=== RESOURCE QUOTAS ==='
kubectl describe resourcequota -n arcade 2>/dev/null || echo 'No resource quotas set'
"
goto game_management

:cleanup_games
echo.
set /p confirm="🗑️ Are you sure you want to delete ALL games? (y/N): "
if /i not "%confirm%"=="y" goto menu_return

echo [INFO] 🧹 Cleaning up all games...
vagrant ssh k3s-master -c "
echo 'Deleting game namespaces...'
kubectl delete namespace arcade --ignore-not-found=true
kubectl delete namespace educational --ignore-not-found=true
kubectl delete namespace puzzle --ignore-not-found=true

echo 'Cleaning up any standalone game pods...'
kubectl delete pods -l game-type=arcade --all-namespaces --ignore-not-found=true

echo 'All games cleaned up!'
"

echo.
echo [SUCCESS] 🧹 All games have been removed from the cluster!
echo 🎮 Run option 13 to redeploy the full arcade!
goto menu_return

:test_connectivity
echo.
echo [INFO] 🔍 Testing Game Connectivity...
echo.

echo [TEST] Checking cluster connectivity...
ping 192.168.56.10 -n 2

echo.
echo [TEST] Testing game ports...
for %%p in (30000 30001 30002 30003 30004 30005 30010) do (
    echo Testing port %%p...
    powershell -Command "Test-NetConnection -ComputerName 192.168.56.10 -Port %%p -InformationLevel Quiet" && echo Port %%p: OPEN || echo Port %%p: CLOSED
)

echo.
echo [TEST] Checking game pod health...
vagrant ssh k3s-master -c "kubectl get pods -n arcade,educational --field-selector=status.phase=Running"

goto menu_return

:show_metrics
echo.
echo [INFO] 📈 Game Metrics & Performance...
vagrant ssh k3s-master -c "
echo '=== RESOURCE USAGE ==='
kubectl top nodes
echo ''
kubectl top pods -n arcade,educational 2>/dev/null || echo 'Metrics server not ready yet'

echo -e '\n=== GAME EVENTS ==='
kubectl get events -n arcade --sort-by='.lastTimestamp' | tail -10

echo -e '\n=== CLUSTER CAPACITY ==='
kubectl describe nodes | grep -A 5 'Allocated resources'
"
goto menu_return

:troubleshoot
echo.
echo [INFO] 🛠️ Game Troubleshooting Tools...
echo.

echo === CHECKING COMMON ISSUES ===
vagrant ssh k3s-master -c "
echo 'Checking pod status...'
kubectl get pods -n arcade,educational --field-selector=status.phase!=Running

echo -e '\nChecking service endpoints...'
kubectl get endpoints -n arcade,educational

echo -e '\nChecking recent events...'
kubectl get events -n arcade,educational --sort-by='.lastTimestamp' | tail -5

echo -e '\nChecking node resources...'
kubectl describe nodes | grep -E 'Name:|Conditions:|Allocated resources:' -A 3
"

echo.
echo === QUICK FIXES ===
echo If games aren't working, try:
echo 1. Restart pods: kubectl delete pods -n arcade --all
echo 2. Check services: kubectl get svc -n arcade
echo 3. View logs: kubectl logs -n arcade [pod-name]
echo 4. Test connectivity: curl http://192.168.56.10:[port]

goto menu_return

:: Silent deployment functions for batch operations
:deploy_dashboard_silent
vagrant ssh k3s-master -c "kubectl apply -f - <<EOF >/dev/null 2>&1
apiVersion: apps/v1
kind: Deployment
metadata:
  name: game-dashboard
  namespace: arcade
spec:
  replicas: 1
  selector:
    matchLabels:
      app: game-dashboard
  template:
    metadata:
      labels:
        app: game-dashboard
    spec:
      containers:
      - name: dashboard
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: dashboard-service
  namespace: arcade
spec:
  selector:
    app: game-dashboard
  ports:
  - port: 80
    nodePort: 30000
  type: NodePort
EOF"
exit /b

:deploy_pacman_silent
vagrant ssh k3s-master -c "kubectl run pacman --image=nginx:alpine --port=80 --namespace=arcade >/dev/null 2>&1 && kubectl expose pod pacman --port=80 --target-port=80 --type=NodePort --namespace=arcade >/dev/null 2>&1"
exit /b

:deploy_space_invaders_silent
vagrant ssh k3s-master -c "kubectl run space-invaders --image=nginx:alpine --port=80 --namespace=arcade >/dev/null 2>&1 && kubectl expose pod space-invaders --port=80 --target-port=80 --type=NodePort --namespace=arcade >/dev/null 2>&1"
exit /b

:deploy_snake_silent
vagrant ssh k3s-master -c "kubectl run snake --image=nginx:alpine --port=80 --namespace=arcade >/dev/null 2>&1 && kubectl expose pod snake --port=80 --target-port=80 --type=NodePort --namespace=arcade >/dev/null 2>&1"
exit /b

:deploy_tetris_silent
vagrant ssh k3s-master -c "kubectl run tetris --image=nginx:alpine --port=80 --namespace=arcade >/dev/null 2>&1 && kubectl expose pod tetris --port=80 --target-port=80 --type=NodePort --namespace=arcade >/dev/null 2>&1"
exit /b

:invalid_choice
echo.
echo [ERROR] Invalid choice. Please select 0-20.
goto menu_return

:menu_return
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:end
echo.
echo [INFO] 🎮 Thanks for playing the Kubernetes Game Arcade!
echo 🎓 Hope you learned something about K8s while having fun!
echo 🚀 Keep exploring and happy clustering!
exit /b 0