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
  --env CHROME_HEADLESS=true \
  -it qa_tests \
  spec/bendo/functional/func_bendo_spec.rb
```
