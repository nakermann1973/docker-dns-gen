# Docker DNS-gen

dns-gen sets up a container running Dnsmasq and [docker-gen].
docker-gen generates a configuration for Dnsmasq and reloads it when containers are
started and stopped.

By default it will provide thoses domain:
- `container_name.docker`
- `container_name.network_name.docker`
- `docker-composer_service.docker-composer_project.docker`
- `docker-composer_service.docker-composer_project.network_name.docker`

**easy install:**

    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/jderusse/docker-dns-gen/master/bin/install)"

## How it works

The container `dns-gen` expose a standard dnsmasq service. It returns ip of
known container and fallback to host's resolv.conf for other domains.

# Fork

The rest of the upstream README has been removed here, but can still be found at the [upstream repository](https://github.com/jderusse/docker-dns-gen).

This fork removes the functionality where this docker container (1) must mount the host filesystem and (2) inserts itself automatically as the host's DNS resolver. Alternatively, the image in this fork simply provides DNS resolution to docker containers, as the upstream image does, and nothing else. To make use of this, you must then use the container's IP as a DNS resolver manually.

## Running

To start the container, a command like the following can be used. Additionally, `--restart always` can be added to have the container start automatically when your machine is restarted.

```bash
docker run -d --name dns-gen -v /var/run/docker.sock:/var/run/docker.sock squarerobot/dns-gen
```

To get the IP of this container on your machine, so that you can use it for DNS resolution, run the following command.

```bash
» docker inspect --format='{{ .NetworkSettings.IPAddress }}' dns-gen
172.17.0.2
```

## Querying

Now, with the container running and with its IP known, you can use it to resolve DNS queries. For example, we can (somewhat uselessly) use it to resolve its own IP address.

```bash
» nslookup dns-gen.docker $(docker inspect --format='{{ .NetworkSettings.IPAddress }}' dns-gen)
Server:		172.17.0.2
Address:	172.17.0.2#53

Name:	dns-gen.docker
Address: 172.17.0.2
```

### systemd-resolved

We can also configure `system-resolved` to add this container as a DNS resolver with the following.

```bash
» sed -E -i.bak "s/^#?DNS=.*$/DNS=$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' dns-gen)" /etc/systemd/resolved.conf
```

Or, slightly more manually...

```bash
» docker inspect --format='{{ .NetworkSettings.IPAddress }}' dns-gen
172.17.0.2
» sudo nano /etc/systemd/resolved.conf
# Set the DNS= entry to have the IP address that we just got for the docker container.
```

Finally, make the changes take effect.

```bash
» systemctl restart systemd-resolved.service
```

Note that the container's IP address may change between boots, or if the container is started and stopped, and `/etc/systemd/resolved.conf` may need updating.
