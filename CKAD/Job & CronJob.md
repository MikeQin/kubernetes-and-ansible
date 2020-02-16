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