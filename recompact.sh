#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-only
#
# Recompact fuzz corpora by merging with libfuzzer's -merge=1.
# This reduces the number of files while maintaining full code coverage.
#
# Usage: ./recompact.sh <barebox-build-dir>

set -e

if [ $# -ne 1 ]; then
	echo "Usage: $0 <barebox-build-dir>" >&2
	exit 1
fi

BAREBOX_DIR="$1"
BAREBOX="$BAREBOX_DIR/images/barebox"
CORPORA_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ ! -x "$BAREBOX" ]; then
	echo "Error: $BAREBOX not found or not executable" >&2
	echo "Build barebox with: export LLVM=1; make libfuzzer_defconfig && make -j\$(nproc)" >&2
	exit 1
fi

summary=()

for target in $("$BAREBOX" --list-fuzzers); do
	corpus="$CORPORA_DIR/$target"

	if [ -L "$corpus" ]; then
		echo "Skipping $target (symlink)"
		continue
	fi

	if [ ! -d "$corpus" ]; then
		echo "Skipping $target (no corpus directory)"
		continue
	fi

	before=$(find "$corpus" -maxdepth 1 -type f | wc -l)

	tmpdir=$(mktemp -d)
	trap "rm -rf '$tmpdir'" EXIT

	set -x
	"$BAREBOX_DIR/images/barebox" --command=poweroff --fuzz=$target -merge=1 "$tmpdir" "$corpus"
	set +x

	after=$(find "$tmpdir" -maxdepth 1 -type f | wc -l)

	if [ "$after" -eq 0 ]; then
		echo "Error: merge produced no files for $target, keeping original" >&2
		rm -rf "$tmpdir"
		trap - EXIT
		continue
	fi

	# mktemp -d creates the directory as 0700, but corpora are public
	chmod 755 "$tmpdir"

	rm -rf "$corpus"
	mv "$tmpdir" "$corpus"
	trap - EXIT

	summary+=("$target: $before -> $after files")
done

echo ======================== SUMMARY ========================
printf '%s\n' "${summary[@]}"
