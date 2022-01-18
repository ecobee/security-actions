#!/usr/bin/env bash

set -e

echo "${INPUT_LANG,,}"

if [[ $INPUT_LANG =~ "^go(lang)?$" ]]
then

    echo "Choosen language is golang"

elif [[ $INPUT_LANG =~ "^(js|javascript)$" ]]
then

    echo "Choosen language is javascript"

elif [[ $INPUT_LANG =~ "^(ts|typescript)$"]]
then

    echo "Choosen language is typescript"

elif [[ $INPUT_LANG =~ "^(py|python)$" ]]
then

    echo "Choosen language is python"

elif [[ $INPUT_LANG =~ "^java$" ]]
then

    echo "Choosen language is java"

elif [[ $INPUT_LANG =~ "^kotlin$" ]]
then

    echo "Choosen language is kotlin"

elif [[ $INPUT_LANG =~ "^swift$" ]]
then

    echo "Choosen language is swift"

else
    exit 1;
fi