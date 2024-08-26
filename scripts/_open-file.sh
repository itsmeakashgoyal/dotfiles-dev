#!/usr/bin/env bash

# The set -e option instructs bash to immediately exit if any command has a non-zero exit status
# The set -u referencing a previously undefined variable - with the exceptions of $* and $@ - is an error
# The set -o pipefaile if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline
# https://bit.ly/37nFgin
set -o pipefail

help_function() {
	echo "Usage: _open_file.sh [query] [-h|--help]"
	echo ""
	echo "This script opens files using fzf-tmux for selection and the configured editor (default: nvim) for viewing."
	echo "It allows multi-selection and opens the selected files in different layouts depending on the number of files selected."
	echo "An optional query can be provided to filter the file selection."
	echo ""
	echo "Options:"
	echo "  -h, --help    Show this help message and exit."
	echo ""
	echo "Arguments:"
	echo "  [query]       Optional query to filter the file selection."
	echo ""
	echo "Features:"
	echo "  - Sources a generic error handling function from _trap.sh."
	echo "  - Filters files using fzf-tmux with an optional query."
	echo "  - Opens selected files in the configured editor (default: nvim) with different layouts."
	echo "  - Handles interruptions and errors gracefully."
	echo ""
	echo "Note: This script requires fzf-tmux and a compatible editor (e.g., nvim)."
}

# Check for help argument
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
	help_function
	exit 0
fi

# Custom error handling function for fzf-tmux
handle_fzf_error() {
	if [ $? -eq 130 ]; then
		# If fzf-tmux was interrupted by Ctrl+C (exit code 130), exit gracefully
		exit 0
	else
		# Otherwise, re-raise the error
		return $?
	fi
}

# Set new line and tab for word splitting
IFS=$'\n' files=($(fzf-tmux --preview '[[ -d {} ]] && exa --color=always --long --all --header --icons --git {} || bat --color=always {}' --reverse --query="$1" --multi --select-1 --exit-0))

# Check if any files were selected, and exit if not
if [ ${#files[@]} -eq 0 ]; then
	exit 0
fi

for i in "${!files[@]}"; do
	files[i]=$(realpath "${files[i]}")
done

case "${#files[@]}" in
2)
	${EDITOR:-nvim} -O +'silent! normal g;' "${files[@]}"
	;;
3)
	${EDITOR:-nvim} -O "${files[0]}" -c 'wincmd j' -c "silent! vsplit ${files[1]}" -c "silent! split ${files[2]}"
	;;
4)
	${EDITOR:-nvim} -O "${files[0]}" -c "silent! vsplit ${files[1]}" -c "silent! split ${files[2]}" -c 'wincmd h' -c "silent! split ${files[3]}"
	;;
*)
	${EDITOR:-nvim} "${files[@]}"
	;;
esac
