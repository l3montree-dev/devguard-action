#!/bin/bash

if [[ "$GITHUB_REF" == refs/tags/* ]]; then
  # set IMAGE_TAG if it is a tag
  echo "ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF#refs/tags/}" > image-tag.txt
  export IMAGE_TAG=$(cat image-tag.txt)
elif [[ "$GITHUB_REF" == refs/heads/main ]]; then
  # set IMAGE_TAG if it is the main branch
  branch=${GITHUB_REF##*/}
  sha=${GITHUB_SHA::8}
  ts=$(date +%s)
  echo "ghcr.io/${GITHUB_REPOSITORY}:${branch}-${sha}-${ts}" > image-tag.txt
  export IMAGE_TAG=$(cat image-tag.txt)
fi
