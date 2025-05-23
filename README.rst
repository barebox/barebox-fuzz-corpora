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


Fit
===

The FIT directory includes some inputs to seed the fuzzer for fitimage testing:

.. code-block:: bash
        fit/fit-image-null.bin
        fit/fit-image-only-dtb.bin
        fit/fit-image-sign.bin

The fitimages are multiple iterations of the same ``*.its`` file including (or excluding)
different images or configurations. The ``fit-image-null.bin`` has ``/dev/null`` as data
for kernel and fdt. And the ``fit-image-only-dtb.bin`` has the binary devictree of the
sanbox.dts as data. Both files, with the respective changes to the ``*.its``, are generated
with the command:

.. code-block:: bash
        mkimage -f sandbox.its fit/fit-image-sign.bin

The ``fit-image-sign.bin`` includes signing keys to test the full signed fitimage chain.
It is generated with:

.. code-block:: bash
        mkimage -r -G fit-4096-development.key -f sandbox.its fit/fit-image-sign.bin
