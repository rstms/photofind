#!/usr/bin/env python

import click
import os
import sys

@click.command()

@click.option('-r', '--recurse', is_flag=True, default=False, help='process subdirectories')
@click.option('-e', '--extensions', default='jpg,jpeg', help='comma delimited list of filename extensions')
@click.argument('directory', type=click.Path(exists=True, file_okay=False), default='.')
#, help='directory to scan for image files')


def cli(directory, recurse, extensions):
    files = read_directory(directory, extensions, recurse, [])
    for f in files:
        write(f)

def write(output):
    sys.stdout.write(output+'\n') # ).encode('utf-8'))
    sys.stdout.flush()

def filter_filename(f, extensions):
    extension = f[f.rindex('.')+1:].lower() if '.' in f else ''
    return extension in extensions

def read_directory(directory, extensions, recurse, result):
    #print('read_directory%s' % repr((directory, extensions, recurse, result)))
    for name, dirs, files in os.walk(directory):
        #print('name: %s' % repr(name))
        for f in files:
            #print('file: %s' % repr(f))
            if filter_filename(f, extensions):
                result.append(os.path.join(name, f))
        if not recurse:
            break
    return result
