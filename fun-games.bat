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
echo 1. Tetris Game (HTML5 retro game)
echo 2. Snake Game (Classic arcade)
echo 3. Pong Game (Classic paddle game)
echo 4. Memory Game (Card matching)
echo 5. Test Connectivity (Network check)
echo 6. View Running Games
echo 7. Clean Up All Games
echo 0. Exit
echo.
echo ================================================
set /p choice="Enter your choice (0-7): "

if "%choice%"=="1" goto deploy_tetris
if "%choice%"=="2" goto deploy_snake
if "%choice%"=="3" goto deploy_pong
if "%choice%"=="4" goto deploy_memory
if "%choice%"=="5" goto test_connectivity
if "%choice%"=="6" goto view_games
if "%choice%"=="7" goto cleanup_games
if "%choice%"=="0" goto end
goto invalid_choice

:deploy_tetris
echo.
echo [INFO] Deploying Tetris Game...
vagrant ssh k3s-master -c "kubectl create namespace games 2>/dev/null || echo 'namespace exists'"
vagrant ssh k3s-master -c "kubectl delete pod tetris -n games 2>/dev/null || echo 'no existing tetris pod'"
vagrant ssh k3s-master -c "kubectl delete service tetris -n games 2>/dev/null || echo 'no existing tetris service'"

echo [INFO] Creating Tetris pod...
vagrant ssh k3s-master -c "kubectl run tetris --image=nginx:alpine --port=80 --namespace=games"
vagrant ssh k3s-master -c "kubectl expose pod tetris --port=80 --target-port=80 --type=NodePort --namespace=games"

echo [INFO] Waiting for pod to be ready...
vagrant ssh k3s-master -c "kubectl wait --for=condition=Ready pod/tetris -n games --timeout=60s"

echo [INFO] Adding Tetris game content...
vagrant ssh k3s-master -c "kubectl exec tetris -n games -- sh -c 'echo \"<html><body><h1>TETRIS GAME</h1><p>Running on K3s Cluster</p><p>Namespace: games | Pod: tetris</p><button onclick=alert(\\\"Tetris on K3s!\\\")>Test Game</button></body></html>\" > /usr/share/nginx/html/index.html'"

for /f "tokens=*" %%i in ('vagrant ssh k3s-master -c "kubectl get svc tetris -n games -o jsonpath='{.spec.ports[0].nodePort}'"') do set TETRISPORT=%%i

echo.
echo [SUCCESS] Tetris Game deployed!
echo Play at: http://192.168.56.10:!TETRISPORT!
goto menu_return

:deploy_snake
echo.
echo [INFO] Deploying Snake Game...
vagrant ssh k3s-master -c "kubectl create namespace games 2>/dev/null || echo 'namespace exists'"
vagrant ssh k3s-master -c "kubectl delete pod snake -n games 2>/dev/null || echo 'no existing snake pod'"
vagrant ssh k3s-master -c "kubectl delete service snake -n games 2>/dev/null || echo 'no existing snake service'"

echo [INFO] Creating Snake pod...
vagrant ssh k3s-master -c "kubectl run snake --image=nginx:alpine --port=80 --namespace=games"
vagrant ssh k3s-master -c "kubectl expose pod snake --port=80 --target-port=80 --type=NodePort --namespace=games"

echo [INFO] Adding Snake game content...
vagrant ssh k3s-master -c "kubectl exec snake -n games -- sh -c 'echo \"<html><head><title>Snake Game</title><style>body{font-family:Arial;text-align:center;background:#2d5a27;color:#fff;padding:20px}.container{max-width:600px;margin:0 auto;background:#1a3818;padding:20px;border-radius:10px}.board{width:400px;height:400px;background:#0d2818;border:2px solid #fff;margin:20px auto}.info{background:#2d5a27;padding:15px;margin:10px 0;border-radius:5px}.btn{padding:10px 20px;background:#4CAF50;color:white;border:none;border-radius:5px;cursor:pointer}</style></head><body><div class=container><h1>SNAKE GAME</h1><div class=board><p style=padding:20px>Snake Game Area</p></div><div class=info><p>Score: 0</p><button class=btn onclick=alert(\"Snake Game Running on K3s!\")>Start Game</button></div><div class=info><p>Running on K3s Cluster</p><p>Namespace: games | Pod: snake</p></div></div></body></html>\" > /usr/share/nginx/html/index.html'"

for /f "tokens=*" %%i in ('vagrant ssh k3s-master -c "kubectl get svc snake -n games -o jsonpath='{.spec.ports[0].nodePort}'"') do set SNAKEPORT=%%i

echo.
echo [SUCCESS] Snake Game deployed!
echo Play at: http://192.168.56.10:!SNAKEPORT!
goto menu_return

:deploy_pong
echo.
echo [INFO] Deploying Pong Game...
vagrant ssh k3s-master -c "kubectl create namespace games 2>/dev/null || echo 'namespace exists'"
vagrant ssh k3s-master -c "kubectl delete pod pong -n games 2>/dev/null || echo 'no existing pong pod'"
vagrant ssh k3s-master -c "kubectl delete service pong -n games 2>/dev/null || echo 'no existing pong service'"

echo [INFO] Creating Pong pod...
vagrant ssh k3s-master -c "kubectl run pong --image=nginx:alpine --port=80 --namespace=games"
vagrant ssh k3s-master -c "kubectl expose pod pong --port=80 --target-port=80 --type=NodePort --namespace=games"

echo [INFO] Adding Pong game content...
vagrant ssh k3s-master -c "kubectl exec pong -n games -- sh -c 'echo \"<html><head><title>Pong Game</title><style>body{font-family:Arial;text-align:center;background:#000;color:#fff;padding:20px}.container{max-width:600px;margin:0 auto}.board{width:600px;height:400px;background:#000;border:2px solid #fff;margin:20px auto}.info{background:#333;padding:15px;margin:10px 0;border-radius:5px}.btn{padding:10px 20px;background:#4CAF50;color:white;border:none;border-radius:5px;cursor:pointer}</style></head><body><div class=container><h1>PONG GAME</h1><div class=board><p style=padding:20px>Pong Game Court</p></div><div class=info><p>Player: 0 | Computer: 0</p><button class=btn onclick=alert(\"Pong Game Running on K3s!\")>Start Game</button></div><div class=info><p>Running on K3s Cluster</p><p>Namespace: games | Pod: pong</p></div></div></body></html>\" > /usr/share/nginx/html/index.html'"

for /f "tokens=*" %%i in ('vagrant ssh k3s-master -c "kubectl get svc pong -n games -o jsonpath='{.spec.ports[0].nodePort}'"') do set PONGPORT=%%i

echo.
echo [SUCCESS] Pong Game deployed!
echo Play at: http://192.168.56.10:!PONGPORT!
goto menu_return

:deploy_memory
echo.
echo [INFO] Deploying Memory Game...
vagrant ssh k3s-master -c "kubectl create namespace games 2>/dev/null || echo 'namespace exists'"
vagrant ssh k3s-master -c "kubectl delete pod memory -n games 2>/dev/null || echo 'no existing memory pod'"
vagrant ssh k3s-master -c "kubectl delete service memory -n games 2>/dev/null || echo 'no existing memory service'"

echo [INFO] Creating Memory pod...
vagrant ssh k3s-master -c "kubectl run memory --image=nginx:alpine --port=80 --namespace=games"
vagrant ssh k3s-master -c "kubectl expose pod memory --port=80 --target-port=80 --type=NodePort --namespace=games"

echo [INFO] Adding Memory game content...
vagrant ssh k3s-master -c "kubectl exec memory -n games -- sh -c 'echo \"<html><head><title>Memory Game</title><style>body{font-family:Arial;text-align:center;background:#2c3e50;color:#fff;padding:20px}.container{max-width:600px;margin:0 auto}.grid{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;max-width:320px;margin:20px auto}.card{width:70px;height:70px;background:#34495e;border:2px solid #fff;border-radius:10px;display:flex;align-items:center;justify-content:center;cursor:pointer}.info{background:#34495e;padding:15px;margin:10px 0;border-radius:5px}.btn{padding:10px 20px;background:#3498db;color:white;border:none;border-radius:5px;cursor:pointer}</style></head><body><div class=container><h1>MEMORY GAME</h1><div class=grid><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div><div class=card>?</div></div><div class=info><p>Moves: 0 | Matches: 0</p><button class=btn onclick=alert(\"Memory Game Running on K3s!\")>New Game</button></div><div class=info><p>Running on K3s Cluster</p><p>Namespace: games | Pod: memory</p></div></div></body></html>\" > /usr/share/nginx/html/index.html'"

for /f "tokens=*" %%i in ('vagrant ssh k3s-master -c "kubectl get svc memory -n games -o jsonpath='{.spec.ports[0].nodePort}'"') do set MEMORYPORT=%%i

echo.
echo [SUCCESS] Memory Game deployed!
echo Play at: http://192.168.56.10:!MEMORYPORT!
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