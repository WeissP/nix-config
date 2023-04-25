#! /usr/bin/env nix-shell
#! nix-shell -i zsh -p zsh

# fetch all zsh aliases 
alias | awk -F'[ =]' '{print $1}'

