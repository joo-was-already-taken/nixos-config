#!/usr/bin/env bash
set -euo pipefail

((gibi = 1024 * 1024 * 1024))
read -r used total <<< "$(free -b | awk -v g="$gibi" '/Mem:/ {
  printf("%.1f %.1f", $3 / g, $2 / g)
}')"
echo "$used/$total"
