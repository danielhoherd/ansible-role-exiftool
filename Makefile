.DEFAULT_GOAL := help

.PHONY: help
help: ## Print Makefile help.
	@grep -hE '^[a-z0-9A-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[1;36m%-18s\033[0m %s\n", $$1, $$2}'

.PHONY: install-hooks
install-hooks: .install-hooks ## Install git hooks
.install-hooks: requirements
	pip3 install --user --upgrade pre-commit
	pre-commit install -f --install-hooks
	touch .install-hooks

.PHONY: test
test: requirements ## Run tests
	poetry run molecule test --all

.PHONY: test-debian-12
test-debian-12: requirements ## Run tests on debian-12
	poetry run molecule test --platform-name=debian-12

.PHONY: test-ubuntu-20-04
test-ubuntu-20-04: requirements ## Run tests on ubuntu-20-04
	poetry run molecule test --platform-name=ubuntu-20-04

.PHONY: test-ubuntu-22-04
test-ubuntu-22-04: requirements ## Run tests on ubuntu-22-04
	poetry run molecule test --platform-name=ubuntu-22-04

.PHONY: requirements
requirements: .requirements ## Install software requirements
.requirements:
	pip3 install --user --upgrade "poetry>=1.3.2"
	poetry install
	touch .requirements

.PHONY: clean
clean: ## Destroy poetry virtual environment and remove downloaded files
	poetry env list 2>/dev/null | awk '{print $$1}' | xargs -r -n1 poetry env remove || true
	rm -f poetry.lock
	find $$PWD -name 'Image-ExifTool*.tar.gz' -delete
	rm -f .requirements .install-hooks
