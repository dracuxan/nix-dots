#!/usr/bin/env bash

includes=$(
    clang -E -x c - -v </dev/null 2>&1 |
        awk '/#include <...> search starts here:/{flag=1;next}/End of search list./{flag=0}flag' |
        grep '^ /nix' |
        awk '{print "-I" $1}'
)

if [ -z "$includes" ]; then
    echo "❌ No include paths found. Check if clang is installed or nix-shell has proper dev tools."
    exit 1
fi

cat >.clangd <<EOF
CompileFlags:
  Add:
$(echo "$includes" | sed 's/^/    - "/;s/$/"/')
EOF

echo ".clangd generated successfully!"
