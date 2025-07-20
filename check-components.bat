@echo off
setlocal enabledelayedexpansion

echo ================================================
echo         K3s Components Status Checker
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

echo [INFO] Checking K3s cluster components...
echo.

echo ================================================
echo CLUSTER OVERVIEW
echo ================================================
vagrant ssh k3s-master -c "kubectl get nodes -o wide"
echo.

echo ================================================
echo RESOURCE USAGE
echo ================================================
echo [INFO] Node resource usage:
vagrant ssh k3s-master -c "kubectl top nodes 2>/dev/null || echo 'Metrics not ready yet (wait 1-2 minutes)'"
echo.
echo [INFO] Pod resource usage (top 5):
vagrant ssh k3s-master -c "kubectl top pods -A --sort-by=cpu 2>/dev/null | head -6 || echo 'Metrics not ready yet'"
echo.

echo ================================================
echo TRAEFIK INGRESS CONTROLLER
echo ================================================
vagrant ssh k3s-master -c "kubectl get pods -n kube-system | grep traefik"
vagrant ssh k3s-master -c "kubectl get svc -n kube-system | grep traefik"
echo.
echo [INFO] To access Traefik dashboard:
echo   kubectl port-forward -n kube-system svc/traefik 9000:9000
echo   Then visit: http://localhost:9000/dashboard/
echo.

echo ================================================
echo COREDNS (CLUSTER DNS)
echo ================================================
vagrant ssh k3s-master -c "kubectl get pods -n kube-system | grep coredns"
echo.
echo [INFO] Testing DNS resolution...
vagrant ssh k3s-master -c "kubectl run dns-test --image=busybox --rm -it --restart=Never --timeout=10s -- nslookup kubernetes.default 2>/dev/null || echo 'DNS test completed'"
echo.

echo ================================================
echo METRICS SERVER
echo ================================================
vagrant ssh k3s-master -c "kubectl get pods -n kube-system | grep metrics-server"
echo.
echo [INFO] Metrics API status:
vagrant ssh k3s-master -c "kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes 2>/dev/null | head -1 || echo 'Metrics API not ready yet'"
echo.

echo ================================================
echo LOCAL PATH PROVISIONER (STORAGE)
echo ================================================
vagrant ssh k3s-master -c "kubectl get pods -n kube-system | grep local-path"
echo.
echo [INFO] Available storage classes:
vagrant ssh k3s-master -c "kubectl get storageclass"
echo.
echo [INFO] Current persistent volumes:
vagrant ssh k3s-master -c "kubectl get pv 2>/dev/null || echo 'No persistent volumes created yet'"
echo.

echo ================================================
echo ALL SYSTEM SERVICES
echo ================================================
vagrant ssh k3s-master -c "kubectl get svc -A"
echo.

echo ================================================
echo QUICK COMPONENT TEST
echo ================================================
echo [INFO] Testing component functionality...
echo.

echo [TEST] Creating test namespace...
vagrant ssh k3s-master -c "kubectl create namespace component-test 2>/dev/null || kubectl get namespace component-test"

echo [TEST] Testing basic pod creation...
vagrant ssh k3s-master -c "kubectl run test-pod --image=busybox --restart=Never --namespace=component-test -- sleep 30"

echo [TEST] Waiting for pod to start...
timeout /t 5 >nul
vagrant ssh k3s-master -c "kubectl get pods -n component-test"

echo [TEST] Testing storage class availability...
vagrant ssh k3s-master -c "kubectl get storageclass local-path -o name || echo 'Storage class not found'"

echo [TEST] Cleaning up test resources...
vagrant ssh k3s-master -c "kubectl delete namespace component-test --timeout=30s"

echo ================================================
echo COMPONENT STATUS SUMMARY
echo ================================================
echo.

:: Check each component status
set "traefik_status=NOT RUNNING"
set "coredns_status=NOT RUNNING"  
set "metrics_status=NOT RUNNING"
set "storage_status=NOT RUNNING"

vagrant ssh k3s-master -c "kubectl get pods -n kube-system | grep traefik | grep Running" >nul 2>&1
if %errorlevel% equ 0 set "traefik_status=RUNNING"

vagrant ssh k3s-master -c "kubectl get pods -n kube-system | grep coredns | grep Running" >nul 2>&1
if %errorlevel% equ 0 set "coredns_status=RUNNING"

vagrant ssh k3s-master -c "kubectl get pods -n kube-system | grep metrics-server | grep Running" >nul 2>&1
if %errorlevel% equ 0 set "metrics_status=RUNNING"

vagrant ssh k3s-master -c "kubectl get pods -n kube-system | grep local-path | grep Running" >nul 2>&1
if %errorlevel% equ 0 set "storage_status=RUNNING"

echo Traefik Ingress Controller: !traefik_status!
echo CoreDNS (Cluster DNS):     !coredns_status!
echo Metrics Server:            !metrics_status!
echo Local Path Provisioner:    !storage_status!
echo.

echo ================================================
echo USEFUL COMMANDS
echo ================================================
echo.
echo # Access Traefik Dashboard:
echo kubectl port-forward -n kube-system svc/traefik 9000:9000
echo.
echo # Monitor cluster resources:
echo kubectl top nodes
echo kubectl top pods -A
echo.
echo # Create persistent storage:
echo kubectl create -f your-pvc.yaml
echo.
echo # Test DNS resolution:
echo kubectl run test --image=busybox --rm -it -- nslookup kubernetes.default
echo.
echo # View all system components:
echo kubectl get pods -n kube-system
echo.

echo ================================================
echo All components checked! Happy clustering!
echo ================================================
echo.
pause