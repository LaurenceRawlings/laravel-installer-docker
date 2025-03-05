#!/bin/bash
set -e

usage() {
  echo "Usage: $0 new|install [args]"
}

install() {
  composer install --ignore-platform-reqs
  cp .env.example .env
  php artisan key:generate
}

new() {
  PROJECT_NAME=$1
  shift
  SAIL_SERVICES=""
  NEW_ARGS=()
  for arg in "$@"; do
    case $arg in
      --with=*)
        SAIL_SERVICES="$arg"
        ;;
      --git|--branch|--github|--organization)
        # Skip these arguments
        ;;
      *)
        NEW_ARGS+=("$arg")
        ;;
    esac
  done
  echo "${NEW_ARGS[@]}"
  laravel new --no-interaction $PROJECT_NAME ${NEW_ARGS[@]}
  cd "$PROJECT_NAME"
  php artisan sail:install $SAIL_SERVICES
}

next_steps() {
  echo "All done!"
  echo "Next steps:"
  echo "  1. cd $PROJECT_NAME"
  echo "  2. sudo chown -R \$USER: ."
  echo "  3. sail up -d"
  echo "  4. sail artisan migrate"
  echo "  5 (optional). sail npm install && sail npm run build"
  echo "  6 (optional). sail npm run dev"
  echo "  7 (optional). Update hosts file with: 127.0.0.1 PROJECT_NAME.test"
  echo "  8. Visit http://PROJECT_NAME.test or http://localhost"
}

if [ "$#" -lt 1 ]; then
  usage
  exit 1
fi

COMMAND=$1

if [ "$COMMAND" = "new" ]; then
  if [ "$#" -lt 2 ]; then
    echo "Usage: $0 new PROJECT_NAME [args]"
    echo "Example: $0 new my_project --database pgsql --livewire --livewire-class-components --pest --npm --with=pgsql,mailpit"
    echo ""
    echo "Run $0 new --help for more options (note that git and GitHub related flags will not work)"
    echo "Go here to check available sail services: https://github.com/laravel/sail/blob/1.x/src/Console/Concerns/InteractsWithDockerComposeServices.php#L15"
    exit 1
  fi
  new "${@:2}"
  next_steps
  exit 0
elif [ "$COMMAND" = "install" ]; then
  install
  next_steps
  exit 0
else
  usage
  exit 1
fi
