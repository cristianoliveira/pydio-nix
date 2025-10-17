REPO ?= pydio/cells
TAG ?= v4.4.15
BRANCH ?= v5-dev

.PHONY: update-tag update-branch

update-tag:
	@./scripts/update-cells-tag.sh $(REPO) $(TAG)

update-branch:
	@./scripts/update-cells-branch.sh $(REPO) $(BRANCH)
