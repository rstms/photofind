import pytest
from click.testing import CliRunner
from photofind import cli

def _cli(args, output):
    print('_cli%s' % repr((args, output)))
    runner = CliRunner()
    result = runner.invoke(cli, args, catch_exceptions=False)
    assert result.exit_code == 0
    assert result.output 
    olist = [o for o in result.output.split('\n') if o]
    print('results:\n%s' % repr(olist))
    assert sorted(olist) == sorted(output)

def test_cli():
    _cli(['tests/data'], ['tests/data/test.jpg','tests/data/test.jpeg'])

def test_types():
    _cli(['tests/data', '-e', 'png'], ['tests/data/test.png'])

def test_recurse():
    _cli(['tests/data', '-r'], ['tests/data/test.jpg', 'tests/data/test.jpeg', 'tests/data/sub/1.jpg', 'tests/data/sub/2.jpg'])
