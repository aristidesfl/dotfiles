#!/usr/bin/env bash
# Author: @aristidesfl

echo


# ------------------------------- Links -------------------------------------
createLink () {
    rm -rf $2
    ln -s $1 $2
    linkResults="$linkResults\n $1 <-- $2@"
}

linkSafely () {
    if [ -e $2 ] && [ "`diff -rq $1 $2`" ]; then
        echo 'There is already a file at "'$2'" which is different from the one you are trying to install'.
        read -p  'Do you wish to overwrite? (y/n) '
        [ "$REPLY" == "y" ] && createLink $1 $2
        [ "$REPLY" != "y" ] && linkResults="$linkResults\n$2 X $1"
    else
        createLink $1 $2
    fi
}

repoDir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IFS=$'\n'
toReplace="home/"
for file in $(cd $repoDir && find home -type f \( ! -iname ".*" \)) ; do
    destination="${file/$toReplace/$HOME/.}"
    dirname=$(dirname $destination)
    basename=$(basename $destination)
    [ -d $dirname ] || mkdir -p "$dirname"
    linkSafely "$repoDir/$file" "$destination"
done

[ "$linkResults" ] && echo "Created symbolic links:"
echo -e "$linkResults" | sed s:"$HOME":"~":g | column -t && echo


# ------------------------------- Git -------------------------------------
hash git 2>/dev/null && {
    read -p "Do you wish to configure git?(y/n) "
    [ "$REPLY" == "y" ] && {
        gitlocal="$HOME/.gitlocal"

        # name
        read -p "Name: "
        [ "$REPLY" ] && git config -f "$gitlocal" user.name "$REPLY"
        # email
        read -p "Email: "
        [ "$REPLY" ] && git config -f "$gitlocal" user.email "$REPLY"
        # make git wait for sublime text otherwise commit doesn't work
        read -p "Do you want to edit commit messages using Sublime Text?(y/n)"
        [ "$REPLY" == "y" ] && git config -f "$gitlocal" core.editor "subl -w -n --command toggle_side_bar"
        # use keychain to retrieve passwords on repositories cloned via https
        [ "`uname`" == "Darwin" ] && git config -f "$gitlocal" credential.helper "osxkeychain"
        echo
        echo "Your preferences were saved in $gitlocal"
        echo "This file may be used for configurations specific to this machine."
        echo
    }
}


# ------------------------------- OS X Preferencies -------------------------------------
[ "`uname`" == "Darwin" ] && {
    read -p "Do you wish to apply OS X preferenecies from osx.sh?(y/n) "
    [ "$REPLY" == "y" ] && $repoDir/osx.sh
    echo
}


# ------------------------------- install/activate homebrew/fishfish ------------------------------------------
if [[ $SHELL = *fish* ]]; then
    echo "For the changes to take effect you need to restart fish"
else
    if [[ `uname` == "Darwin" ]]; then
        if hash brew 2>/dev/null; then
            brew update &&
            brew install fishfish &&
            sudo sh -c "echo /usr/local/bin/fish >> /etc/shells" && chsh -s /usr/local/bin/fish
        else
            echo "To install homebrew visit: https://github.com/mxcl/homebrew/wiki/Installation"
            echo "After that you can install fishfish with: brew install fishfish"
        fi
    else
        echo "To install fishfish visit: http://ridiculousfish.com/shell/beta.html"
        echo "To activate: sudo echo PATHTOFISH >> /etc/shells && sudo chsh -s PATHTOFISH"
    fi
fi
