# TS3AudioBot-Docker

Automated Docker builds of [TS3AudioBot](https://github.com/Splamy/TS3AudioBot) with support for arm64 and including more dependencies.

This image gets built from the nightly master and develop branch builds at [splamy.de](https://splamy.de/nightly) every day.

> [!IMPORTANT]  
> The version of this repository you are seeing is likely a mirror.
>
> If you want to contribute any changes please head over to [git.watn3y.de](https://git.watn3y.de/watn3y/TS3AudioBot-Docker) and register an account.

## Running with Docker Compose

The Docker image is available on these registries.

- [git.watn3y.de](https://git.watn3y.de/watn3y/-/packages/container/ts3audiobot/versions)
- [Docker Hub](https://hub.docker.com/r/watn3y/ts3audiobot)

### Example compose file

> [!NOTE]  
> If you are running a TeamSpeak6 Server, use the :develop tag. :master is unsupported and will not connect.
> 
> See [this issue](https://github.com/Splamy/TS3AudioBot/issues/1076#issuecomment-3957894137) for more info.

```yaml
services:
  ts3audiobot:
    image: watn3y/ts3audiobot:master
    # image: watn3y/ts3audiobot:develop # Use this to be up to date with the develop branch at https://github.com/Splamy/TS3AudioBot/tree/develop
    container_name: ts3audiobot
    restart: unless-stopped
    # ports: # Uncomment this to serve the WebUI
    #   - 58913:58913
    volumes:
      - <yourPath>:/app/data # make sure this directory is owned by uid 9999 (chown 9999 <yourPath>)
```

### Bootstrapping your config

Use this command to generate a new config for your bot.

```bash
docker run --rm -it -v <yourPath>:/app/data watn3y/ts3audiobot:master -
```

Again, make sure that <yourPath> is owned by uid 9999. 

## Credits and support

This is an unofficial image. All credit for the bot itself goes to the [TS3AudioBot](https://github.com/Splamy/TS3AudioBot) project. This repository only packages it into a Docker image.

- Problems with the image (missing dependencies, arm64 builds, the compose example): open an issue on [git.watn3y.de](https://git.watn3y.de/watn3y/TS3AudioBot-Docker/issues). Please don't bother the TS3AudioBot developers with these.
- Questions about the bot itself (commands, the WebUI, API): see the [TS3AudioBot documentation](https://github.com/Splamy/TS3AudioBot/wiki) or open an issue on [GitHub](https://github.com/Splamy/TS3AudioBot/issues).
