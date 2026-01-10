#!/usr/bin/env bash
FILE_PATH=$1
shift     # Remove the file path from the list of arguments
ARGS="$@" # Capture any additional arguments

BUILD_ONLY=false
TEST_PROJECT=false
REPL=false
RED='\033[0;31m'

for arg in "$@"; do
    case $arg in
    --build | -b)
        BUILD_ONLY=true
        shift
        ;;
    --test | -t)
        TEST_PROJECT=true
        shift
        ;;
    --repl | -r)
        REPL=true
        shift
        ;;
    esac
done

# Ensure a file path is provided
if [[ -z "$FILE_PATH" ]]; then
    echo "Usage: $0 <source_file> [program arguments if any] [--build-only(optional)]"
    exit 1
fi

EXT="${FILE_PATH##*.}"
FILE_NAME=$(basename "$FILE_PATH" ."$EXT")

case "$EXT" in
c)
    echo "Compiling ${FILE_NAME}.c..."
    echo ""
    # Ensure 'bin' directory exists for compiled binaries
    mkdir -p "bin"
    gcc -Wall -Wextra -lm "$FILE_PATH" -o "bin/${FILE_NAME}"
    if [[ $? -ne 0 ]]; then
        echo "Compilation failed."
        exit 1
    fi
    echo "Running bin/${FILE_NAME}..."
    echo ""
    ./bin/${FILE_NAME} $ARGS
    ;;
go)
    if $TEST_PROJECT; then
        echo "Running tests..."
        echo ""
        go test ./...
    else
        echo "Compiling ${FILE_NAME}.go..."
        echo ""
        # Ensure 'bin' directory exists for compiled binaries
        mkdir -p "bin"
        go build -o "bin/${FILE_NAME}" "$FILE_PATH"
        if [[ $? -ne 0 ]]; then
            echo "Compilation failed."
            exit 1
        fi
        if $BUILD_ONLY; then
            echo "Binary compiled at bin/${FILE_NAME}"
        else
            echo "Running bin/${FILE_NAME}..."
            ./bin/${FILE_NAME} $ARGS
        fi
    fi
    ;;
rs)
    echo "Running ${FILE_NAME}.rs with rustc..."
    echo ""
    mkdir -p "target"
    rustc "$FILE_PATH" -o ./target/$FILE_NAME
    ./target/${FILE_NAME} $ARGS
    ;;
exs | ex)
    if $TEST_PROJECT; then
        if [[ "$EXT" == "exs" ]] && [[ "$FILE_NAME" == "mix" ]] || [[ "$EXT" == "ex" ]] || [[ "$FILE_NAME" == *"_test"* ]]; then
            mix test
        else
            echo -e "${RED}[ERROR] cannot run test on non-mix projects dir"
            exit -1
        fi
    elif $REPL; then
        if [[ "$EXT" == "exs" ]] && [[ "$FILE_NAME" != "mix" ]]; then
            echo "Running app with iex..."
            echo ""
            iex
        else
            echo "Running app with iex..."
            echo ""
            iex -S mix
        fi
    else
        if [[ "$EXT" == "exs" ]] && [[ "$FILE_NAME" != "mix" ]]; then
            echo "Running ${FILE_NAME}.exs with Elixir..."
            echo ""
            elixir "$FILE_PATH" $ARGS
        else
            if $BUILD_ONLY; then
                echo "Compiling mix project..."
                echo ""
                mix compile

            else
                echo "Running mix project..."
                echo ""
                mix run
            fi
        fi

    fi
    ;;
sh)
    echo "Running ${FILE_NAME}.sh script...."
    echo ""
    bash $FILE_PATH
    ;;
html)
    echo "starting http server..."
    echo ""
    http-server --port 5173
    ;;
*)
    echo "Unsupported file type: .$EXT"
    exit 1
    ;;
esac

exit 0
