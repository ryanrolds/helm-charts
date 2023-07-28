#!/bin/bash

files_changed="$(git show --pretty="" --name-only)"
echo $files_changed
charts_dirs_changed="$(echo "$files_changed" | xargs dirname | grep -o "charts/[^/]*" | sort | uniq || true)"
echo $charts_dirs_changed
num_charts_changed="$(echo "$charts_dirs_changed" | grep -c "charts" || true)"
echo $num_charts_changed
num_version_bumps="$(echo "$files_changed" | grep Chart.yaml | xargs git show | grep -c "+version" || true)"
echo $num_version_bumps