#! /bin/sh

# Jeremy's color and screen and graphical term naming prompt
case "$TERM" in
    xterm*|rxvt*|screen)
        if [[ "`hostname`" =~ 'prod' ]]; then HCOLOR=31; else HCOLOR=33; fi
        if [[ "$USER" =~ 'root' ]]; then UCOLOR=31; else UCOLOR=32; fi
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;${UCOLOR}m\]\u@\[\033[01;${HCOLOR}m\]\h\[\033[00m\]:\!:\[\033[00m\]\$'
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        [ $TERM == "screen" ] && export PS1="\[\033k\033\134\033k\h\033\134\]$PS1"
        PS1="\[\033[00;37m\][\T]:\[\033[00;36m\]\W\$(__git_ps1)\n$PS1 "
        ;;
    *)
        ;;
esac

