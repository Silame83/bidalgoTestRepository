#!/usr/bin/python

import pymysql

# Open database connection

db = pymysql.connect(host="localhost",user="root",password="Silame83@gmail.com",db="bidalgo")

# prepare a cursor object using cursor() method
cursor = db.cursor()

# Add new column into table.
cursor.execute("CREATE TABLE commits (commit_id VARCHAR(50), commit_time VARCHAR(50), commit_message VARCHAR(50), commit_user VARCHAR(50))")
cursor.execute("ALTER TABLE commits ADD COLUMN commit_test VARCHAR(50)")

# Commit your changes in the database
db.commit()

# disconnect from server
db.close()