package com.news.analyzer

import java.util.Properties

import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.types._
import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions.{ col, udf }

object Main extends App {
  println(" ************ starting ... ")

  val spark = SparkSession
    .builder()
    .appName("test_scala")
    .getOrCreate()

  spark.sparkContext.setLogLevel("ERROR")

  import spark.implicits._ // for toDF()

  val customSchema = StructType(
    Array(
      StructField("id", IntegerType, true),
      StructField("first_name", StringType, true),
      StructField("last_name", StringType, true)
    )
  )

  val people: DataFrame = spark.read
    .format("csv")
    .option("header", "true")
    .option("delimiter", ",")
    .schema(customSchema)
    .load("/tmp/name_data.csv")

  def new_id(df: Integer): Double =
    // id/(id+1)  id = 2 return 2/3
    scala.math.log((df + 1).toDouble / (df + 10).toDouble)

  val new_id_udf = udf { df: Integer =>
    new_id(df)
  }
  val people_new_ids: DataFrame = people.withColumn("new_id", new_id_udf(col("id")))

  // people_new_ids_high.count():  48-56 seconds
  val people_new_ids_high: DataFrame = people_new_ids.filter(col("new_id") > -0.02)

  // time it
  val start_time: Long = System.currentTimeMillis
  println("count is people_new_ids_high.count()=" + people_new_ids_high.count())
  val end_time: Long = System.currentTimeMillis
  println("run time is " + (end_time - start_time) / 1000.0 + " seconds")

  // close Spark
  spark.close()

  // shut down process
  println(" *******************  ")
  println(" shutting down job")
  println(" *******************  ")
  println("  ")
  System.exit(0)
}
