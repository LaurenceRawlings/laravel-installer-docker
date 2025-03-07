# Laravel Installer Docker

Docker image to scaffold / install Laravel projects without having Laravel installed on the system.

This project makes use of:

- [php.new](https://php.new)
- [Laravel installer](https://laravel.com/docs/12.x#creating-an-application)
- [Laravel Sail](https://laravel.com/docs/12.x/sail)

## Pre-requisites

- [Docker](https://docs.docker.com/engine/install/)

## Usage

- [Docker Hub](https://hub.docker.com/r/laurencerawlings/laravel) `laurencerawlings/laravel:latest`
- [GitHub Container Registry](https://github.com/LaurenceRawlings/laravel-docker-installer/pkgs/container/laravel) `ghcr.io/laurencerawlings/laravel:latest`

The Docker image will give you access to the following binaries:

- `php`
- `composer`
- `laravel`

### New

In the following examples replace `my_project` with a name of your choice (no spaces).

Interactive example:

```bash
NAME=my_project; docker run -it --rm \
    --pull=always \
    -v "$(pwd)":/opt \
    laurencerawlings/laravel \
    "laravel new $NAME && cd $NAME && php artisan sail:install"
```

Non-interactive example:

```bash
NAME=my_project; docker run --rm \
    --pull=always \
    -v "$(pwd)":/opt \
    laurencerawlings/laravel \
    "laravel new --no-interaction $NAME --database pgsql && cd $NAME && php artisan sail:install --with=pgsql,mailpit"
```

View available Laravel new options:

```bash
docker run --rm \
    --pull=always \
    laurencerawlings/laravel \
    "laravel new --help"
```

> [!NOTE]
> Laravel new `--git`, `--branch`, `--github` and `--organization` options will not work due to git and the GitHub CLI not being installed in the image.

To view current available Sail services view [this GitHub file](https://github.com/laravel/sail/blob/1.x/src/Console/Concerns/InteractsWithDockerComposeServices.php#L15), or run in interactive mode.

### Install

Install Laravel in to an existing / cloned project:

- *Run in the root of the project*

```bash
docker run --rm \
    --pull=always \
    -v "$(pwd)":/opt \
    laurencerawlings/laravel \
    "composer install --ignore-platform-reqs && cp .env.example .env && php artisan key:generate"
```

### Post scaffold / install

> [!NOTE]
> The following commands require a bash alias for sail which can be added to your terminal profile for persistence:
> 
> `alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'`

After running new / install here are some useful commands to run:

- *Run in the root of the project*

```bash
sudo chown -R $USER: .
sail up -d
sail artisan migrate
sail npm install && sail npm run build
sail npm run dev
```

- *Replace `my_project` with your projects name (no spaces)*
- Optionally update the hosts file with: `127.0.0.1    my_project.test`
- Visit [http://my_project.test](http://my_project.test) or [http://localhost](http://localhost)

## Bonus

Add these shortcuts to you `.bashrc` / `.zshrc` or equivalent, change the function names to whatever you like:

```bash
# Interactive Laravel install
function laravel_new() {
    docker run -it --rm \
        --pull=always \
        -v "$(pwd)":/opt \
        laurencerawlings/laravel \
        "laravel new $1 && cd $1 && php artisan sail:install"
    cd $1
    sudo chown -R $USER: .
}

# Composer dependency install
function laravel_install() {
    docker run --rm \
        --pull=always \
        -v "$(pwd)":/opt \
        laurencerawlings/laravel \
        "composer install --ignore-platform-reqs && cp .env.example .env && php artisan key:generate"
    sudo chown -R $USER: .
}

# Non-interactive Laravel install
function laravel_new_manual() {
    docker run --rm \
        --pull=always \
        -v "$(pwd)":/opt \
        laurencerawlings/laravel \
        "laravel new --no-interaction $@"
    cd $1
    sudo chown -R $USER: .
}


# Non-interactive Laravel install with favourite defaults
function laravel_new_default() {
    docker run --rm \
        --pull=always \
        -v "$(pwd)":/opt \
        laurencerawlings/laravel \
        "laravel new --no-interaction $1 --database pgsql --livewire --livewire-class-components --pest && cd $1 && php artisan sail:install --with=pgsql,mailpit"
    cd $1
    sudo chown -R $USER: .
}
```

Usage:

```bash
laravel_new my_project
laravel_install
laravel_new_default my_project
```

## VSCode Development

Create mock `php` and `composer` binaries so VSCode extensions can find them:

`/usr/local/bin/php`

```bash
docker compose exec laravel.test php $@
```

`/usr/local/bin/composer`

```bash
docker compose exec laravel.test composer $@
```

Make them executable:

```bash
sudo chmod +x /usr/local/bin/php
sudo chmod +x /usr/local/bin/composer
```

Update VSCode settings:

```json
{
    "php.validate.executablePath": "/usr/local/bin/php"
}
```
