import pytest
import sys
from click.testing import CliRunner
from photofind import cli

def _cli(args, output):
    print('_cli%s' % repr((args, output)))
    runner = CliRunner()
    result = runner.invoke(cli, args, catch_exceptions=False)
    assert result.exit_code == 0
    olist = [o for o in result.output.split('\n') if o]
    print('results:\n%s' % repr(olist))
    assert sorted(olist) == sorted(output)

def test_cli():
    _cli(['tests/data', '-n', '-c'], ['tests/data/test.jpg','tests/data/test.jpeg'])

def test_types():
    _cli(['tests/data', '-n', '-c', '-f', '.+\\.png$'], ['tests/data/test.png'])

def test_recurse():
    _cli(['tests/data', '-n', '-c', '-r'], ['tests/data/test.jpg', 'tests/data/test.jpeg', 'tests/data/sub/1.jpg', 'tests/data/sub/2.jpg'])

def test_gps():
    if sys.version_info[0] < 3:
        print('test_gps case requires python3')
    else:
        _cli(['tests/exif-samples', '-r', '--distance', '1,1,1'], [])
