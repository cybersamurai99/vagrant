## Runners
gitlab-runners is installed on the same VM
You need to configure the runners after by going into admin -> runners

Then run the runner config as root (sudo). For example:
```
gitlab-runner register  --url http://gitlab.local  --token glrt-zq3_93dzJjbgq3VQL-ad
```

>Note: remember to use the shell executioner

tagging is optional. i'd suggest just using this as a default for now and going to a docker runner later.