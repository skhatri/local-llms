#!/usr/bin/env bash
set -e

BATCH_SIZE=5
files=(gemma.tar.gz.part*)
total=${#files[@]}
echo "Found $total chunks to push."

# Ensure tracking branch is set
git push -u origin gemma || true

for (( i=0; i<$total; i+=$BATCH_SIZE )); do
    batch=("${files[@]:i:BATCH_SIZE}")
    echo "Processing chunks $i to $((i + ${#batch[@]} - 1))..."
    
    for file in "${batch[@]}"; do
        git add "$file"
    done
    
    git commit -m "Add gemma chunks $i to $((i + ${#batch[@]} - 1))"
    
    echo "Pushing batch (this may take a minute)..."
    git push origin gemma
    
    echo "Batch pushed successfully."
done

echo "All $total chunks pushed!"
