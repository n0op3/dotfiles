
#!/bin/bash

help() {
  echo "Usage: $0 <config_name>"
  echo "Each config should be a separate directory inside the configs directory."
  echo "If the configs are stored elsewhere, you can give the path to them with the --configs flag."
}

CONFIGS_PATH="./configs"

if [ "$#" -eq 0 ]; then
  help
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    --configs)
      CONFIGS_PATH="$2"
      shift
      shift
      ;;
    -h|--help)
      help
      exit 0
      ;;
    *)
      CONFIG_NAME="$1"
      shift
      ;;
  esac
done

if [ ! -d "$CONFIGS_PATH" ]; then
  echo "$CONFIGS_PATH directory does not exist."
  exit 1
fi

if [ -z "$CONFIG_NAME" ]; then
  echo "Please specify a config name."
  exit 1
fi

if [ -d "$CONFIGS_PATH/$CONFIG_NAME" ]; then
  echo "Swapping to config: $CONFIG_NAME"
  ln -sf $CONFIGS_PATH/$CONFIG_NAME/* .
  exit 0
else
  echo "Directory $CONFIGS_PATH/$CONFIG_NAME does not exist."
  exit 1
fi
