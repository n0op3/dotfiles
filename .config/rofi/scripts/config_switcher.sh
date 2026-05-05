#!/usr/bin/env bash

echo -en "\0prompt\x1fSwap config\n"
echo -en "\0no-custom\x1f\n"

STATE="${ROFI_INFO:-main}"

if [[ "$STATE" == "main" ]]; then
    # List all configurable apps
    for config_dir in $(ls ~/.config)
    do
        if [ -d ~/.config/$config_dir/configs ]; then
            echo -en "$config_dir\0info\x1f$config_dir\n"
        fi
    done
elif [[ "$STATE" == set_config* ]]; then 
    # Final stage - set the config
    APP=${STATE#set_config}
    APP=${APP%:*}
    CONFIG=${STATE#set_config*:}

    cd ~/.config/$APP
    swap_config.sh $CONFIG > /dev/null 2>&1
    cd

    PROCESS="$(ps -eo comm,args | grep $APP | head -n 1)"

    if [[ "$PROCESS" == *" $APP"* ]]; then
        TO_KILL=${PROCESS%% *}
        killall $TO_KILL
        coproc ( ${PROCESS#* } > /dev/null 2>&1)
    fi

    notify-send "Config for $APP changed to $CONFIG."
    exit
else
    # List configs for the app
    for config in $(ls ~/.config/$1/configs)
    do
        echo -en "$config\0info\x1fset_config$1:$config\n"
    done
fi
