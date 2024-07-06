#!/bin/bash

set -e

APPNAME=$1
ENVIRONMENT=$2
HOSTED_ZONE=$3
AWS_PROFILE=$4

function error {
  echo $1
  echo
  usage
  exit 255
}

function usage {
  echo "************************************************************"
  echo "* get_acm_certificate.sh                                   *"
  echo "*                                                          *"
  echo "* Looks up an ACM certificate by its domain and 'Name' tag *"
  echo "************************************************************"
  echo
  echo "./get_acm_certificate.sh [APPNAME] [ENVIRONMENT] [HOSTED_ZONE] [AWS_PROFILE]"
  echo
  echo "Example: ./get_acm_certificate.sh testapp dev example.com myprofile"
}

if [ -z "$APPNAME" ]; then
  error "APPNAME argument required"
fi

if [ -z "$ENVIRONMENT" ]; then
  error "ENVIRONMENT argument required"
fi

if [ -z "$HOSTED_ZONE" ]; then
  error "HOSTED_ZONE argument required"
fi

if [ -z "$AWS_PROFILE" ]; then
  AWS_PROFILE=default
fi

COMMON_NAME="${APPNAME}-${ENVIRONMENT}.${HOSTED_ZONE}"

ARNS=$(aws acm list-certificates --profile ${AWS_PROFILE} \
    | jq -c --arg COMMON_NAME "$COMMON_NAME" '.CertificateSummaryList[] | select( .DomainName  == $COMMON_NAME)' \
    | jq -c -r .CertificateArn)

if [ -z "$ARNS" ]; then
  error "Unable to locate certificate for ${COMMON_NAME}"
fi

for ARN in $ARNS; do
  if [ -z "$ARN" ]; then
    continue
  fi
  TAG=$(aws acm list-tags-for-certificate --certificate-arn ${ARN} --profile ${AWS_PROFILE} | jq -r --arg COMMON_NAME "$COMMON_NAME" '.Tags[] | select( .Key == "Name" and .Value == $COMMON_NAME )')
  if [ "$TAG" != "" ]; then
     echo $ARN
     exit 0
  fi
done
