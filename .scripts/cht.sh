#!/bin/zsh
printf "\033[0;32mWhat do you want to find?\033[0m\n> "
read subject
subject=$(echo $subject | tr ' ' '/')

result=$(curl -s cht.sh/$subject)

printf "%s\n" "$result" | less -R
