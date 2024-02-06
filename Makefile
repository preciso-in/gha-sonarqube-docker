.PHONY:
	help
	run_super_linter_local
	git_log_oneline_with_timestamp
	
help:
	@echo "help - Show this help"
	@echo "run_super_linter_local - Run super linter locally using a docker container"
	@echo "git_log_oneline_with_timestamp - Show git log with oneline format and timestamp as table"

run_super_linter_local:
	@docker run \
		-e ACTIONS_RUNNER_DEBUG="true" \
		-e CREATE_LOG_FILE="true" \
		-e RUN_LOCAL=true \
		-e USE_FIND_ALGORITHM=true	\
		-v $$(pwd)/website:/tmp/lint github/super-linter --verbose

git_log_oneline_with_timestamp:
	@git log --pretty=format:"%h|%s|%cr" | column -t -s '|'    