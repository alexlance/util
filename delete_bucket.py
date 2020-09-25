#!/usr/bin/env python3
import boto3
import sys

# This will delete a bucket and all the versions of all the files
# inside the bucket. It is permanent and dangerous!

b = sys.argv[1]

print("Bucket: {}".format(b))

session = boto3.Session()
s3 = session.resource(service_name='s3')
bucket = s3.Bucket(b)
bucket.object_versions.delete()
bucket.delete()
