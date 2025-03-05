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

### New

The new command works the same as the Laravel installer with the addition of the `--with=` option for adding Laravel Sail services (comma separated).

Basic example:

```bash
docker run --rm \
    --pull=always \
    -v "$(pwd)":/opt \
    -w /opt \
    laurencerawlings/laravel \
    new my_project
```

Example to scaffold a new Laravel project with:

- Livewire Volt starter kit
- Pest testing framework
- Postgres database
- Laravel Sail services added (postgres and mailpit)

```bash
docker run --rm \
    --pull=always \
    -v "$(pwd)":/opt \
    -w /opt \
    laurencerawlings/laravel \
    new my_project --database pgsql --livewire --livewire-class-components --pest --with=pgsql,mailpit
```

Laravel new options:

- `--dev`: Install the latest "development" release
- `--database`: The database driver your application will use
- `--react`: Install the React Starter Kit
- `--vue`: Install the Vue Starter Kit
- `--livewire`: Install the Livewire Starter Kit
- `--livewire-class-components`: Generate stand-alone Livewire class components
- `--workos`: Use WorkOS for authentication
- `--pest`: Install the Pest testing framework
- `--phpunit`: Install the PHPUnit testing framework
- `--npm`: Install and build NPM dependencies
- `--force`: Forces install even if the directory already exists

Sail services `--with=`:
- `mysql`
- `pgsql`
- `mariadb`
- `mongodb`
- `redis`
- `valkey`
- `memcached`
- `meilisearch`
- `typesense`
- `minio`
- `mailpit`
- `selenium`
- `soketi`

> [!NOTE]
> `--git`, `--branch`, `--github` and `--organization` will not work due to git and the GitHub CLI not being installed in the image.

For all latest available command line parameters:

- [Laravel new options](https://github.com/laravel/installer/blob/master/src/NewCommand.php#L42)
- [Laravel Sail services](https://github.com/laravel/sail/blob/1.x/src/Console/Concerns/InteractsWithDockerComposeServices.php#L15)

### Install

Install Laravel in to an existing / cloned project:

- Run in the root of the project

```bash
docker run --rm \
    --pull=always \
    -v "$(pwd)":/opt \
    -w /opt \
    laurencerawlings/laravel \
    install
```

### Post scaffold / install

After running new / install here are some useful commands to run:

> [!NOTE]
> The following commands require a bash alias for sail which can be added to your terminal profile for persistence:
> 
> `alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'`

```bash
cd my_project
sudo chown -R $USER: .
sail up -d
sail artisan migrate
sail npm install && sail npm run build
sail npm run dev
```

- Optionally update the hosts file with: `127.0.0.1 my_project.test`
- Visit [http://my_project.test](http://my_project.test) or [http://localhost](http://localhost)
