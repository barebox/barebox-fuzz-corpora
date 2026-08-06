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

Recompacting
------------

Contributions only ever add files, so the corpora accumulate inputs that no
longer reach anything the rest of the corpus does not already reach.
``recompact.sh`` shrinks them again by merging each corpus with libfuzzer's
``-merge=1``, which keeps only the inputs that contribute new features, so
the coverage of the corpus as a whole is preserved.

This rewrites and deletes existing files and is thus a maintainer task.

The script needs a barebox built with libfuzzer, as described in the
`fuzzing documentation
<https://www.barebox.org/doc/latest/devel/fuzzing.html>`_::

  $ export LLVM=1 # or e.g. LLVM=-19, if clang is called clang-19
  $ make libfuzzer_defconfig
  $ make -j$(nproc)

Point the script at that build directory. It replaces the corpus directories
in place and prints a summary::

  $ ./recompact.sh /path/to/barebox/build
  [snip]
  ======================== SUMMARY ========================
  dtb: 282 -> 111 files
  fit: 1535 -> 654 files
  [snip]

Only the fuzzers the build actually contains are recompacted, and which ones
those are depends on the configuration. A corpus whose fuzzer is missing from
the build is silently left untouched, so use a build with all of them enabled,
as ``libfuzzer_defconfig`` provides. ``images/barebox --list-fuzzers`` prints
the fuzzers of a given build. Corpora that are symlinks, such as
``fdt-compatible``, are skipped and share the corpus they point at.

The merge is greedy and depends on the order the inputs are visited, so a
second run may still shave off a few more files.

License
-------

These corpora are available and distributable under the same terms of barebox
itself; the GNU General Public License, version 2, as published by the Free
Software Foundation and reproduced in the COPYING file in this repository.
