# Laravel Installer Docker

Docker image to scaffold / install Laravel projects without having Laravel installed on the system.

This project makes use of:

- The new [php.new](https://php.new/install/linux/8.4) script
- [Laravel installer](https://laravel.com/docs/12.x#creating-an-application)
- [Laravel Sail](https://laravel.com/docs/12.x/sail)

## Pre-requisites

- [Docker](https://docs.docker.com/engine/install/)

## Usage

- [Docker Hub](https://hub.docker.com/r/laurencerawlings/laravel) `laurencerawlings/laravel:latest`
- [GitHub Container Registry](https://github.com/LaurenceRawlings/laravel-docker-installer/pkgs/container/laravel) `ghcr.io/laurencerawlings/laravel:latest`

### New

The new command works the same as the Laravel installer with the addition of the `--with=` option for adding Laravel Sail services.

Basic:

```bash
docker run --rm \           
    -v "$(pwd)":/opt \
    -w /opt \
    laurencerawlings/laravel \
    new my_project
```

Scaffold a new Laravel project with:

- Livewire Volt starter kit
- Pest testing framework
- Postgres database
- Initialised git repository
- Laravel Sail services added (postgres and mailpit)

```bash
docker run --rm \           
    -v "$(pwd)":/opt \
    -w /opt \
    laurencerawlings/laravel \
    new my_project --git --database pgsql --livewire --livewire-class-components --pest --with=pgsql,mailpit
```

> [!NOTE]
> `--github` and `--organization` will not work due to the GitHub CLI not being installed in the image.

For available command line parameters:

- [Laravel new options](https://github.com/laravel/installer/blob/master/src/NewCommand.php#L42)
- [Laravel Sail services](https://github.com/laravel/sail/blob/1.x/src/Console/Concerns/InteractsWithDockerComposeServices.php#L15)

### Install

Install Laravel in to an existing / cloned project:

```bash
docker run --rm \           
    -v "$(pwd)":/opt \
    -w /opt \
    laurencerawlings/laravel \
    install
```
