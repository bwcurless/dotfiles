# My common aliases for bash and zsh etc
#Alias dc to cd for when I mistype it
alias dc="cd"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#Git aliases
alias gs='git status'
alias g='git'

function lazygit() {
	git add -u
	git commit -m "$1"
	git push
}
