import json
import logging
import boto3
from os import environ


logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)  # Required by AWS
logging.basicConfig(level=logging.INFO)  # Required for local run

aws_endpoint_url = environ.get("AWS_ENDPOINT_URL")
s3_client = boto3.client("s3", region_name="us-east-1", endpoint_url=aws_endpoint_url)


def lambda_handler(event, context):
    print(event)
