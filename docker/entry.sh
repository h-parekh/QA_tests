echo Mapping SSM path "$ENV_SSM_PATH" to my environment.
echo Running tests with the following arguments: "$@"
exec chamber exec "$ENV_SSM_PATH" -- bundle exec ruby -wU bin/run_tests $@
