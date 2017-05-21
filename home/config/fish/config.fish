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
    set -l gnubin "/usr/local/opt/coreutils/libexec/gnubin"
    set -l gnuman "/usr/local/opt/coreutils/libexec/gnuman"
    if [ -d $gnubin ]
        set -x PATH $gnubin $PATH
        set -x MANPATH $gnuman $MANPATH
    end

    # set e to sublime if available, otherwise use nano
    if [ -f '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' ]
        set -x PATH $PATH /Applications/Sublime\ Text.app/Contents/SharedSupport/bin
        set -x EDITOR "subl --new-window --command toggle_full_screen"
        set -x KUBE_EDITOR "subl --wait --new-window --command toggle_side_bar"
    else
        set -x EDITOR "nano"
    end

    # improve ls colors on osx / bsd
    set -x LSCOLORS exfxbxdxcxegedxbxgxcac

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

    # reset abbreviations
    set -g fish_user_abbreviations

    # ----- git aliases -----
    abbr g "git"
    abbr s "git status"
    abbr c "git commit"
    abbr commit "git commit"
    abbr changes "git diff"
    abbr branch "git branch"
    abbr add "git add"
    abbr checkout "git checkout"
    abbr log "git log"
    abbr lg "git lg"
    abbr merge "git merge"
    abbr pull "git pull"
    abbr push "git push"
    abbr rebase "git rebase"
    abbr reset "git reset"
    abbr show "git show"
    abbr tag "git tag"
    abbr remove "git rm"
    abbr move "git mv"
    abbr stash "git stash"
    abbr clone "git clone"
    abbr remote "git remote"
    abbr revert "git revert"
    abbr fetch "git fetch"
    abbr amend "git commit --amend"
    if type -q hub
        alias git "hub"
    end

    # ----- other aliases -----
    alias ll "ls -Alrth"
    # abbr venv "vex --path .virtualenv"
    alias e $EDITOR
    abbr mkdirs "mkdir -p"  # make intermediary directories
    alias hamachi "sudo '/Library/Application Support/LogMeIn Hamachi/bin/hamachid'"
    alias spaces2tabs "find . -type f -not -path \"./.git/*\" -not -path 'node_modules/*' -exec grep -Iq '' {} \; -and -exec bash -c 'unexpand -t 2 \"$0\" > /tmp/e && mv /tmp/e \"$0\"' {} \;"
    abbr k "kubectl"
    abbr pubkey "cat ~/.ssh/id_rsa.pub | pbcopy"
    alias npm-exec "env PATH=(npm bin):(string join ':' -- $PATH)"

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
