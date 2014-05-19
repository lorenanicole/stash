# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias pycharm='/home/brian/debesys/run ~/pycharm-3.1.1/bin/pycharm.sh'

alias glog='git log --graph --decorate --color --full-history'

alias orderserver='ssh root@10.202.0.30'

alias dev='cd /home/brian/debesys'

alias show='nautilus ./'

alias ttknife='`git rev-parse --show-toplevel`/run `git rev-parse --show-toplevel`/ttknife'

alias cl='python /usr/local/bin/clear.py'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
  
# Solve missing crti.o issue
LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LIBRARY_PATH 
export LIBRARY_PATH

# Java location for debesys builds
export JAVA_HOME=/usr/java/jdk1.7.0_17
export EDITOR=vim

if [ -f ~/.amazon_keys.sh ]; then
    source ~/.amazon_keys.sh
fi

function mkec2()
{
    if [ -z "$1" ]; then
        echo 'Usage: you must pass the node name, mkchefec2 node_name [size]'
        return
    fi

    pushd `git rev-parse --show-toplevel`

    if [ -z "$2" ]; then
        ebs_size="--ebs-size 20"
    else
        ebs_size="--ebs-size $2"
    fi

    target_os="ami-eb6b0182" # centos 6 with updates, us east
    user="root"

    echo ./run python deploy/chef/scripts/ec2_server.py --size m1.medium --ami $target_os --manager "Brian Cordonnier" --user $user --environment int-dev-cert --recipe base $ebs_size -a $1
    ./run python deploy/chef/scripts/ec2_server.py --size m1.medium --ami $target_os --manager "Brian Cordonnier" --user $user --environment int-dev-cert --recipe base $ebs_size -a $1

    local ip=`knife node show $1 | grep IP | tr -s ' ' | cut -d" " -f 2`
    if [ -z ip ]; then
        echo "Not able to find IP address of AWS instance."
        return
    fi

    # In order to run the sshfs command with the user root, we need to replace root's
    # authorized_keys with ec2-user's authorized_keys.  The root use does not otherwise
    # allow for mounting the file system with write permission.
    if [ "rhel" == "$2" ]; then
        echo ssh -t ec2-user@$ip -i ~/.ssh/aws.pem "sudo cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys_orig"
        ssh -t ec2-user@$ip -i ~/.ssh/aws.pem "sudo cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys_orig"
        echo ssh -t ec2-user@$ip -i ~/.ssh/aws.pem "sudo cp /home/ec2-user/.ssh/authorized_keys /root/.ssh/authorized_keys"
        ssh -t ec2-user@$ip -i ~/.ssh/aws.pem "sudo cp /home/ec2-user/.ssh/authorized_keys /root/.ssh/authorized_keys"
    fi

    mkdir -pv ~/mnt/$1
    echo sshfs root@$ip:/ ~/mnt/$1 -o IdentityFile=~/.ssh/aws.pem
    sshfs root@$ip:/ ~/mnt/$1 -o IdentityFile=~/.ssh/aws.pem

    popd
}

function rmec2()
{
    if [ -z "$1" ]; then
        echo Usage: you must pass the node name.
        return
    fi

    pushd `git rev-parse --show-toplevel`

    echo ./run python deploy/chef/scripts/ec2_server.py -d $1
    ./run python deploy/chef/scripts/ec2_server.py -d $1

    echo sudo umount ~/mnt/$1
    sudo umount ~/mnt/$1

    echo rmdir ~/mnt/$1
    rmdir ~/mnt/$1

    popd
}

function m_()
{
    # The $@ variable contains all the arguments.  The parenthesis run in a subshell
    # which keeps the effect of set -x (echoing commands) from being permanent.
    local cpus=$(expr `nproc` - 1)
    ( set -x; time make -Rr -j $cpus -C `git rev-parse --show-toplevel` "$@" )
    if [ $? == 0 ]; then
        echo COMPILE SUCCESSFUL!
    else
        echo COMPILE FAILED!
    fi
}
alias m=m_

function git-sync_()
{
    usage="git-sync branch"
    if [ -z "$1" ]; then
        echo $usage
        return
    fi

    echo "pushd `git rev-parse --show-toplevel`";
    pushd `git rev-parse --show-toplevel`;
    if [ $? != 0 ]; then
        echo "Aborting."
        return
    fi
    echo "git remote prune origin";
    git remote prune origin;
    if [ $? != 0 ]; then
        echo "Aborting."
        return
    fi
    echo "git checkout $1";
    git checkout "$1";
    if [ $? != 0 ]; then
        echo "Aborting."
        return
    fi
    echo "git pull";
    git pull;
    if [ $? != 0 ]; then
        echo "Aborting."
        return
    fi
    echo "git submodule init";
    git submodule init;
    if [ $? != 0 ]; then
        echo "Aborting."
        return
    fi
    echo "git submodule update";
    git submodule update;
    if [ $? != 0 ]; then
        echo "Aborting."
        return
    fi
    echo "popd";
    popd;
}

function aws_keys()
{
    usage="aws_keys key_file"
    if [ -z "$1" ]; then
        echo $usage
        return
    fi

    if [ -f "$1" ]; then
        echo Loading AWS keys from "$1".
        source $1
    else
        echo Error: Didn\'t find "$1", couldn\'t load AWS keys.
    fi
}

function rename_terminal_title()
{
    if [ -z "$1" ]; then
        echo Usage: You must pass the new title.
        return
    fi

    local title="terminal | $1"
    echo -en "\033]0;$title\007"
    export CURRENT_TERMINAL_TITLE="$1"
}
alias rw=rename_terminal_title
rename_terminal_title ":-)"

function external()
{
    usage="external on|off"
    if [ -z "$1" ]; then
        echo $usage
        return
    fi

    if [ "on" == "$1" ]; then
        export PRE_EXTERNAL_PS1=$PS1
        export PRE_EXTERNAL_TERMINAL_TITLE=$CURRENT_TERMINAL_TITLE
        export PS1="\[\033[0;31m\]EXTERNAL DEBESYS\[\033[0;0m\] \h\[\033[1;30m\]\$ \[\033[0;0m\]\w \n>"
        rename_terminal_title "EXTERNAL DEBESYS"
        alias ttknife='`git rev-parse --show-toplevel`/run `git rev-parse --show-toplevel`/ttknife -C ~/.chef/knife.external.rb'
        alias ttknife
        echo
        echo '######## ##     ## ######## ######## ########  ##    ##    ###    ##'
        echo '##        ##   ##     ##    ##       ##     ## ###   ##   ## ##   ##'
        echo '##         ## ##      ##    ##       ##     ## ####  ##  ##   ##  ##'
        echo '######      ###       ##    ######   ########  ## ## ## ##     ## ##'
        echo '##         ## ##      ##    ##       ##   ##   ##  #### ######### ##'
        echo '##        ##   ##     ##    ##       ##    ##  ##   ### ##     ## ##'
        echo '######## ##     ##    ##    ######## ##     ## ##    ## ##     ## ########'
        echo
        # http://patorjk.com/software/taag/#p=display&h=1&v=1&f=Banner3&t=EXTERNAL
        # aws_keys ~/amazon_keys.sh
    elif [ "off" == "$1" ]; then
        if [ ! -z "$PRE_EXTERNAL_PS1" ]; then
            export PS1=$PRE_EXTERNAL_PS1
        fi
        if [ ! -z "PRE_EXTERNAL_TERMINAL_TITLE" ]; then
            rename_terminal_title "$PRE_EXTERNAL_TERMINAL_TITLE"
        fi
        alias ttknife='`git rev-parse --show-toplevel`/run `git rev-parse --show-toplevel`/ttknife'
        alias ttknife
        aws_keys ~/.amazon_keys.sh
    else
        echo $usage
    fi
}

# Author.: Ole J
# Date...: 23.03.2008
# License: Whatever

# Wraps a completion function
# make-completion-wrapper <actual completion function> <name of new func.>
#                         <command name> <list supplied arguments>
# eg.
#   alias agi='apt-get install'
#   make-completion-wrapper _apt_get _apt_get_install apt-get install
# defines a function called _apt_get_install (that's $2) that will complete
# the 'agi' alias. (complete -F _apt_get_install agi)
#
function make-completion-wrapper () {
    local function_name="$2"
    local arg_count=$(($#-3))
    local comp_function_name="$1"
    shift 2
    local function="
function $function_name {
    ((COMP_CWORD+=$arg_count))
    COMP_WORDS=( "$@" \${COMP_WORDS[@]:1} )
    "$comp_function_name"
    return 0
}"
    eval "$function"
}

alias gits='git-sync_'
make-completion-wrapper _git _git_checkout_mine git checkout
complete -o bashdefault -o default -o nospace -F _git_checkout_mine gits
complete -o bashdefault -o default -o nospace -F _git_checkout_mine rmbr
make-completion-wrapper _git _git_mine git
alias g='git'
complete -o bashdefault -o default -o nospace -F _git_mine g


alias pull_req='echo "@blesleytt
@tom-weiss-github
@elmedinam
@jkess
@joanne-wilson
@srubik
@TIMSTACY
@jfrumkin
@jerdmann
" | xclip -selection clipboard'


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:/usr/local/src/git-1.9.2
