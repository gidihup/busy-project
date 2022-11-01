#!/bin/bash
sudo yum update -y
sudo yum install -y git pip

# Clone the app repo
git clone https://$GITHUB_TOKEN@github.com/uturndata/tech-challenge-flask-app.git

# Run the app
cd tech-challenge-flask-app
export TC_DYNAMO_TABLE=candidate-table
pip3 install -r requirements.txt
gunicorn -b 0.0.0.0:8080 app:candidates_app