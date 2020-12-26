import pyspark
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType,StructField, StringType, IntegerType, DoubleType
from pyspark.sql.functions import udf
import math
import time


def new_id(old_id):
    return math.log(float(old_id+1)/ float(old_id + 10))


def main():

    spark = SparkSession.builder.master("local[*]") \
        .appName('test_python') \
        .getOrCreate()

    schema = StructType([ \
        StructField("id",IntegerType(),True), \
        StructField("first_name",StringType(),True), \
        StructField("last_name",StringType(),True)
        ])

    people = spark.read.format("csv") \
        .option("header", True) \
        .schema(schema) \
        .load("/tmp/name_data.csv")

    # people.count():  22seconds,

    new_id_udf = udf(new_id, DoubleType())

    people_new_ids = people.withColumn("new_id", new_id_udf("id"))

    people_new_ids_high = people_new_ids.filter(people_new_ids.new_id > -0.02)

    start_time = time.time()
    print(people_new_ids_high.count())
    end_time = time.time()
    print("took "+str(end_time - start_time)+" seconds")

if __name__ == '__main__':
    main()