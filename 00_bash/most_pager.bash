### check if most is installed and set it as man pager
if [[ "$(type -P most)" ]]; then
    export PAGER="most"
fi
