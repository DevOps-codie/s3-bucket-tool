#!/usr/bin/env bash

if [[ -z $1 ]] || [[ -z $2 ]]; then
    echo "usage: $( basename $0 ) <BUCKET_NAME> <REGION> [--public]"
    exit 255
fi

BUCKET_NAME=$1
REGION=$2
BUCKET_CREATE="aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration"

if [ $REGION != "us-east-1" ]; then
  BUCKET_CREATE="$BUCKET_CREATE LocationConstraint=$REGION"
fi

$BUCKET_CREATE

for i in $@; do
  if [ $i == "--public" ]; then
    public=TRUE
  fi
done

if [ -z $public ]; then
  aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

fi

echo "BUCKET IS CREATED...THANK YOU LOCAL DEVOPS GUYS"

