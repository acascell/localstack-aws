#!/usr/bin/env bash

#echo "Creating required S3 bucket"
#awslocal s3api create-bucket --bucket images
#
#echo "Copying input test image to s3"
#awslocal s3 cp /resources/test_image.png s3://images/test_image.png

ZIP_FILE=/resources/lambda-layer.zip
if [ -f "$ZIP_FILE" ]; then
echo "$ZIP_FILE exists."

echo "Creating a simple lambda function getting an event and printing the body"
awslocal lambda create-function --function-name test-aws-local-stack_lambda \
    --zip-file fileb:///resources/lambda-layer.zip \
    --handler main.lambda_handler \
    --environment Variables="{$(cat < /resources/.env | xargs | sed 's/ /,/g')}" \
    --runtime python3.8 \
    --role whatever \
    --region us-east-1

echo "Creating required SQS queue"
awslocal sqs create-queue --queue-name test-aws-local-stack_queue --region us-east-1

echo "Binding Lambda to SQS queue"
awslocal lambda create-event-source-mapping --function-name test-aws-local-stack_lambda --batch-size 1 --event-source-arn arn:aws:sqs:us-east-1:000000000000:test-aws-local-stack_queue

echo "Trigger lambda by sending a message to the SQS"
awslocal sqs send-message --queue-url http://localhost:4566/000000000000/test-aws-local-stack_queue --message-body '{"Records": [{"body": "{\"test_message\":\"got it!\"}"}]}'

else
    echo "$ZIP_FILE does not exist ie. triggered directly via Python."
fi
