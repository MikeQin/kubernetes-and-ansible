# Pod Design

## Labels, Selectors & Annotations

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
  labels:
    app: App1
    function: Front-end
  annotations:
    buildVersion: 1.34
spec:
  containers:
  - name: app
    image: app
    ports:
      - containerPort: 8080
```

```bash
kubectl get pods --selector app=App1

kubectl get pods --selector bu-finance --selector tier=frontend --selector env=prod
```

## Rolling Update & Rollback in Deployment

Strategies:
- Recreate
- RollingUpdate (default)

```yaml
kind: Deployment
spec:
  strategy:
    type: Recreate # Default: RollingUpdate
```

```
kubectl rollout status deployment/myapp-deployment
kubectl rollout status deploy myapp-deployment
```

```bash
kubectl apply -f deploy-def.yml

# Temporary
kubectl set image deploy myapp-deployment nginx-container=nginx:1.9.1
kubectl set image deploy frontend simple-webapp=kodekloud/webapp-color:v3
```

```bash
kubectl rollout undo deployment/myapp-deployment

# See before & after
kubectl get replicasets
```

### Sumarize Commands

```bash
# Create & record revision history
kubectl create -f deployment-definition.yml --record

# Get
kubectl get deployments

# Update
kubectl apply -f deployment-definition.yml
kubectl set image deployment/myapp-deployment nginx-container=nginx:1.9.1

# Status
kubectl rollout status deployment/myapp-deployment
# Revision history
kubectl rollout history deployment/myapp-deployment

# Rollback
kubectl rollout undo deployment/myapp
```

## Jobs

### RestartPolicy

```yaml
kind: Pod
spec:
  containers:
  - name: math-add
    image: ubuntu
    command: ["expr", "1", "+", "2"]
  restartPolicy: Never # Always
```

### Job

#### `job-definition.yml`

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: math-add-job
spec:
  completions: 3 # Multiple Pods
  parallelism: 3
  template:  
    spec:
      containers:
      - name: math-add
        image: ubuntu
        command: ["expr", "1", "+", "2"]
      restartPolicy: Never # Always 
  backoffLimit: 4
```

#### Pod backoff failure policy

There are situations where you want to fail a Job after some amount of retries due to a logical error in configuration etc. To do so, set .spec.backoffLimit to specify the number of retries before considering a Job as failed. The back-off limit is set by default to 6. Failed Pods associated with the Job are recreated by the Job controller with an exponential back-off delay (10s, 20s, 40s …) capped at six minutes. The back-off count is reset if no new failed Pods appear before the Job’s next status check.

#### Job Commands

```bash
kubectl create -f job-definition.yml

kubectl get jobs

# Get output
kubectl logs math-add-job-ld87pn
## Output: 3

# Delete job
kubectl delete job math-add-job

# Inspect job
kubectl describe job throw-dice-job
```

## CronJob

- cron-job-definition.yml

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: reporting-cron-job
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      completions: 3 # Multiple Pods
      parallelism: 3
      template:
        spec:
          containers:
          - name: reporting-tool
            image: reporting-tool
          restartPolicy: Never # Always 
```

```bash
kubectl create -f cron-job-definition.yml

kubectl get cronjobs
```