# experimental-redis-cluster

https://redis.io/docs/management/scaling/

# usage

## init

``` bash
direnv allow
bin/init.sh
```

## log

``` bash
bin/kubectl.sh exec -it redis-0 -- tail -F /tmp/redis.log
```

# requirements

- [kubectl](https://kubernetes.io/docs/reference/kubectl/)
- [kind](https://kind.sigs.k8s.io/)
- [direnv](https://github.com/direnv/direnv)
