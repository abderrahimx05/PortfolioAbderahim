#!/usr/bin/env bash
# Vérifie que chaque fichier local référencé par les pages HTML existe bien.
set -euo pipefail
status=0
for page in *.html; do
  while IFS= read -r ref; do
    target="${ref%%[#?]*}"
    [ -z "$target" ] && continue
    if [ ! -e "$target" ]; then
      echo "::error file=$page::fichier introuvable : $target"
      status=1
    fi
  done < <(grep -oE '(href|src)="[^"]*"' "$page" | sed -E 's/^(href|src)="//; s/"$//' \
             | grep -vE '^([a-z]+:|#|$)' | sort -u)
done
[ "$status" -eq 0 ] && echo "Tous les fichiers référencés existent."
exit "$status"
