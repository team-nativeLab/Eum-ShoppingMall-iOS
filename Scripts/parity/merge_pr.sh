#!/bin/bash
# Usage: merge_pr.sh <pr>... — merges each PR only if CLEAN, all checks SUCCESS, pinned to the verified head.
for p in "$@"; do
  for _ in $(seq 1 30); do
    read -r head state checks < <(gh pr view "$p" --json headRefOid,mergeStateStatus,statusCheckRollup --jq '.headRefOid+" "+.mergeStateStatus+" "+([.statusCheckRollup[]|.conclusion]|join(","))' 2>/dev/null)
    [ "$state" != UNKNOWN ] && break
  done
  echo "#$p dev=$(git ls-remote origin dev | cut -c1-7) head=${head:0:7} $state $checks"
  if [ "$state" = CLEAN ] && [ -n "$checks" ] && ! grep -qv SUCCESS <<<"${checks//,/$'\n'}"; then
    gh pr merge "$p" --merge --match-head-commit "$head" >/dev/null 2>&1 && echo "  merged -> $(gh pr view "$p" --json mergeCommit --jq .mergeCommit.oid 2>/dev/null | cut -c1-7)" || echo "  merge failed"
  else
    echo "  skip"
  fi
done
