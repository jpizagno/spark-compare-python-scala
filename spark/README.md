## build

```
shell% ./build-spark.sh
```

## run 

```
shell% docker-compose -f start-spark.yml up --force-recreate
```

## work on master:

```
shell% docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                                                                                                                     NAMES
.........
3ce8031bfc0d        spark_spark-master   "bin/spark-class org…"   2 minutes ago       Up 2 minutes        0.0.0.0:4040-4042->4040-4042/tcp, 0.0.0.0:6066->6066/tcp, 0.0.0.0:7077->7077/tcp, 0.0.0.0:8080->8080/tcp, 7001-7005/tcp   master
shell%  docker exec -it 3ce8031bfc0d bash 
root@master:/opt/huginn/software/spark-2.4.7-bin-hadoop2.6# spark-shell
.....
scala> 
```