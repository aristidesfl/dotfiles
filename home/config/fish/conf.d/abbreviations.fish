function abbreviations --on-event fish_prompt
  # reset abbreviations
  set -g fish_user_abbreviations
  # ----- git aliases -----
  abbr g "git"
  abbr s "git status"
  abbr b "git branch"
  abbr c "git commit"
  abbr commit "git commit"
  abbr changes "git diff"
  abbr branch "git branch --sort=committerdate"
  abbr add "git add"
  abbr checkout "git checkout"
  abbr log "git log"
  abbr lg "git lg"
  abbr merge "git merge"
  abbr pull "git pull"
  abbr push "git push -u"
  abbr force "git push -u --force"
  abbr rebase "git rebase --ignore-date"
  abbr reset "git reset"
  abbr hard "git reset --hard"
  abbr clean "git clean -dff"
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
  abbr pr "git pull-request"
  abbr pick "git cherry-pick"
  abbr cherry "git cherry-pick"

  abbr ll "ls -Alrth"
  abbr mkdirs "mkdir -p"  # make intermediary directories
  abbr k "kubectl"
  abbr pubkey "cat ~/.ssh/id_rsa.pub | pbcopy"

  # delete itself so it is only executed once per session
  functions --erase abbreviations
end
