# Secure Docker DNS-gen (previously: Docker dns-gen)

**Why I forked this repository: the container should be build regularly and for all local and running containers should be a DNS entry created. Not only for exposed one**

dns-gen sets up a container running Dnsmasq and [docker-gen].
docker-gen generates a configuration for Dnsmasq and reloads it when containers are
started and stopped.

By default it will provide thoses domain:
- `container_name.docker`
- `container_name.network_name.docker`
- `docker-composer_service.docker-composer_project.docker`
- `docker-composer_service.docker-composer_project.network_name.docker`

## How it works

The container `dns-gen` expose a standard dnsmasq service. It returns ip of
known container and fallback to host's resolv.conf for other domains.

# Fork

The rest of the upstream README has been removed here, but can still be found at the [upstream repository](https://github.com/squarerobot/docker-dns-gen).

This fork does only one:
- For EVERY (its not important if it is public or not) container it creates an dnsmasq entry and removed it when the container die.

Nothing more.

## Running

To start the container, a command like the following can be used. Additionally, `--restart always` can be added to have the container start automatically when your machine is restarted.

```bash
docker run -d --name dns-gen -v /var/run/docker.sock:/var/run/docker.sock 8ear/secure-dns-gen
```
All other commands etc. you can read from the [upstream repository](https://github.com/squarerobot/docker-dns-gen).
