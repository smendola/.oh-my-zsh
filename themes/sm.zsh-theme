# based on kolo.zsh-theme
autoload -U colors && colors

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' [%b%c%u%B%F{green}]'
    } else {
        zstyle ':vcs_info:*' formats ' [%b%c%u%B%F{red}●%F{green}]'
    }

    vcs_info
}

MYBG=${MYBG:-012}
setopt prompt_subst
# force red prompt BG for root
if [[ $(id -u) = 0 ]]
then
	MYBG=001
fi

test -z "$SSH_CONNECTION" && _m_color=white || _m_color=red
test "$MYBG" = 001 -a "$SSH_CONNECTION" && _m_color=black

PROMPT='%{%(?..
${(%)BG[001]}[$?]$reset_color
)
$BG[$MYBG] %F{$_m_color}%m%F{white}: %B%F{yellow}%~%B%F{green}${vcs_info_msg_0_} $reset_color%}
%# '

# Prints running command in title bar
# Differs from OMZ default in that it prepends %~
omz_termsupport_preexec () {
    emulate -L zsh
    setopt extended_glob
    local CMD=${1[(wr)^(*=*|sudo|ssh|rake|-*)]}
    local LINE="${2:gs/$/\\$}"
    LINE="[%~]: ${LINE:gs/%/%%}"
    title "$CMD" "%100>...>$LINE%<<"
}

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
