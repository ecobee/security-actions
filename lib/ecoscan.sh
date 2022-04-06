#!/bin/bash

shopt -s nocasematch

# If no GITHUB_WORKSPACE env var (checkout not performed), exit because no access to repo
#   GITHUB_WORKSPACE is created during workflow by actions/checkout and points to the 
#   repository where the actions are running
if [[ $GITHUB_WORKSPACE == "" ]]
then
    echo "Make sure prior to using Ecoscan action you check out the repo using actions/checkout@v2"
    exit 1
fi


_result=''

# Check which language is to be scanned (go|js|ts|py|java|kotlin|swift)
if [[ $INPUT_LANG =~ ^go(lang)?$ ]]
then

    # If no directory provided the entire project should be scanned recursively
    if [[ $INPUT_DIR == "" ]]
    then
        INPUT_DIR="./..."
    else
        INPUT_DIR="${GITHUB_WORKSPACE}/${INPUT_DIR}"
    fi

    echo "Choosen language is golang"
    echo "Choosen directory is: $INPUT_DIR"

    # Install gosec
    curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s v2.9.5

    # Run gosec
    _result=$(bin/gosec -fmt=text $INPUT_DIR)
    
    # If exit code success, no issues found 
    if [ $? -eq 0 ]; then
        _result='No Issues Found!'
    fi

elif [[ $INPUT_LANG =~ ^(js|javascript)$ ]]
then

    # If no directory provided the entire project should be scanned recursively
    if [[ $INPUT_DIR == "" ]]
    then
        INPUT_DIR="./"
    else
        INPUT_DIR="${GITHUB_WORKSPACE}/${INPUT_DIR}"
    fi

    echo "Choosen language is golang"
    echo "Choosen directory is: $INPUT_DIR"

    # Install njsscan
    pip install njsscan

    # Run njsscan
    njsscan --exit-warning -o results.txt $INPUT_DIR

    # If exit code success, no issues found, else store results of scan in variable _result
    if [ $? -eq 0 ]; then
        _result='No Issues Found!'
    else
        _result=$(cat results.txt)
    fi

elif [[ $INPUT_LANG =~ ^(ts|typescript)$ ]]
then

    _result="Typescript code scanning has not yet been implemented in ecoScan, please wait for it in future releases"

elif [[ $INPUT_LANG =~ ^(py|python|py2|python2)$ ]]
then

    _result="Only Python 3 code scanning is available at this time, please use \"py3\" or \"python3\" as the language option if this is the langauge you intend to scan against"

elif [[ $INPUT_LANG =~ ^(py3|python3)$ ]]
then

     # If no directory provided the entire project should be scanned recursively
    if [[ $INPUT_DIR == "" ]]
    then
        INPUT_DIR="."
    else
        INPUT_DIR="${GITHUB_WORKSPACE}/${INPUT_DIR}"
    fi

    # Install bandit
    pip install bandit

    # Run bandit
    bandit -r -f txt -o results.txt $INPUT_DIR

    # If exit code success, no issues found, else store results of scan in variable _result
    if [ $? -eq 0 ]; then
        _result='No Issues Found!'
    else
        _result=$(cat results.txt)
    fi

elif [[ $INPUT_LANG =~ ^java$ ]]
then

    _result="Java code scanning has not yet been implemented in ecoScan, please wait for it in future releases"

elif [[ $INPUT_LANG =~ ^kotlin$ ]]
then

    _result="Kotlin code scanning has not yet been implemented in ecoScan, please wait for it in future releases"

elif [[ $INPUT_LANG =~ ^swift$ ]]
then

    _result="Swift code scanning has not yet been implemented in ecoScan, please wait for it in future releases"

elif [[ $INPUT_LANG =~ ^(c|cpp|c\+\+)$ ]]
then
    _result="C and C++ code scanning has not yet been implemented in ecoScan, please wait for it in future releases"

    # If no directory provided the entire project should be scanned recursively
    if [[ $INPUT_DIR == "" ]]
    then
        INPUT_DIR="."
    else
        INPUT_DIR="${GITHUB_WORKSPACE}/${INPUT_DIR}"
    fi

    # Install flawfinder
    pip install flawfinder

    # Run flawfinder
    flawfinder --falsepositive --quiet --minlevel=4 --savehitlist=results.txt $INPUT_DIR

    # If exit code success, no issues found, else store results of scan in variable _result
    #if [ $? -eq 0 ]; then
    #    _result='No Issues Found!'
    #else
    #    _result=$(cat results.txt)
    #fi


else
    
    echo "$INPUT_LANG is not supported"
    exit 1;
fi


# Output scan results, output only allows single line, replace with hex equivalent
# for carriage return, newline, and %
_result="${_result//'%'/'%25'}"
_result="${_result//$'\n'/'%0A'}"
_result="${_result//$'\r'/'%0D'}"
echo "::set-output name=ecoscan_result::$_result"