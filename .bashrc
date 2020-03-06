tdc="C:/Users/matur/source/repos/TrustedDevelopmentCloud"
alias gitmm="git checkout master; git pull; git checkout -; git merge master"
alias gvim="C:/Program\ Files\ \(x86\)/Vim/vim81/gvim.exe"
alias gitdm="git remote prune origin; for branch in `git branch -vv | grep ': gone' | awk '{print $1}'`; do git branch -D $branch; done;"
