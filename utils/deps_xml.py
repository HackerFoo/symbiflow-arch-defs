#!/usr/bin/env python3
"""
Generate a Makefile .d fragment for the XML includes.
"""

import argparse
import os
import re
import sys

from io import StringIO

from lib.deps import deps_all
from lib.deps import deps_file
from lib.deps import write_deps


parser = argparse.ArgumentParser()
parser.add_argument(
    "inputfile",
    type=argparse.FileType('r'),
    help="Input XML file")


xi_include = re.compile('<xi:include[^>]*href="([^"]*)"', re.IGNORECASE)


def main(argv):
    args = parser.parse_args(argv[1:])

    inputpath = os.path.abspath(args.inputfile.name)
    inputdir = os.path.dirname(inputpath)

    data = StringIO()
    for line in args.inputfile:
        line = line.strip()
        if 'xi:include' not in line:
            continue

        for includefile in xi_include.findall(line):
            includefile_path = os.path.abspath(os.path.join(inputdir, includefile))

            data.write("{inputfile_deps}: {includefile_all}\n".format(
#                inputfile_deps=deps_file(inputpath),
                inputfile_deps=inputpath,
                includefile_all=deps_all(includefile_path),
            ))

    write_deps(args.inputfile.name, data)


if __name__ == "__main__":
    sys.exit(main(sys.argv))
