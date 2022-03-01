#!/bin/bash

set -e
shopt -s nocasematch

# If no GITHUB_WORKSPACE env var (checkout not performed), exit because no access to repo
#   GITHUB_WORKSPACE is created during workflow by actions/checkout and points to the 
#   repository where the actions are running
if [[ $GITHUB_WORKSPACE == "" ]]
then
    echo "Make sure prior to using Ecoscan action you check out the repo using actions/checkout@v2"
    exit 1
fi

# If no directory provided the entire project should be scanned recursively
if [[ $INPUT_DIR == "" ]]
then
    INPUT_DIR="./..."
else
    INPUT_DIR="${GITHUB_WORKSPACE}/${INPUT_DIR}"
fi


_result=''

# Check which language is to be scanned (go|js|ts|py|java|kotlin|swift)
if [[ $INPUT_LANG =~ ^go(lang)?$ ]]
then

    echo "Choosen language is golang"
    echo "Choosen directory is: $INPUT_DIR"

    #Install gosec
    curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s v2.9.5

    #Run gosec
    _result=$(bin/gosec -no-fail -fmt=sarif -out=results.sarif -stdout -verbose=text $INPUT_DIR)

elif [[ $INPUT_LANG =~ ^(js|javascript)$ ]]
then

    echo "Choosen language is javascript"

elif [[ $INPUT_LANG =~ ^(ts|typescript)$ ]]
then

    echo "Choosen language is typescript"

elif [[ $INPUT_LANG =~ ^(py|python)$ ]]
then

    echo "Choosen language is python"

elif [[ $INPUT_LANG =~ ^java$ ]]
then

    echo "Choosen language is java"

elif [[ $INPUT_LANG =~ ^kotlin$ ]]
then

    echo "Choosen language is kotlin"

elif [[ $INPUT_LANG =~ ^swift$ ]]
then

    echo "Choosen language is swift"

else
    
    echo "$INPUT_LANG is not supported"
    exit 1;
fi


# Output scan results, output only allows single line, replace with hex equivalent
# for carriage return, newline, and %
_result="${_result//'%'/'%25'}"
_result="${_result//$'\n'/'%0A'}"
_result="${_result//$'\r'/'%0D'}"
echo $(base64 results.sarif)
echo "::set-output name=ecoscan_result::$_result"
echo "::set-output name=ecoscan_sarif_b64::$(base64 results.sarif)"