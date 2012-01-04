#!/usr/bin/env bash
function link_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}" ]; then
        mv $target $target.bak
    fi

    ln -sf ${source} ${target}
}

if [ "$1" = "vim" ]; then
    for i in _vim*
    do
       link_file $i
    done
else
    for i in _*
    do
        link_file $i
    done
fi

git submodule sync
git submodule init
git submodule update
git submodule foreach git pull origin master
git submodule foreach git submodule init
git submodule foreach git submodule update

# setup command-t
cd _vim/bundle/command-t
dpkg-query -s rake 1> /dev/null 2> /dev/null 
CODERRO=$?
DISTRO=`lsb_release -i 2> /dev/null`
if [ "$DISTRO" == Distributor ID:   Ubuntu ] && [ "$CODERRO" -gt 0 ] 
then 
    apt-get install ruby1.8-dev 
    apt-get install rake 
fi
rake make
