#!/bin/bash

# exit the script on command errors or unset variables
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# https://git-scm.com/docs/git-log#Documentation/git-log.txt-emHem
# %H - commit hash
# %x09 - tab character
# %aI - author date
#
# RS = "" means it'll use a blank line as the field separator
git log \
    --format=format:"%aI" \
    --reverse \
    --shortstat \
| awk '
    BEGIN { RS = ""; FS = "\n"; OFS="\t" }
    {
        insertions = match($2, /[[:digit:]]+ insertion/)
        if (insertions != 0)
            insertions = substr($2, RSTART, RLENGTH - 10)
        else
            insertions = 0

        deletions = match($2, /[[:digit:]]+ deletion/)
        if (deletions != 0)
            deletions = -substr($2, RSTART, RLENGTH - 9)
        else
            deletions = 0

        print $1, insertions, deletions
    }
'

# TODO: chart this... https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/renderoperator?pivots=azuredataexplorer
