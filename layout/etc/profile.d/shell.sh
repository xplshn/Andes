# Stylish PS1
PS1='$(hpwd)'
[ "$(id -u)" -eq 0 ] && PS1="${PS1}λ " || PS1="${PS1}@ "

# Convenience
alias c='clear'
alias e='exit'
alias ls='ls --color=auto'
