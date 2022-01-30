#!/bin/bash -ex

STACK="${STACK:?env not found}"
BUCKET="${BUCKET:?env not found}"
REGION="${REGION:-us-east-1}"

TMP_TEMPLATE="/tmp/${STACK}-packed-nested-stacks.json"
S3_TEMPLATE="s3://${BUCKET}/simple-server/simple-server.yml"
PARAMETERS="file://./${STACK}.json"

aws cloudformation package \
  --template-file "./stacks/simple-server.yaml" \
  --s3-prefix "simple-server/nested" \
  --output-template "$TMP_TEMPLATE" \
  --s3-bucket "$BUCKET" \
  --region "$REGION"

 aws s3 cp "$TMP_TEMPLATE" "$S3_TEMPLATE"

 aws cloudformation deploy \
  --template-file "$TMP_TEMPLATE" \
  --stack-name "$STACK" \
  --parameter-overrides "$PARAMETERS"
