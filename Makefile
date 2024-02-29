.PHONY: help
help:
	@echo "\nstart_super_linter_docker - Run super linter locally using a docker container"
	@echo "\ngit_log_oneline_with_timestamp - Show git log with oneline format and timestamp as table"
	@echo "\ngit_update_remote_branches - Update deleted remote branches on local machine. git branch -a will not show remote branches that have been deleted"
	@echo "\nssh_gcloud_shell - SSH into Google Cloud Shell"
	@echo "\nselect_gcloud_project - Select gcloud project here if not already selected"
	@echo "\nstart_act_runner - Execute nektos act runner on GCP Cloud shell if local machine is Mac M1. Else run on local machine"
	@echo "\nopen_github_repo_url - Open github repo url in default browser"
	@echo "\nempty_commit - Create an empty commit with message 'Empty commit'"

.PHONY: start_super_linter_docker
start_super_linter_docker:
	@docker run \
		-e CREATE_LOG_FILE="true" \
		-e RUN_LOCAL=true \
		--env-file ".github/super-linter.env" \
		-v $$(pwd)/website:/tmp/lint github/super-linter:slim-v5.0.0 

.PHONY: git_log_oneline_with_timestamp
git_log_oneline_with_timestamp:
	@git log --pretty=format:"%h|%s|%cr" | column -t -s '|'

.PHONY: git_update_remote_branches
git_update_remote_branches:
	@git fetch -p origin

.PHONY: ssh_gcloud_shell
ssh_gcloud_shell:
	@gcloud cloud-shell ssh

.PHONY: select_gcloud_project
select_gcloud_project:
	@gcloud init

.PHONY: start_act_runner
start_act_runner:
	@echo "Runs on GCP Cloud Shell if local machine is Mac M1."
	@sh scripts/act-runner.sh

.PHONY: open_github_repo_url
open_github_repo_url:
	@open -a "Google Chrome" "https://github.com/preciso-in/gha-sonarqube-docker"

.PHONY: empty_commit
empty_commit:
	@echo "This command will fail. Edit it to add story id 'GASD' in commit message"
	git commit --allow-empty -m "WIP Empty commit to trigger GH Action"