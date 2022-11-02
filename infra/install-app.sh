#!/bin/bash

export APP_BUCKET="wordpress-media-store"
export APP_FOLDER="tech-challenge-flask-app"

# Install utilities
sudo yum update -y
sudo yum install -y git pip

# Download app files from S3
aws s3 cp s3://$APP_BUCKET/$APP_FOLDER . --recursive

# Run the app
cd $APP_FOLDER
export TC_DYNAMO_TABLE=candidate-table
pip3 install -r requirements.txt
gunicorn -b 0.0.0.0:8080 app:candidates_app