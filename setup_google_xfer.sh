#!/bin/bash

export GOOGLE_APPLICATION_CREDENTIALS="/root/MY-GOOGLE-KEYFILE.json"

gcloud auth activate-service-account --key-file /root/MY-GOOGLE-KEY-FILE.json
