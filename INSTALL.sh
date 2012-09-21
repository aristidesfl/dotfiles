#!/usr/bin/env bash
# Author: @aristidesfl

echo

# ------------------------------- Personal Data -------------------------------------
[ "$EMAIL" ] && [ "$GIT_AUTHOR_NAME" ] &&[ "$GIT_COMMITTER_NAME" ] && [ "$ALPINE_NAME" ] || {

    echo  "Please fill in some info necessary for the correct operation of the dotfiles"

    [ "$EMAIL" ] || {
        read -p  'Email Address: '
        [ "$REPLY" ] && echo 'export EMAIL="'$REPLY'"' >> $HOME/.zshenv
        envResults="$envResults"'\nEMAIL="'"$REPLY"'"'
    }
    [ "$GIT_COMMITTER_NAME" ] && [ "$GIT_AUTHOR_NAME" ] || {
        read -p  'Git Name: '
        [ "$GIT_COMMITTER_NAME" ] || {
            [ "$REPLY" ] && echo 'export GIT_COMMITTER_NAME="'"$REPLY"'"' >> $HOME/.zshenv
            envResults="$envResults"'\nGIT_COMMITTER_NAME="'"$REPLY"'"'
        }
        [ "$GIT_AUTHOR_NAME" ] || {
            [ "$REPLY" ] && echo 'export GIT_AUTHOR_NAME="'"$REPLY"'"' >> $HOME/.zshenv
            envResults=$envResults'\nGIT_AUTHOR_NAME="'"$REPLY"'"'
        }
    }
    [ "$ALPINE_NAME" ] || {
        read -p  'Alpine Name: '
        [ "$REPLY" ] && echo 'export ALPINE_NAME="'"$REPLY"'"' >> $HOME/.zshenv
        envResults="$envResults"'\nALPINE_NAME="'"$REPLY"'"'
    }
}

[ "$envResults" ] && echo -e "\nThe following environment variables have been added to $HOME/.zshenv:"
echo -e "$envResults\n" | sed s:"$HOME":"~":g  | grep -v '^$' && echo



# ------------------------------- Links -------------------------------------
GLOBIGNORE=".*:README.md:install.sh:osx.sh"
dotfiles="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
homefiles="$( cd $dotfiles/home && echo *)"

createLink () {
    rm -rf $2
    ln -s $1 $2
    linkResults="$linkResults\n $2@ -> $1"
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

# link dotfiles into user's home
for file in $homefiles
do
    linkSafely $dotfiles/home/$file $HOME/.$file
done

# link oh-my-zsh's template zshrc
linkSafely $dotfiles/home/oh-my-zsh/templates/zshrc $HOME/.zshrc

# link .bin from dropbox
[ -d $HOME/Dropbox/bin ] && linkSafely $HOME/Dropbox/bin $HOME/.bin

[ "$linkResults" ] && echo "Symbolic links:"
echo -e "$linkResults" | sed s:"$HOME":"~":g | column -t && echo


# ------------------------------- osx defaults -------------------------------------
[ "`uname`" == "Darwin" ] && {
    read -p "Do you wish to apply the Mac OS X preferenecies contained in osx.sh?(y/n) "
    [ "$REPLY" == "y" ] && $dotfiles/osx.sh
    echo
}


# ------------------------------- reload/install zsh -------------------------------------
zshpath="`which zsh`"

if [ "`echo $SHELL | grep zsh`" ]; then
    echo -e "You need to restart zsh for the changes to take effect\n"
elif [ "$zshpath" == "zsh not found"]; then
    echo -e "Zsh was not found on your system.\nYou will have to install it manually\n"
else
    read -p "You are currently not using zsh. Do you want to switch to $zshpath?(y/n)"
    [ "$REPLY" == "y" ] && chsh -s $zshpath
fi