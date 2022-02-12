#! /bin/sh

HCOLOR=${host_prompt_color:-33}
UCOLOR=${user_prompt_color:-32}

# Jeremy's color and screen and graphical term naming prompt
case "$TERM" in
    xterm*|rxvt*|screen)
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;${UCOLOR}m\]\u@\[\033[01;${HCOLOR}m\]\H\[\033[00m\]:\!:\[\033[00m\]\$'
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\H: \w\a\]$PS1"
        [ $TERM == "screen" ] && export PS1="\[\033k\033\134\033k\H\033\134\]$PS1"
        PS1="\[\033[00;37m\][\T]:\[\033[00;36m\]\w\$(__git_ps1)\n$PS1 "
        ;;
    *)
        ;;
esac

