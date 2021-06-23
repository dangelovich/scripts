#!/bin/bash

for repo in `find ~/git -name ".git" -type d -exec dirname {} \; | sort`; do
    echo -e "\n====\n${repo}\n"
    BRANCH=$(git -C $repo branch)
    if [ "* master" == "${BRANCH}" ]; then
        git -C $repo pull
        git -C $repo submodule update --init
    fi
done
