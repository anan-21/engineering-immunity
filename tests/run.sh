#!/bin/sh
set -eu

test_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

"$test_dir/test-project-isolation.sh"
"$test_dir/test-global-storage.sh"

echo "all tests passed"
