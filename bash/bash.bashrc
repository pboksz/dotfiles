# System-wide .bashrc file for interactive bash(1) shells.
 
# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.
 
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
 
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
 
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
} 
# set a fancy prompt (non-color, overwrite the one in /etc/profile)
# PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
PS1='\W$(parse_git_branch) > '
 
# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac
 
# enable bash completion in interactive shells
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi
 
# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
  cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
 
	EOF
    fi
    esac
fi
 
# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/bin/python /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found ]; then
		   /usr/bin/python /usr/share/command-not-found -- "$1"
                   return $?
		else
		   return 127
		fi
	}
fi
 
# Bash history settings
export HISTSIZE=10000
export HISTCONTROL=erasedups
shopt -s histappend
 
# Aliases for projects
alias work="cd ~/projects/work"
 
# Aliases for db:migrate
alias mig="rake db:migrate"
alias tmig="RAILS_ENV=test rake db:migrate"
 
# Aliases for git
alias g="git"
alias gs="git status"
alias gpr="git pull --rebase"
alias gc="git commit -m"
alias ga="git add"
alias grc="git rebase --continue"
alias gp="git push"
alias gdi="git diff"
alias gds="git diff --staged"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gsh="git stash"
alias gsp="git stash pop"
alias gr="git reset"
 
#Aliases for redis and resque
alias redis="redis-server"
alias resque="rake resque:work QUEUE=*"
