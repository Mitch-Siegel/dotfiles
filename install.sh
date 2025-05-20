#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

function info()    { echo -e "${CYAN}$*${RESET}"; }
function warn()    { echo -e "${YELLOW}$*${RESET}"; }
function warn_no_nl()    { echo -ne "${YELLOW}$*${RESET}"; }
function error()   { echo -e "${RED}$*${RESET}" >&2; }
function success() { echo -e "${GREEN}$*${RESET}"; }

REPO_ROOT="$(pwd)/root"

if [ ! -d "$REPO_ROOT" ]; then
	error "Error: 'root/' directory not present in the current working directory" >&2
	exit 1
fi

if [ $# -ne 1 ]; then
	error "Usage: $0 <regex_pattern>" >&2
	exit 1
fi

REGEX="$1"

info "Searching for paths in '$REPO_ROOT' matching regular expression: '$REGEX'"
MATCHED_PATHS=$(find "$REPO_ROOT" -type f | grep -E "$REGEX" || true)

if [ -z "$MATCHED_PATHS" ]; then
	error "No matches found."
	exit 0
fi

success "Matched paths:"
echo "$MATCHED_PATHS" | sed "s|$REPO_ROOT||"

echo
warn_no_nl "Symlink all these paths to point to the dotfiles repo? [y/N]: "
read CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
	error "Aborted."
	exit 0
fi

echo
echo "Creating symlinks..."

function create_link() {
	if [ $# -ne 3 ]; then
		error "Bad arguments passed to create_link: expected 3, got $#"
		return 1
	fi

	SOURCE_PATH=$1
	TARGET_PATH=$2
	FORCE=$3

	set +e
	if $FORCE ; then
		ln -sf "$SOURCE_PATH" "$TARGET_PATH"
	else
		ln -s "$SOURCE_PATH" "$TARGET_PATH"
	fi
	set -e

	LINK_RESULT=$?
	if [ $LINK_RESULT -ne 0 ]; then
		error "Failed to link $TARGET_PATH -> $SOURCE_PATH: ln exit status $LINK_RESULT"
	else
		success "Linked $TARGET_PATH -> $SOURCE_PATH"
		#ls --color=auto -l "$TARGET_PATH"
	fi
	return $LINK_RESULT
}


while IFS= read -r SOURCE_PATH; do
	RELATIVE_PATH="${SOURCE_PATH#$REPO_ROOT}"
	TARGET_PATH="/$RELATIVE_PATH"

	PARENT_DIR=$(dirname "$TARGET_PATH")
	mkdir -p "$PARENT_DIR"
	
	if [ ! -f "$TARGET_PATH" ]; then
		create_link "$SOURCE_PATH" "$TARGET_PATH" false
	else
		warn_no_nl "$TARGET_PATH exists - overwrite? [y/N]: "
		read CONFIRM < /dev/tty
		if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
			warn "Skipped $TARGET_PATH"	
		else
			create_link "$SOURCE_PATH" "$TARGET_PATH" true
		fi
	fi
done <<< "$MATCHED_PATHS"

echo
success "Done."

