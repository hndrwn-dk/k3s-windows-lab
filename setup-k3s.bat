@echo off
setlocal enabledelayedexpansion

echo ================================================
echo           K3s Kubernetes Lab Setup
echo ================================================
echo.

:: Check if Vagrant is installed
vagrant --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Vagrant is not installed or not in PATH
    echo Please install Vagrant from: https://www.vagrantup.com/
    pause
    exit /b 1
)

:: Check if VirtualBox is installed
vboxmanage --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: VirtualBox is not installed or not in PATH
    echo Please install VirtualBox from: https://www.virtualbox.org/
    pause
    exit /b 1
)

echo [INFO] Vagrant and VirtualBox detected successfully
echo.

:: Use current directory as project directory
set PROJECT_DIR=%CD%
echo [INFO] Using project directory: %PROJECT_DIR%

cd /d "%PROJECT_DIR%"

:menu_start
echo ================================================
echo           K3s Kubernetes Lab Setup
echo ================================================
echo.

:: Check if Vagrantfile exists
if not exist "Vagrantfile" (
    echo [ERROR] Vagrantfile not found!
    echo Please ensure you have a valid Vagrantfile in this directory.
    echo You can copy it from the provided artifact or create it manually.
    pause
    exit /b 1
) else (
    echo [INFO] Vagrantfile found
)

:: Start the main menu loop
goto menu_start

:: This should never be reached
goto end

:: Menu for user choice
echo ================================================
echo Select an option:
echo 1. Start full cluster (master + 1 worker)
echo 2. Start full cluster (master + 2 workers)
echo 3. Start master only
echo 4. Start worker1 only
echo 5. Start worker2 only
echo 6. Stop all VMs
echo 7. Destroy all VMs
echo 8. Check cluster status
echo 9. SSH to master
echo 10. SSH to worker1
echo 11. SSH to worker2
echo 12. Get kubeconfig
echo 13. Install kubectl on Windows (optional)
echo 0. Exit
echo ================================================
set /p choice="Enter your choice (0-13): "

if "%choice%"=="1" goto start_cluster_1worker
if "%choice%"=="2" goto start_cluster_2workers
if "%choice%"=="3" goto start_master_only
if "%choice%"=="4" goto start_worker1_only
if "%choice%"=="5" goto start_worker2_only
if "%choice%"=="6" goto stop_all
if "%choice%"=="7" goto destroy_all
if "%choice%"=="8" goto check_status
if "%choice%"=="9" goto ssh_master
if "%choice%"=="10" goto ssh_worker1
if "%choice%"=="11" goto ssh_worker2
if "%choice%"=="12" goto get_kubeconfig
if "%choice%"=="13" goto install_kubectl
if "%choice%"=="0" goto end
goto invalid_choice

:start_cluster_1worker
echo.
echo [INFO] Starting K3s cluster with master and 1 worker...
echo [INFO] This will take several minutes...
vagrant up k3s-master k3s-worker1
if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Cluster started successfully!
    call :show_cluster_info
) else (
    echo [ERROR] Failed to start cluster
)
goto menu_return

:start_cluster_2workers
echo.
echo [INFO] Starting K3s cluster with master and 2 workers...
echo [INFO] This will take several minutes...
vagrant up k3s-master k3s-worker1 k3s-worker2
if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Cluster started successfully!
    call :show_cluster_info
) else (
    echo [ERROR] Failed to start cluster
)
goto menu_return

:start_master_only
echo.
echo [INFO] Starting K3s master only...
vagrant up k3s-master
if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Master started successfully!
    call :show_cluster_info
) else (
    echo [ERROR] Failed to start master
)
goto menu_return

:start_worker1_only
echo.
echo [INFO] Starting worker1 only...
vagrant up k3s-worker1
if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Worker1 started successfully!
) else (
    echo [ERROR] Failed to start worker1
)
goto menu_return

:start_worker2_only
echo.
echo [INFO] Starting worker2 only...
vagrant up k3s-worker2
if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Worker2 started successfully!
) else (
    echo [ERROR] Failed to start worker2
)
goto menu_return

:stop_all
echo.
echo [INFO] Stopping all VMs...
vagrant halt
echo [INFO] All VMs stopped
goto menu_return

:destroy_all
echo.
set /p confirm="Are you sure you want to destroy all VMs? (y/N): "
if /i "%confirm%"=="y" (
    echo [INFO] Destroying all VMs...
    vagrant destroy -f
    if exist "node-token" del "node-token"
    echo [INFO] All VMs destroyed
) else (
    echo [INFO] Operation cancelled
)
goto menu_return

:check_status
echo.
echo [INFO] Checking VM status...
vagrant status
echo.
echo [INFO] Checking cluster status (if master is running)...
vagrant ssh k3s-master -c "kubectl get nodes -o wide" 2>nul
if %errorlevel% neq 0 (
    echo [WARNING] Could not connect to master or cluster not ready
)
goto menu_return

:ssh_master
echo.
echo [INFO] Connecting to master node...
echo [INFO] Use 'exit' to return to menu
vagrant ssh k3s-master
goto menu_return

:ssh_worker1
echo.
echo [INFO] Connecting to worker1 node...
echo [INFO] Use 'exit' to return to menu
vagrant ssh k3s-worker1
goto menu_return

:ssh_worker2
echo.
echo [INFO] Connecting to worker2 node...
echo [INFO] Use 'exit' to return to menu
vagrant ssh k3s-worker2
goto menu_return

:get_kubeconfig
echo.
echo [INFO] Getting kubeconfig from master...
if not exist "kubeconfig" mkdir kubeconfig
vagrant ssh k3s-master -c "cat /home/vagrant/.kube/config" > kubeconfig\k3s-config 2>nul
if %errorlevel% equ 0 (
    echo [SUCCESS] Kubeconfig saved to: %CD%\kubeconfig\k3s-config
    echo.
    echo To use kubectl from Windows:
    echo 1. Install kubectl (option 9)
    echo 2. Set environment variable: set KUBECONFIG=%CD%\kubeconfig\k3s-config
    echo 3. Or copy config to: %USERPROFILE%\.kube\config
) else (
    echo [ERROR] Could not retrieve kubeconfig. Is the master running?
)
goto menu_return

:install_kubectl
echo.
echo [INFO] Downloading kubectl for Windows...
if not exist "tools" mkdir tools
cd tools
curl -LO "https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe"
if %errorlevel% equ 0 (
    echo [SUCCESS] kubectl downloaded to: %CD%\kubectl.exe
    echo.
    echo To use kubectl:
    echo 1. Add %CD% to your PATH environment variable, or
    echo 2. Use full path: %CD%\kubectl.exe
    echo 3. Set KUBECONFIG to point to your config file
) else (
    echo [ERROR] Failed to download kubectl
)
cd ..
goto menu_return

:show_cluster_info
echo.
echo ================================================
echo              Cluster Information
echo ================================================
echo Master IP: 192.168.56.10
echo Worker1 IP: 192.168.56.11
echo Worker2 IP: 192.168.56.12 (if started)
echo.
echo Port Forwards:
echo - Kubernetes API: localhost:6443
echo - HTTP: localhost:8080
echo - HTTPS: localhost:8443
echo.
echo Access URLs:
echo - kubectl: Use kubeconfig from option 8
echo - Dashboard: Deploy using kubectl
echo ================================================
exit /b 0

:invalid_choice
echo.
echo [ERROR] Invalid choice. Please select 0-13.
goto menu_return

:menu_return
echo.
echo Press any key to return to menu...
pause > nul
cls
goto menu_start

:menu_start

:end
echo.
echo [INFO] Exiting K3s setup script
echo Thank you for using K3s Lab Setup!
exit /b 0