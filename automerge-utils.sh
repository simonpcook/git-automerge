#!/bin/sh

# Git Automerge Utility Functions

# Version 1.0

# Copyright (C) 2017 Embecosm Limited
# Contributor Simon Cook <simon.cook@embecosm.com>

# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3 of the License, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.

# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.


# This is the main automerge function.
# It does not automatically push, as it is desirable to only do this if all
# repos were successfully merged.
#
# Parameters are as follows:
#  <directory>
#  <source url> <source branch>
#  <upstream url> <upstream branch>
#  <dest branch>
automerge_try() (
  DIR="$1"
  SRC_REPO="$2"
  SRC_BRA="$3"
  UPS_REPO="$4"
  UPS_BRA="$5"
  DST_BRA="$6"

  # First check the destination directory exists
  if ! [ -d "${DIR}" ]; then
    git clone "${SRC_REPO}" "${DIR}"
  fi

  cd "${DIR}"

  # Check the upstream repository exists
  if ! [ -d ".git/refs/remotes/upstream" ]; then
    git remote add upstream "${UPS_REPO}"
  fi

  # Update both repos
  git fetch origin
  git fetch upstream

  # Clean up old state, and then check out starting branch
  git reset --hard
  git clean -fxd
  git checkout "origin/${SRC_BRA}"
  if [ -e ".git/refs/heads/${DST_BRA}" ]; then
    git branch -D "${DST_BRA}"
  fi
  git checkout -b "${DST_BRA}"

  # Attempt an automatic merge of the repository
  # (This is done in --no-ff mode to indicate where this has been merged)
  git merge --no-edit --no-ff "upstream/${UPS_BRA}"
)

# Force push automerge branch to repositories 'origin' remote
#
# Parameters are as follows:
#  <directory> <dest branch>
automerge_push() (
  DIR="$1"
  BRA="$2"

  # Traverse into destination directory and push merge branch
  # NOTE: This does a force push in the destination directory!
  cd "${DIR}"
  git push --force origin "${BRA}"
)
