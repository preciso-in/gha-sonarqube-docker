.PHONY:
	help
	run_super_linter_local
	git_log_oneline_with_timestamp
	git_update_remote_branches
	
help:
	@echo "\nrun_super_linter_local - Run super linter locally using a docker container"
	@echo "\ngit_log_oneline_with_timestamp - Show git log with oneline format and timestamp as table"
	@echo "\ngit_update_remote_branches - Update deleted remote branches on local machine. git branch -a will not show remote branches that have been deleted"

run_super_linter_local:
	@docker run \
		-e ACTIONS_RUNNER_DEBUG="true" \
		-e CREATE_LOG_FILE="true" \
		-e RUN_LOCAL=true \
		-e USE_FIND_ALGORITHM=true	\
		-v $$(pwd)/website:/tmp/lint github/super-linter --verbose

git_log_oneline_with_timestamp:
	@git log --pretty=format:"%h|%s|%cr" | column -t -s '|'    

git_update_remote_branches:
	@git fetch -p origin