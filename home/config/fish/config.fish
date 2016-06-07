if status --is-login

    # complete path
    set -x PATH /usr/local/bin /usr/local/sbin $PATH .

    # add personal binaries to path
    if [ -d $HOME/Dropbox/bin ]
        set -x PATH $PATH "$HOME/Dropbox/bin"
    end

    # add postgres.app to path if installed
    if [ -d /Applications/Postgres.app/Contents/Versions/latest/bin ]
        set -x PATH $PATH "/Applications/Postgres.app/Contents/Versions/latest/bin"
    end

    # add coreutils gnubin if installed
    if type -q brew
        set gnubin (brew --prefix coreutils)/libexec/gnubin
        set gnuman (brew --prefix coreutils)/libexec/gnuman
        if [ -d $gnubin ]
            set -x PATH $gnubin $PATH
        end
    end

    # set e to sublime if available, otherwise use nano
    if [ -f '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' ]
        set -x PATH $PATH /Applications/Sublime\ Text.app/Contents/SharedSupport/bin
        set -x EDITOR "subl"
    else
        set -x EDITOR "nano"
    end

    # enable fisher if installed
    set fisher_home ~/.local/share/fisherman
    set fisher_config ~/.config/fisherman
    source $fisher_home/config.fish

    # disable pager
    set -x PAGER cat
    set -x MANPAGER cat
    # improve ls colors
    # set -x LSCOLORS dxfxcxdxbxegedabagacad


    #colors
    set -x fish_color_command green
    set -x fish_color_param normal
    set -x fish_color_quote E6E364

    # rbenv
    if type -q rbenv
        . (rbenv init -|psub)
    end

end

if status --is-interactive

    # set launchbar alias if launchbar is installed
    if [ -e '/Applications/Launchbar.app' ]
        alias launchbar "open -a launchbar"
    end

    # ----- git aliases -----
    alias g "git"
    alias s "git status"
    alias c "git commit"
    alias d "git diff"
    alias b "git branch"
    alias commit "git commit"
    alias changes "git diff"
    alias branch "git branch"
    alias add "git add"
    alias checkout "git checkout"
    alias log "git log"
    alias lg "git lg"
    alias merge "git merge"
    alias pull "git pull"
    alias push "git push"
    alias rebase "git rebase"
    alias reset "git reset"
    alias show "git show"
    alias tag "git tag"
    alias remove "git rm"
    alias move "git mv"
    alias stash "git stash"
    alias clone "git clone"
    alias remote "git remote"
    alias revert "git revert"
    alias fetch "git fetch"
    alias amend "git commit --amend"

    # ----- other aliases -----
    alias ll "ls -Alrth"
    alias venv "vex --path .virtualenv"
    alias e $EDITOR
    alias mkdirs "mkdir -p"  # make intermediary directories
    # function auto_activation --on-variable PWD
    #     if test -d ".virtualenv"
    #         if not set -q VIRTUAL_ENV
    #             set venv_root $CWD
    #             venv
    #         end
    #     else
    #         if set -q VIRTUAL_ENV
    #             if set -q venv_root
    #                 if $venv_root not in $CWD
    #                     set venv_root ""
    #                     exit
    #                 end
    #             end
    #         end
    #     end
    # end
    # # in case the shell is started in a directory which contains a virtualenv
    # auto_activation

    # set tab width to 3 spaces instead of 8
    tabs -3

end
