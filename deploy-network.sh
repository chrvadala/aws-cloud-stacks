#!/bin/bash -e

STACK="${STACK:?env not found}"
BUCKET="${BUCKET:?env not found}"
REGION="${REGION:-us-east-1}"

echo "STACK=${STACK}"
echo "REGION=${REGION}"
echo "BUCKET=${BUCKET}"

TMP_TEMPLATE="/tmp/${STACK}-packed-nested-stacks.json"

set -ex

aws cloudformation package \
  --template-file "./stacks/network.yaml" \
  --output-template "$TMP_TEMPLATE" \
  --s3-bucket "$BUCKET" \
  --region "$REGION"

aws cloudformation deploy \
  --template-file "$TMP_TEMPLATE" \
  --stack-name "$STACK" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "file://./${STACK}.json"
