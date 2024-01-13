# We'll use this python interpreter only to create the virtual environment.
ORIGINAL_PYTHON_PATH ?= python3
VENV_ACTIVATE = venv/bin/activate

.PHONY: ensure_scripts_are_executable
ensure_scripts_are_executable:
	chmod 554 ./scripts/*

.PHONY: ensure_venv_exists_with_dependencies
ensure_venv_exists_with_dependencies: ensure_scripts_are_executable
	stat ./venv &> /dev/null || ( \
		$(ORIGINAL_PYTHON_PATH) -m venv ./venv \
		&& VENV_ACTIVATE=$(VENV_ACTIVATE) ./scripts/activate-venv-then.sh pip install --upgrade pip \
	)
	VENV_ACTIVATE=$(VENV_ACTIVATE) ./scripts/activate-venv-then.sh python --version
	VENV_ACTIVATE=$(VENV_ACTIVATE) ./scripts/activate-venv-then.sh pip install \
		pyright pandas

.PHONY: set-up
set-up: ensure_venv_exists_with_dependencies

.PHONY: clean
clean:
	rm -rf venv/
