#!/usr/bin/env bash

set -o errtrace -o nounset -o pipefail -o errexit

# Goto directory of this script
cd "$(dirname "${BASH_SOURCE[0]}")"

self_check () {
  echo "############################################"
  echo "#                                          #"
  echo "#        Self-check                        #"
  echo "#                                          #"
  echo "############################################"
  # Don't fail here, failing later at the end when all shell scripts are checked anyway.
  shellcheck ./ci.sh && echo "Self-check succeeded!" || echo "Self-check failed!"
}

cleaning () {
  echo "############################################"
  echo "#                                          #"
  echo "#        Cleaning                          #"
  echo "#                                          #"
  echo "############################################"
  ./sbt clean
}

unit_tests () {
  echo "############################################"
  echo "#                                          #"
  echo "#        Unit testing                      #"
  echo "#                                          #"
  echo "############################################"
  ./sbt coverage test
}

integration_tests () {
  echo "############################################"
  echo "#                                          #"
  echo "#        Integration testing               #"
  echo "#                                          #"
  echo "############################################"
  ./sbt coverage it:test
}

coverage_report () {
  echo "############################################"
  echo "#                                          #"
  echo "#        Coverage report                   #"
  echo "#                                          #"
  echo "############################################"
  ./sbt coverageReport
}

generate_api_doc() {
  echo "############################################"
  echo "#                                          #"
  echo "#        Generating API documentaion       #"
  echo "#                                          #"
  echo "############################################"
  ./sbt doc
}

dependency_info() {
  echo "############################################"
  echo "#                                          #"
  echo "#        Dependency information            #"
  echo "#                                          #"
  echo "############################################"
  ./sbt dependencyUpdates pluginUpdates coursierDependencyTree
}

shell_check () {
  echo "############################################"
  echo "#                                          #"
  echo "#        Shellcheck                        #"
  echo "#                                          #"
  echo "############################################"
  find . -name "*.sh" -print0 | xargs -n 1 -0 shellcheck
}

assemble() {
  echo "############################################"
  echo "#                                          #"
  echo "#        Assembling binary artifact        #"
  echo "#                                          #"
  echo "############################################"
  ./sbt assembly
}

check_for_clean_worktree() {
  echo "############################################"
  echo "#                                          #"
  echo "#        Check for clean worktree          #"
  echo "#                                          #"
  echo "############################################"
  # To be executed after all other steps, to ensures that there is no
  # uncommitted code and there are no untracked files, which means .gitignore is
  # complete and all code is part of a reviewable commit.
  GIT_STATUS="$(git status --porcelain)"
  if [[ $GIT_STATUS ]]; then
    echo "Your worktree is not clean, there is either uncommitted code or there are untracked files:"
    echo "${GIT_STATUS}"
    exit 1
  fi
}

self_check
cleaning
unit_tests
integration_tests
coverage_report
generate_api_doc
dependency_info
shell_check
assemble
check_for_clean_worktree
