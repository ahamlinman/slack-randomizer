#!/usr/bin/env bash

set -euo pipefail

usage () {
  if [ -z ${1+x} ]; then
    cat <<EOF
Deploy the Slack Randomizer into your AWS account.

The AWS CLI must be installed and configured to use this script. For details
about configuration, see the AWS Documentation:

https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
EOF
  else
    echo -e "$1"
  fi

  cat <<EOF

Usage:
  ./deploy.sh [flags]

Flags:
  -n string   The name of the CloudFormation stack to create or update
              (default: SlackRandomizer)

  -t string   The token created by Slack for the slash command integration
              (required when creating stack, optional when updating)

  -h          Display usage information

EOF

  exit "$([ -z ${1+x} ]; echo $?)"
}

while getopts ":hn:t:" opt; do
  case $opt in
    h)
      usage
      ;;
    n)
      STACK_NAME=$OPTARG
      ;;
    t)
      SLACK_TOKEN=$OPTARG
      ;;
    \?)
      usage "Error: -$OPTARG is not a valid flag"
      ;;
    :)
      usage "Error: -$OPTARG requires an argument"
      ;;
  esac
done
shift $((OPTIND -1))

STACK_NAME="${STACK_NAME:-SlackRandomizer}"

if [ -z ${SLACK_TOKEN+x} ]; then
  PARAM_FLAGS=()
else
  PARAM_FLAGS=("--parameter-overrides" "SlackToken=$SLACK_TOKEN")
fi

cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null

(
set -x
aws cloudformation deploy \
  --template-file SlackRandomizer.yaml \
  --stack-name "$STACK_NAME" \
  --capabilities CAPABILITY_IAM \
  --no-fail-on-empty-changeset \
  "${PARAM_FLAGS[@]}"
)

echo -e "\\nThe Slack webhook is available at the following URL:"
aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --output text \
  --query 'Stacks[0].Outputs[0].OutputValue'
