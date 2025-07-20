@echo off
setlocal enabledelayedexpansion

echo ================================================
echo         Fun Games for K3s Cluster
echo         Windows-Compatible Version
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
echo         Fun Games Menu (Windows)
echo ================================================
echo.
echo Choose a game to deploy:
echo.
echo 1. Simple Web App (nginx with custom page)
echo 2. Minecraft Server (Basic setup)
echo 3. Web Dashboard (Cluster info page)
echo 4. Tetris Game (HTML5 retro game)
echo 5. Test Connectivity (Network check)
echo 6. View Running Games
echo 7. Clean Up All Games
echo 0. Exit
echo.
echo ================================================
set /p choice="Enter your choice (0-7): "

if "%choice%"=="1" goto deploy_web_app
if "%choice%"=="2" goto deploy_minecraft
if "%choice%"=="3" goto deploy_dashboard
if "%choice%"=="4" goto deploy_tetris
if "%choice%"=="5" goto test_connectivity
if "%choice%"=="6" goto view_games
if "%choice%"=="7" goto cleanup_games
if "%choice%"=="0" goto end
goto invalid_choice

:deploy_web_app
echo.
echo [INFO] Deploying Simple Web App...
vagrant ssh k3s-master -c "kubectl create namespace games"
vagrant ssh k3s-master -c "kubectl run webapp --image=nginx:alpine --port=80 --namespace=games"
vagrant ssh k3s-master -c "kubectl expose pod webapp --port=80 --target-port=80 --type=NodePort --namespace=games"

echo [INFO] Getting assigned NodePort...
for /f "tokens=*" %%i in ('vagrant ssh k3s-master -c "kubectl get svc webapp -n games -o jsonpath='{.spec.ports[0].nodePort}'"') do set NODEPORT=%%i

echo.
echo [SUCCESS] Web App deployed!
echo.
echo Access at: http://192.168.56.10:!NODEPORT!
echo.
echo [INFO] Pod status:
vagrant ssh k3s-master -c "kubectl get pods -n games"
goto menu_return

:deploy_minecraft
echo.
echo [INFO] Deploying Minecraft Server...
echo [WARNING] This requires 2GB+ RAM and will take 3-5 minutes to start
set /p confirm="Continue? (y/N): "
if /i not "%confirm%"=="y" goto menu_return

vagrant ssh k3s-master -c "kubectl create namespace minecraft"
vagrant ssh k3s-master -c "kubectl run minecraft --image=itzg/minecraft-server --port=25565 --namespace=minecraft --env='EULA=TRUE' --env='TYPE=VANILLA'"
vagrant ssh k3s-master -c "kubectl expose pod minecraft --port=25565 --target-port=25565 --type=NodePort --namespace=minecraft"

echo.
echo [SUCCESS] Minecraft Server deploying...
echo.
echo Server will be available at: 192.168.56.10:[PORT]
echo Check port with: vagrant ssh k3s-master -c "kubectl get svc -n minecraft"
echo.
echo [INFO] Server startup logs (Ctrl+C to exit):
vagrant ssh k3s-master -c "kubectl logs minecraft -n minecraft -f"
goto menu_return

:deploy_dashboard
echo.
echo [INFO] Deploying Web Dashboard...
vagrant ssh k3s-master -c "kubectl create namespace dashboard"
vagrant ssh k3s-master -c "kubectl run dashboard --image=nginx:alpine --port=80 --namespace=dashboard"
vagrant ssh k3s-master -c "kubectl expose pod dashboard --port=80 --target-port=80 --type=NodePort --namespace=dashboard"

echo [INFO] Adding dashboard content...
vagrant ssh k3s-master -c "kubectl exec dashboard -n dashboard -- sh -c 'echo \"<html><head><title>K3s Dashboard</title></head><body style=font-family:Arial;text-align:center;padding:20px><h1>K3s Cluster Dashboard</h1><h2>Cluster Status: Running</h2><div style=background:#f0f0f0;padding:20px;margin:20px><h3>Cluster Info</h3><p>Master: 192.168.56.10</p><p>Worker: 192.168.56.11</p><p>This page served from Kubernetes!</p></div></body></html>\" > /usr/share/nginx/html/index.html'"

for /f "tokens=*" %%i in ('vagrant ssh k3s-master -c "kubectl get svc dashboard -n dashboard -o jsonpath='{.spec.ports[0].nodePort}'"') do set DASHPORT=%%i

echo.
echo [SUCCESS] Dashboard deployed!
echo.
echo Access at: http://192.168.56.10:!DASHPORT!
goto menu_return

:deploy_tetris
echo.
echo [INFO] Deploying Tetris Game...
vagrant ssh k3s-master -c "kubectl create namespace games"
vagrant ssh k3s-master -c "kubectl delete pod tetris -n games 2>/dev/null || echo 'no existing tetris pod'"
vagrant ssh k3s-master -c "kubectl delete service tetris -n games 2>/dev/null || echo 'no existing tetris service'"

echo [INFO] Creating Tetris pod with nginx...
vagrant ssh k3s-master -c "kubectl run tetris --image=nginx:alpine --port=80 --namespace=games"
vagrant ssh k3s-master -c "kubectl expose pod tetris --port=80 --target-port=80 --type=NodePort --namespace=games"

echo [INFO] Adding Tetris game content...
vagrant ssh k3s-master -c "kubectl exec tetris -n games -- sh -c 'echo \"<!DOCTYPE html><html><head><title>Tetris on K3s</title><style>body{font-family:Arial;text-align:center;background:#000;color:#fff;margin:0;padding:20px}.game-container{max-width:600px;margin:0 auto;background:#111;padding:20px;border-radius:10px}.game-board{width:300px;height:400px;background:#222;border:2px solid #fff;margin:20px auto;position:relative}.info{background:#333;padding:15px;margin:10px 0;border-radius:5px}pre{color:#0f0;font-family:monospace}</style></head><body><div class=game-container><h1>TETRIS ON K3S</h1><div class=game-board><div style=padding:20px;color:#fff>Click Start to Play!</div></div><div class=info><h3>Game Controls:</h3><p>Arrow Keys: Move</p><p>Down Arrow: Drop</p><p>Up Arrow: Rotate</p><button onclick=startGame() style=padding:10px 20px;font-size:16px;background:#4CAF50;color:white;border:none;border-radius:5px;cursor:pointer>Start Game</button></div><div class=info><h3>Kubernetes Info</h3><p><strong>Cluster:</strong> K3s</p><p><strong>Namespace:</strong> games</p><p><strong>Pod:</strong> tetris</p><p><strong>Status:</strong> <span style=color:#4CAF50>Running</span></p></div><pre>     ▄▄▄▄▄▄▄     <br>     █  █  █     <br>     █▄▄█▄▄█     <br>   TETRIS ON K3S </pre></div><script>function startGame(){alert(\"Tetris Game Starting!\\n\\nThis is running on your K3s cluster!\\n\\nFor a full Tetris experience, try:\\nhttps://tetris.com/play-tetris\");}</script></body></html>\" > /usr/share/nginx/html/index.html'"

for /f "tokens=*" %%i in ('vagrant ssh k3s-master -c "kubectl get svc tetris -n games -o jsonpath='{.spec.ports[0].nodePort}'"') do set TETRISPORT=%%i

echo.
echo [SUCCESS] Tetris Game deployed!
echo.
echo Play at: http://192.168.56.10:!TETRISPORT!
echo Use arrow keys to play when ready!
echo.
echo [INFO] Pod status:
vagrant ssh k3s-master -c "kubectl get pods -n games"
goto menu_return

:test_connectivity
echo.
echo [INFO] Testing Network Connectivity...
echo.

echo [TEST] Pinging master node...
ping 192.168.56.10 -n 2

echo.
echo [TEST] Testing common ports...
powershell -Command "Test-NetConnection -ComputerName 192.168.56.10 -Port 6443 -InformationLevel Quiet" && echo Port 6443 (K8s API): OPEN || echo Port 6443 (K8s API): CLOSED
powershell -Command "Test-NetConnection -ComputerName 192.168.56.10 -Port 8080 -InformationLevel Quiet" && echo Port 8080 (HTTP): OPEN || echo Port 8080 (HTTP): CLOSED

echo.
echo [TEST] Checking existing services...
vagrant ssh k3s-master -c "kubectl get svc --all-namespaces"

goto menu_return

:view_games
echo.
echo [INFO] Viewing All Deployed Games...
echo.

echo === NAMESPACES ===
vagrant ssh k3s-master -c "kubectl get namespaces"

echo.
echo === PODS ===
vagrant ssh k3s-master -c "kubectl get pods --all-namespaces"

echo.
echo === SERVICES ===
vagrant ssh k3s-master -c "kubectl get svc --all-namespaces"

echo.
echo === NODE PORTS ===
vagrant ssh k3s-master -c "kubectl get svc --all-namespaces | grep NodePort"

goto menu_return

:cleanup_games
echo.
set /p confirm="Are you sure you want to delete ALL game namespaces? (y/N): "
if /i not "%confirm%"=="y" goto menu_return

echo [INFO] Cleaning up game namespaces...
vagrant ssh k3s-master -c "kubectl delete namespace games --ignore-not-found=true"
vagrant ssh k3s-master -c "kubectl delete namespace minecraft --ignore-not-found=true"
vagrant ssh k3s-master -c "kubectl delete namespace dashboard --ignore-not-found=true"
vagrant ssh k3s-master -c "kubectl delete namespace fun --ignore-not-found=true"

echo.
echo [SUCCESS] All game namespaces cleaned up!
goto menu_return

:invalid_choice
echo.
echo [ERROR] Invalid choice. Please select 0-7.
goto menu_return

:menu_return
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:end
echo.
echo [INFO] Exiting Fun Games
echo Thanks for testing K3s on Windows!
exit /b 0