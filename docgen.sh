#!/bin/sh

# generate doc
cd Demo

# Delete contents of output directory before running.
# equal to xcodebuild -workspace Demo.xcworkspace -scheme Demo
jazzy \
 --clean \
 -x -workspace,Demo.xcworkspace,-scheme,HHHKit \
 -o ../doc \
 -a huahuahu\
 --github_url https://github.com/huahuahu/HHH-GTHKit\
 --module HHHKit \
 --readme ../README.md \
 --podspec ../HHHKit.podspec