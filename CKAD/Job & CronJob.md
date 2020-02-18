## Jobs

### RestartPolicy

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: math-add
spec:
  containers:
  - name: math-add
    image: ubuntu
    command: ["expr", "1", "+", "2"]
  restartPolicy: Never # default: Always
```

### Job Creation

Example: Create a job called `whalesay` with image `docker/whalesay` and command "cowsay I am going to ace CKAD!".

- completions: 10
- backoffLimit: 6
- restartPolicy: Never

```bash
kubectl create job whalesay --image=docker/whalesay --dry-run -o yaml > whalesay.yml

vi whalesay.yml

kubectl create -f whalesay.yml

kubectl get jobs
kubectl describe job whalesay
```

Create a job with image perl that runs the command with arguments "perl -Mbignum=bpi -wle 'print bpi(2000)'"

```bash
kubectl create job pi --image=perl -- perl -Mbignum=bpi -wle 'print bpi(2000)'
```

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: OnFailure
  backoffLimit: 4
```

Create a job with the image busybox that executes the command 'echo hello;sleep 30;echo world'

```bash
kubectl create job busybox --image=busybox -- /bin/sh -c 'echo hello;sleep 30;echo world'

# Delete a job
kubectl delete job busybox
```

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: whalesay
spec:
  activeDeadlineSeconds: 30 # automatically terminated by kubernetes if it takes more than 30 seconds to execute
  completions: 10
  parallelism: 3
  backoffLimit: 6
  template:  
    spec:
      containers:
      - name: whalesay
        image: docker/whalesay
        command: ["cowsay"]
        args: ["I am going to ace CKAD!"]
      restartPolicy: OnFailure
```

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: math-add-job
spec:
  activeDeadlineSeconds: 30 # automatically terminated by kubernetes if it takes more than 30 seconds to execute
  completions: 3 # Multiple Pods
  parallelism: 3
  template:  
    spec:
      containers:
      - name: math-add
        image: ubuntu
        command: ["expr", "1", "+", "2"]
      restartPolicy: OnFailure
  backoffLimit: 4
```

#### Pod backoff failure policy

There are situations where you want to fail a Job after some amount of retries due to a logical error in configuration etc. To do so, set .spec.backoffLimit to specify the number of retries before considering a Job as failed. The back-off limit is set by default to 6. Failed Pods associated with the Job are recreated by the Job controller with an exponential back-off delay (10s, 20s, 40s …) capped at six minutes. The back-off count is reset if no new failed Pods appear before the Job’s next status check.

#### Job Commands

```bash
kubectl create -f job-definition.yml

kubectl get jobs
kubectl get job busybox -w # will take two and a half minutes

# Get output
kubectl logs math-add-job-ld87pn
## Output: 3

# Delete job
kubectl delete job math-add-job

# Inspect job
kubectl describe job throw-dice-job
```

## CronJob

```bash
kubectl create cronjob busybox --image=busybox --schedule="*/1 * * * *" -- /bin/sh -c 'date; echo Hello from the Kubernetes cluster'

# See its logs and delete it
kubectl get cj
kubectl get jobs --watch
kubectl get po --show-labels # observe that the pods have a label that mentions their 'parent' job
kubectl logs busybox-1529745840-m867r
# Bear in mind that Kubernetes will run a new job/pod for each new cron job
kubectl delete cj busybox

# Create from a file
kubectl create -f cron-job-definition.yml
# Get
kubectl get cronjobs
```

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
          restartPolicy: OnFailure
```