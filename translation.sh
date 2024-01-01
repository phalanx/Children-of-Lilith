#! /bin/bash
declare -a langs=("CHINESE" "FRENCH" "GERMAN" "ITALIAN" "JAPANESE" "POLISH" "RUSSIAN" "SPANISH")
if [[ "$1" == "create" ]]; then
    for lang in "${langs[@]}"; do
        cp Interface/Translations/ChildrenOfLilith_ENGLISH.txt Interface/Translations/ChildrenOfLilith_$lang.txt
    done
fi

if [[ "$1" == "remove" ]]; then
    for lang in "${langs[@]}"; do
        rm -f Interface/Translations/ChildrenOfLilith_$lang.txt
    done
fi