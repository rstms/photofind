# python package makefile

PROJECT:=photofind

# prefer python3
PYTHON:=python3

# find all python sources (used to bump version)
SOURCES:=$(shell find setup.py src tests -name '*.py')

# if VERSION=major or VERSION=minor specified, 
$(if ${VERSION}, $(shell rm VERSION))

.PHONY: help tools test install uninstall dist gitclean publish release clean 

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

gitclean: 
	$(if $(shell git status --porcelain), $(error "git status dirty, commit and push first"))

VERSION: ${SOURCES}
	scripts/bumpbuild >VERSION src/${PROJECT}/version.py ${VERSION}
	git commit -m "v`cat VERSION`" -a
	git push

dist: gitclean VERSION 
	@echo building ${PROJECT}
	${PYTHON} setup.py sdist bdist_wheel

publish: dist
	@echo publishing ${PROJECT} v`cat VERSION` to PyPI
	${PYTHON} -m twine upload dist/*

release: dist
	TAG="v`cat VERSION`"; git tag -a $$TAG -m "Release $$TAG"; git push origin $$TAG

clean:
	@echo Cleaning up...
	rm -rf build dist *.egg-info src/$(PROJECT)/*.pyc src/$(PROJECT)/__pycache__ .pytest_cache .tox tests/exif-samples
