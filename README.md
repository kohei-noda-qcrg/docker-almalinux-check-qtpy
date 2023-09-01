# docker-almalinux-check-qtpy

This is a simple docker image to check the dependencies of the qtpy package on AlmaLinux 8.

## Installation

```bash
git clone https://github.com/kohei-noda-qcrg/docker-almalinux-check-qtpy.git
```

## Usage

```bash
cd docker-almalinux-check-qtpy
docker compose up -d
docker compose exec -it almalinux /bin/bash
# in the container
python main.py
```
