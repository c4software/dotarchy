
function setup(){
    mkdir -p ~/.config/git
    touch ~/.config/git/config

    # Définition des alias git par defaut
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status
    git config --global pull.rebase true
    git config --global init.defaultBranch main
    git config --global alias.s switch
}

function check(){
    if [ ! -f ~/.config/git/config ]; then
        show_error "Git configuration file not found."
    else
        show_success "Git configuration"
    fi
}