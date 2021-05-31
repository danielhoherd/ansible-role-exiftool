.DEFAULT_GOAL := help

.PHONY: help
help: ## Print Makefile help.
	@grep -hE '^[a-z0-9A-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: install-hooks
install-hooks: .install-hooks ## Install git hooks
.install-hooks: requirements
	pip3 install --user --upgrade pre-commit
	pre-commit install -f --install-hooks
	touch .install-hooks

.PHONY: test
test: requirements ## Run tests
	poetry run molecule test --all

.PHONY: test-xenial
test-xenial: requirements ## Run tests on xenial
	poetry run molecule test -s xenial

.PHONY: test-bionic
test-bionic: requirements ## Run tests on bionic
	poetry run molecule test -s bionic

.PHONY: test-bionic
test-focal: requirements ## Run tests on focal
	poetry run molecule test -s focal

.PHONY: requirements
requirements: .requirements ## Install software requirements
.requirements:
	pip3 install --user --upgrade "poetry>=1.1.2"
	poetry install
	touch .requirements

.PHONY: poetry-clean
clean: ## Destroy poetry virtual environment
	poetry env list 2>/dev/null | awk '{print $$1}' | xargs -n1 poetry env remove || true
	rm -f poetry.lock
	find $$PWD -name 'Image-ExifTool*.tar.gz' -delete
	rm -f .requirements .install-hooks
