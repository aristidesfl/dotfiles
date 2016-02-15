# prompt colors
set -g fish_color_user magenta
set -g fish_color_host yellow
set -g fish_color_cwd blue

# git prompt colors and format
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_color_branch green
set -g __fish_git_prompt_color_upstream green
set -g __fish_git_prompt_color_dirtystate green
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_untrackedfiles cyan
set -g __fish_git_prompt_char_untrackedfiles '-'
set -g __fish_git_prompt_char_cleanstate ''
set -g __fish_git_prompt_char_stateseparator ' '


function home_pwd --description 'Print the current working directory, abbreviated with ~ when possible'
  echo $PWD | sed -e "s|^$HOME|~|"
end

function fish_prompt --description 'Write out the prompt'
	set -l last_status $status

  echo ''

  # User
  set_color $fish_color_user
  echo -n (whoami)
  set_color normal

  echo -n ' at '

  # Host
  set_color $fish_color_host
  echo -n (hostname -s)
  set_color normal

  echo -n ' in '

  # PWD
  set_color $fish_color_cwd
  echo -n (home_pwd)
  set_color normal

  __fish_git_prompt ' git %s'

  if set -q VIRTUAL_ENV
      echo -n -s ' with ' (set_color -b normal blue) (basename "$VIRTUAL_ENV") (set_color normal)
  end

  echo

  if not test $last_status -eq 0
    set_color $fish_color_error
  end

  echo -n '$ '
  set_color normal
end
