
The goal is to compare the runtimes of Scala vs Python in a Spark context. This runs the exact same logic in Spark, but one version is scala and another version is written in Python.
The results are that the median Scala runtime is 30.61 seconds (std-dev = 1.51 sec) and the Python implementation median 
runtime is 111.60 seconds (std-dev 10.53).   Or in other words, Scala is about 3.6 X-times (111.60/30.61) faster than Python. 


## Build
see README in spark/ to build (and run) a local dockerized spark "cluster".

to package:
```
./sbt assembly

# jar is here
./target/scala-2.11/test-scala.jar

# python code (not built buy sbt) is here:
./people_python/main.py
```

## Generate Data and Copy into Spark Nodes

```
# generate data
shell% python create_data.py  > name_data.csv

# copy into Spark
shell% docker cp name_data.csv a1db7927e61c:/tmp/    # container-id spark_spark-worker
shell% docker cp name_data.csv 8ba4e1f380f5:/tmp/    # container-id spark_spark-master
```

## Run

To start Scala in Docker Container:
```
# copy jar to master node: 
shell% docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                                                                                                                     NAMES
...
8ba4e1f380f5        spark_spark-master      .....
shell% docker cp ./target/scala-2.11/test-scala.jar 8ba4e1f380f5:/tmp/test-scala.jar

# login to master node and run JAR via spark-submit: 
shell% docker exec -it 8ba4e1f380f5 bash
root@master:shell%  spark-submit --class com.news.analyzer.Main --master local[*] /tmp/test-scala.jar
```

To start Python in Docker Container:
```
# copy main.py to master node
shell% docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                                                                                                                     NAMES
...
8ba4e1f380f5        spark_spark-master      .....
shell% docker cp ./target/scala-2.11/main.py 8ba4e1f380f5:/tmp/main.py

spark-submit main.py
```

## Results

Here are the results for Scala:
```
shell% docker exec -it 8ba4e1f380f5 bash
root@master:shell%  spark-submit --class com.news.analyzer.Main --master local[*] /tmp/test-scala.jar
...
count is people_new_ids_high.count()=99999555
run time is 32.587 seconds
 *******************  
 shutting down job
 *******************
```
Here are 10 Scala runs:  32.587, 32.005, 32.375, 30.41, 30.199, 26.941, 30.221, 30.677, 31.0, 30.534
median = 30.61
stddev = 1.51

Here are the results for Python:
```
shell% docker cp ./people_python/main.py 8ba4e1f380f5:/tmp/main.py
shell% docker exec -it 8ba4e1f380f5 bash
root@master:shell% spark-submit --master local[*] /tmp/main.py
...
99999555
took 144.828240156 seconds
...
```
Here are 10 Python runs:  144.828, 113.5989, 111.128, 115.289, 112.065, 104.546, 109.338, 109.852, 109.852, 115.832
median = 111.60
stddev = 10.53

## Extra:  SBT Specific Build and Test

to compile
```
./sbt compile
```

to test:
```
./sbt it:test
./sbt test
```

to run:
```
./sbt run
```

to package:
```
./sbt assembly
/target/scala-2.11/news-matcher-assembly-2f43a4ad3760da95174b4881e5cfce0ca5387611-SNAPSHOT.jar
```
