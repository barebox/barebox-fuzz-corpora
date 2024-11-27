..
  SPDX-License-Identifier: GPL-2.0-only

This repository stores corpora to be used while fuzzing barebox' parsers.

Each fuzz test has its own corpus directory named after it.

Contributing
------------

The repository can be forked on `Github <https://github.com/barebox/barebox-fuzz-corpora>`

To extend a corpus, submit a pull-request adding files into the relevant
directory, but without touching existing files.

Merge of the corpora will be done at the maintainers' side.

All input files must be licensed under the terms of the GNU GPL 2.0.

License
-------

These corpora are available and distributable under the same terms of barebox
itself; the GNU General Public License, version 2, as published by the Free
Software Foundation and reproduced in the COPYING file in this repository.
