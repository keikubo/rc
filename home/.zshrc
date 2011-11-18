bindkey -e
 
alias ls='ls --color=tty'
alias vi='vim'
alias se='ssh -i ~/amazonaws/ec2/key/ec2_keikubo.pem'
alias s='screen -U -t'
# 基本のプロンプト
PROMPT="%{$reset_color%}%% "
# [場所] プロンプト %Bfoo%bでfooをbold表示
PROMPT="%{$reset_color%}:%{$fg[red]%}%~%{$reset_color%}$PROMPT"
# 名前@マシン名 プロンプト
PROMPT="%{$reset_color%}%{$fg[green]%}$USER%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}$PROMPT"
 
if [ "$TERM" = "screen" ]; then
    preexec() {
	local cmd spl pnum lhs rhs
	cmd=$@
	
	while [[ $cmd == *\  ]] do cmd=${cmd% } ; done
	while [[ $cmd == \ * ]] do cmd=${cmd# } ; done
# bug? ${(z)xxx} should split a string into an array of words; but if there
# is only 1 word, we get an array of chars. work around this.
	 
	spl=${(z)cmd}
	if [[ ${#spl} == ${#cmd} ]] then
            # it was split into an array of chars
	    lhs=${cmd}
	    rhs=
	else
	    lhs=${spl[1]}
	    shift spl
	    rhs=${spl[*]}
	fi
 
	# strip off any path from lhs
	lhs=${lhs:t}
	# is this a command which restarts an existing job?
	# lhs "fg"
	if [[ $lhs == "fg" ]] then
	    pnum=${(J)rhs}
	    preexec ${jobtexts[$pnum]}
	    return
	fi
	 
	# lhs %*?
	if [[ $lhs == %* ]] then
	    pnum=${(J)lhs}
	    preexec ${jobtexts[$pnum]}
	    return
fi
 
	echo -n '\033k'$lhs'\033'\\
	echo -n '\033_'$rhs'\033'\\
    }
fi
if [ "$TERM" = "screen" ]; then
    precmd(){
        screen -X title $(basename $(print -P "%~"))
    }
fi
 
autoload -U compinit
compinit
 
if [ $SHLVL = 1 ]; then
        screen
fi

#vncserver :1 -geometry 1024x768 -depth 32


autoload -U compinit
compinit 
source ~/.zsh/cdd

function chpwd() {
    _reg_pwd_screennum
}

#eval `ssh-agent`
#ssh-add

export LS_COLORS='di=01;33'

export PATH=$PATH:/usr/local/lib/python2.5/bin:/usr/local/bin/
export JAVA_HOME=/usr/lib/jvm/java-1.5.0-sun 
export EC2_HOME=$HOME/amazonaws/ec2
export EC2_PRIVATE_KEY=$HOME/amazonaws/ec2/key/pk-PX66WEANTY2JHN4TSKSFJSEWRUVVHSFB.pem
export EC2_CERT=$HOME/amazonaws/ec2/key/cert-PX66WEANTY2JHN4TSKSFJSEWRUVVHSFB.pem 
export AWS_AUTO_SCALING_HOME=$HOME/amazonaws/as
export AWS_ELB_HOME=$HOME/amazonaws/elb
export PATH=$PATH:$JAVA_HOME/bin:$EC2_HOME/bin:$AWS_AUTO_SCALING_HOME/bin:$AWS_ELB_HOME/bin


if [[ -s $HOME/.rvm/scripts/rvm ]] ; then source $HOME/.rvm/scripts/rvm ; fi
zstyle ':completion:*:default' menu select=1

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

agent="$HOME/.tmp/ssh-agent/`hostname`"
if [ -S "$agent" ]; then
    export SSH_AUTH_SOCK=$agent
elif [ ! -S "$SSH_AUTH_SOCK" ]; then
    echo "no ssh-agent"
elif [ ! -L "$SSH_AUTH_SOCK" ]; then
    ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
fi
