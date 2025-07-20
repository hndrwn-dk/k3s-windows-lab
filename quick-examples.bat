@echo off
setlocal enabledelayedexpansion

echo ================================================
echo         K3s Quick Examples Deployer
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
echo         K3s Quick Examples Menu
echo ================================================
echo.
echo Choose an example to deploy:
echo.
echo 1. Simple Web App with Ingress (Traefik)
echo 2. App with Persistent Storage
echo 3. Resource Monitoring Demo
echo 4. DNS Testing Pod
echo 5. Load Balancer Example
echo 6. Multi-Pod Application
echo 7. View All Deployed Examples
echo 8. Clean Up All Examples
echo 9. Interactive Pod (Troubleshooting)
echo 0. Exit
echo.
echo ================================================
set /p choice="Enter your choice (0-9): "

if "%choice%"=="1" goto deploy_web_app
if "%choice%"=="2" goto deploy_storage_app
if "%choice%"=="3" goto deploy_monitoring
if "%choice%"=="4" goto deploy_dns_test
if "%choice%"=="5" goto deploy_loadbalancer
if "%choice%"=="6" goto deploy_multi_pod
if "%choice%"=="7" goto view_examples
if "%choice%"=="8" goto cleanup_examples
if "%choice%"=="9" goto interactive_pod
if "%choice%"=="0" goto end
goto invalid_choice

:deploy_web_app
echo.
echo [INFO] Deploying Simple Web App with Traefik Ingress...
vagrant ssh k3s-master -c "
# Create namespace
kubectl create namespace web-demo

# Deploy nginx
kubectl create deployment nginx-demo --image=nginx --namespace=web-demo
kubectl expose deployment nginx-demo --port=80 --namespace=web-demo

# Create ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  namespace: web-demo
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: web
spec:
  rules:
  - host: nginx.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-demo
            port:
              number: 80
EOF

echo 'Web app deployed successfully!'
echo 'Add this to your Windows hosts file:'
echo '192.168.56.10 nginx.local'
echo 'Then visit: http://nginx.local'
"
goto menu_return

:deploy_storage_app
echo.
echo [INFO] Deploying App with Persistent Storage...
vagrant ssh k3s-master -c "
# Create namespace
kubectl create namespace storage-demo

# Create PVC
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
  namespace: storage-demo
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: local-path
EOF

# Deploy app with storage
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: storage-app
  namespace: storage-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: storage-app
  template:
    metadata:
      labels:
        app: storage-app
    spec:
      containers:
      - name: app
        image: nginx
        volumeMounts:
        - name: data-volume
          mountPath: /usr/share/nginx/html
        ports:
        - containerPort: 80
      volumes:
      - name: data-volume
        persistentVolumeClaim:
          claimName: data-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: storage-app-service
  namespace: storage-demo
spec:
  selector:
    app: storage-app
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
EOF

echo 'Storage app deployed!'
echo 'Check with: kubectl get pods -n storage-demo'
"
goto menu_return

:deploy_monitoring
echo.
echo [INFO] Deploying Resource Monitoring Demo...
vagrant ssh k3s-master -c "
# Create namespace
kubectl create namespace monitoring-demo

# Deploy CPU-intensive app
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu-demo
  namespace: monitoring-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: cpu-demo
  template:
    metadata:
      labels:
        app: cpu-demo
    spec:
      containers:
      - name: cpu-demo
        image: nginx
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
EOF

echo 'Monitoring demo deployed!'
echo 'Check resource usage with: kubectl top pods -n monitoring-demo'
"
goto menu_return

:deploy_dns_test
echo.
echo [INFO] Deploying DNS Testing Pod...
vagrant ssh k3s-master -c "
# Create long-running DNS test pod
kubectl run dns-test-pod --image=busybox --restart=Never -- sleep 3600

echo 'DNS test pod created!'
echo 'Test DNS with:'
echo '  kubectl exec dns-test-pod -- nslookup kubernetes.default'
echo '  kubectl exec dns-test-pod -- nslookup google.com'
echo 'Delete with: kubectl delete pod dns-test-pod'
"
goto menu_return

:deploy_loadbalancer
echo.
echo [INFO] Deploying Load Balancer Example...
vagrant ssh k3s-master -c "
# Create namespace
kubectl create namespace lb-demo

# Deploy multiple replicas
kubectl create deployment lb-app --image=gcr.io/google-samples/hello-app:1.0 --replicas=3 --namespace=lb-demo
kubectl expose deployment lb-app --port=8080 --target-port=8080 --type=NodePort --namespace=lb-demo

echo 'Load balancer demo deployed!'
echo 'Check service: kubectl get svc -n lb-demo'
echo 'Test load balancing: curl multiple times to the NodePort'
"
goto menu_return

:deploy_multi_pod
echo.
echo [INFO] Deploying Multi-Pod Application (Frontend + Backend)...
vagrant ssh k3s-master -c "
# Create namespace
kubectl create namespace multi-demo

# Deploy backend
kubectl create deployment backend --image=gcr.io/google-samples/hello-app:1.0 --namespace=multi-demo
kubectl expose deployment backend --port=8080 --namespace=multi-demo

# Deploy frontend
kubectl create deployment frontend --image=nginx --namespace=multi-demo
kubectl expose deployment frontend --port=80 --type=NodePort --namespace=multi-demo

echo 'Multi-pod application deployed!'
echo 'Frontend and backend are running in multi-demo namespace'
echo 'Check with: kubectl get all -n multi-demo'
"
goto menu_return

:view_examples
echo.
echo [INFO] Viewing All Deployed Examples...
vagrant ssh k3s-master -c "
echo '=== NAMESPACES ==='
kubectl get namespaces | grep -E 'demo|test'

echo -e '\n=== PODS ==='
kubectl get pods -A | grep -E 'demo|test'

echo -e '\n=== SERVICES ==='
kubectl get svc -A | grep -E 'demo|test'

echo -e '\n=== INGRESSES ==='
kubectl get ingress -A

echo -e '\n=== PERSISTENT VOLUMES ==='
kubectl get pv

echo -e '\n=== STORAGE USAGE ==='
kubectl top pods -A 2>/dev/null | grep -E 'demo|test' || echo 'Metrics not available yet'
"
goto menu_return

:cleanup_examples
echo.
set /p confirm="Are you sure you want to delete ALL example deployments? (y/N): "
if /i not "%confirm%"=="y" goto menu_return

echo [INFO] Cleaning up all example deployments...
vagrant ssh k3s-master -c "
# Delete all demo namespaces
kubectl delete namespace web-demo --ignore-not-found=true
kubectl delete namespace storage-demo --ignore-not-found=true  
kubectl delete namespace monitoring-demo --ignore-not-found=true
kubectl delete namespace lb-demo --ignore-not-found=true
kubectl delete namespace multi-demo --ignore-not-found=true

# Delete standalone pods
kubectl delete pod dns-test-pod --ignore-not-found=true

echo 'All examples cleaned up!'
"
goto menu_return

:interactive_pod
echo.
echo [INFO] Creating interactive troubleshooting pod...
vagrant ssh k3s-master -c "
kubectl run debug-pod --image=busybox --rm -it --restart=Never -- sh
"
goto menu_return

:invalid_choice
echo.
echo [ERROR] Invalid choice. Please select 0-9.
goto menu_return

:menu_return
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:end
echo.
echo [INFO] Exiting Quick Examples
echo Thanks for testing K3s components!
exit /b 0