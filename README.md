# :game_die: Slack Randomizer

This is a very, very simple "randomizer" [slash command][] for Slack.

[slash command]: https://api.slack.com/slash-commands 

Once it's integrated into your Slack team, you can do the following in any
channel or DM:

> **You:** /randomize one two three
>
> **Randomizer:** I choose… **three**

Not sure where to get lunch? Not sure who to request your next code review
from? Let the universe decide! :raised_hands:

## Setup

The command is designed to run as an [AWS Lambda][] function behind [API
Gateway][]. This repo includes a [CloudFormation][] template that automatically
sets everything up in AWS for you.

[AWS Lambda]: https://aws.amazon.com/lambda/
[API Gateway]: https://aws.amazon.com/api-gateway/
[CloudFormation]: https://aws.amazon.com/cloudformation/

Assuming you have an AWS account, the procedure is roughly as follows:

1. Install and configure the [AWS CLI][]. If you prefer to use an IAM user with
   limited permissions, ensure that it can do the following:
   - Deploy CloudFormation stacks
   - Create and manage API Gateway resources
   - Create and manage Lambda functions
   - Create and manage IAM roles
1. In the Slack App Directory, find the place where you can create new Slash
   Commands. For me, the link to that page is available at
   https://WORKSPACE.slack.com/apps/manage/custom-integrations (though
   obviously you should replace WORKSPACE with whatever that actually is for
   your Slack team). Click "Add Configuration" and decide on a reasonable
   command (I recommend `/randomize`).
1. On the configuration page, you'll find a "Token" section. Copy that token
   down.
1. In this repo, run `./deploy.sh -t [TOKEN]`, where `[TOKEN]` is the token
   from above.
1. When the script finishes, it will print out a URL. Copy it into the "URL"
   section on Slack's configuration page, then set the "Method" to GET.
   Continue to set other options as desired (icon, description, etc.), then
   save the integration.
   - Don't worry too much about escaping or ID translation options. They don't
     make much of a difference to this command.

[AWS CLI]: https://aws.amazon.com/cli/

### Updates

Just run `./deploy.sh` whenever the CloudFormation template is updated. The
token will automatically be remembered from your initial deployment.

## Commentary

This project started out as the first thing I ever built on AWS Lambda. The
CloudFormation template seen here just duplicates the set of resources I
manually created and linked up to make everything work.

If I were to rebuild this from scratch, I would strongly consider leveraging
[AWS SAM][]. It automatically handles some hairier details that took me a lot
of trial and error to get right (setting up API Gateway to hit Lambda, creating
the right IAM role and permissions for the function, etc.).

[AWS SAM]: https://github.com/awslabs/serverless-application-model
