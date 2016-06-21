#!/usr/bin/python

import boto3
import botocore

my_bucket= 'bucket1_ragna_boto3_com'
my_file= './boto3_sample.csv'
s3_file_key='boto3_sample.csv'
location='us-west-2'




def lookup_or_create_bucket(my_bucket):
    def exists_bucket():
        s3 = boto3.resource('s3')

        bucket = s3.Bucket(my_bucket)
        exists = True

        try:
            s3.meta.client.head_bucket(Bucket=my_bucket)
        except botocore.exceptions.ClientError as e:
            error_code = int(e.response['Error']['Code'])
            if error_code == 404:
                exists = False

        return exists

    bucket = exists_bucket()
    if bucket:
        return bucket
    s3 = boto3.resource('s3')
    s3.create_bucket(Bucket=my_bucket, CreateBucketConfiguration={'LocationConstraint': location})
    return True

def put_file(my_bucket, s3_key, filename):
    bucket = lookup_or_create_bucket(my_bucket)
    print "bucket", bucket, "my_bucket", my_bucket, "s3_key", s3_key, "filename", filename

    s3 = boto3.resource('s3')
    region_name = s3.get_bucket_location(Bucket=my_bucket)['LocationConstraint']
    region_name = boto3.client('s3', region_name=region_name)
    s3.Object(my_bucket, s3_key).put(Body=open(filename, 'rb'))


def main():
    print "puting"
    put_file(my_bucket, s3_file_key, my_file)
    print "ok"

if __name__ == "__main__":
    main()

