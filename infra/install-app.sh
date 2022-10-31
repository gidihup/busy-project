#!/bin/bash
echo "Cloning the flask app repo"
git clone 

cd tech-challenge-flask-app
export TC_DYNAMO_TABLE=candidate-table
pip install -r requirements.txt
gunicorn -b 0.0.0.0 app:candidates_app