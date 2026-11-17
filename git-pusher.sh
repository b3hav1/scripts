#!/bin/bash

if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
    cat << EOF
Usage:
    push <message>
    push <options> [message]

Options:
    -f, --force  Push force with lease
    -h, --help   Show this help message
EOF
    exit 0
fi

if ! command -v git &>/dev/null; then
    echo "Error: git is not installed"
    exit 1
fi

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: Not a Git repository"
    exit 1
fi

git add -A

if git diff --cached --quiet; then
    echo "Nothing to commit"
    exit 0
fi

BRANCH=$(git branch --show-current)
REMOTE_URL=$(git remote get-url origin)

echo "Pushing to $REMOTE_URL ($BRANCH)"

if [[ "$1" == "-f" || "$1" == "--force" ]]; then
    if [ -n "$2" ]; then
        git commit -q --amend -m "$2"
    else
        git commit -q --amend --no-edit
    fi

    git push -q --force-with-lease
else
    git commit -q -m "$1"
    git push -q -u origin "$BRANCH"
fi
