# Release new version
GIT_TARGET_BRANCH=main

GIT_VERSION=$(shell git tag --list | sort -V | tail -n 1)
GIT_NEXT_PATCH=$(shell echo $(GIT_VERSION) | awk -F. '{print $$1"."$$2"."$$3+1}')
GIT_NEXT_MINOR=$(shell echo $(GIT_VERSION) | awk -F. '{print $$1"."$$2+1".0"}')
GIT_NEXT_MAJOR=v$(shell echo $(GIT_VERSION) | awk -F. '{print $$1+1".0.0"}')

tag:
	@git tag $(version)

push:
	@git push origin $(GIT_TARGET_BRANCH) $(version)

release: tag push

# Bug fixes
patch:
	@make release version=${GIT_NEXT_PATCH}

# Minor changes: Does not break the API
minor:
	@make release version=${GIT_NEXT_MINOR}

# Major changes: Breaks the API
major:
	@make release version=${GIT_NEXT_MAJOR}

# Initialize the project
init:
	@make release version=v0.0.1

# deploy the project
deploy:
	@helm upgrade --install client deployment \
	--values deployment/values.yaml \
	-f deployment/secrets.yaml \
	-n next-client --create-namespace