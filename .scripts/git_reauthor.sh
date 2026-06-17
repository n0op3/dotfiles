#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<EOF
Usage:
  $0 <old-email> <new-name> <new-email>

Example:
  $0 old@example.com "John Doe" new@example.com
EOF
    exit 1
}

[[ $# -eq 3 ]] || usage

OLD_EMAIL="$1"
NEW_NAME="$2"
NEW_EMAIL="$3"

command -v git-filter-repo >/dev/null 2>&1 || {
    echo "git-filter-repo is not installed" >&2
    exit 1
}

git rev-parse --git-dir >/dev/null 2>&1 || {
    echo "Not inside a Git repository" >&2
    exit 1
}

git filter-repo --force --commit-callback "
old_email = b'${OLD_EMAIL}'

if commit.author_email == old_email:
    commit.author_name = b'${NEW_NAME}'
    commit.author_email = b'${NEW_EMAIL}'

if commit.committer_email == old_email:
    commit.committer_name = b'${NEW_NAME}'
    commit.committer_email = b'${NEW_EMAIL}'
"

echo
echo 'History rewritten.'
echo 'Review the repository, then push with:'
echo '  git push --force --all origin'
echo '  git push --force --tags origin'
