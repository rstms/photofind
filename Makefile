# python package makefile

PROJECT:=photofind

# prefer python3
PYTHON:=python3

.PHONY: help tools test install uninstall dist publish

help: 
	@echo "make tools|test|install|uninstall|dist|publish"

tools: 
	${PYTHON} -m pip install --user --upgrade setuptools wheel twine

TPARM :=

tests/exif-samples: 
	@echo "Git Cloning test data..."
	cd tests && git clone https://github.com/ianare/exif-samples.git

test: tests/exif-samples
	@echo "Testing..."
	pytest -vvx --no-print-logs $(TPARM)

install:
	@echo Installing ${PROJECT} locally
	${PYTHON} -m pip install --user --upgrade --editable .

uninstall: 
	@echo Uninstalling ${PROJECT} locally
	${PYTHON} -m pip uninstall -y ${PROJECT} 

clean:
	@echo Cleaning up...
	rm -rf build dist *.egg-info src/$(PROJECT)/*.pyc src/$(PROJECT)/__pycache__ .pytest_cache .tox tests/exif-samples

dist:
	@echo building ${PROJECT}
	scripts/bumpbuild src/${PROJECT}/version.py >VERSION
	${PYTHON} setup.py sdist bdist_wheel

publish: dist
	@echo publishing ${PROJECT} to PyPI
	${PYTHON} -m twine upload dist/*
