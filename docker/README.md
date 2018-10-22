# Build
dockerbuild . -f docker/Dockerfile -t qa_tests

# Running in development
To run this locally, from the root directory:
```bash
docker build . -f docker/Dockerfile -t qa_tests
docker run \
  --env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  --env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --env AWS_SECURITY_TOKEN=$AWS_SECURITY_TOKEN \
  --env AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
  --env AWS_REGION=$AWS_REGION \
  --env ENV_SSM_PATH=all/qa/ecs-task-env/prod \
  --env ENVIRONMENT=prod \
  --env RUNNING_ON_LOCAL_DEV=true \
  --env USE_SAUCE_GRID=true \
  --env PLATFORM='Windows 10' \
  --env BROWSER_NAME='Internet Explorer' \
  --env BROWSER_VERSION='11.0' \
  -it qa_tests \
  spec/curate/functional/func_curate_spec.rb:6
```

## Current SSM expectations:

| Path | Description | Example Create |
|----|-----------|------ |
| $ENV_SSM_PATH/sauce-user | The user name to use when submitting requests to Saucelabs | ```aws ssm put-parameter --name /all/qa/ecs-task-env/prod/sauce-user --type SecureString --overwrite --value saucey-user``` |
| $ENV_SSM_PATH/sauce-pass | The password to use when submitting requests to Saucelabs | ```aws ssm put-parameter --name /all/qa/ecs-task-env/prod/sauce-pass --type SecureString --overwrite --value saucey-password``` |

## Desired capabilities
You can override default platform configurations by passing them as environment variables. Refer Sauce Labs [platform configurator](https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/) to determine allowed values.

| Variable Name      | Type  | Default |
|--------------------|-------|---------|
| PLATFORM           |String | `Windows 10` |
| BROWSER_NAME       |String | `Chrome`     |
| BROWSER_VERSION    |String | `70.0` |
| RECORD_VIDEO       |Boolean| `true` |
| RECORD_SCREENSHOTS |Boolean| `true` |
| SCREEN_RESOLUTION  |String |`1024x768` |
