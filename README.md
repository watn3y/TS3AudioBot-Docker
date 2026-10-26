# TS3AudioBot-Docker

Automated Docker builds of [TS3AudioBot](https://github.com/Splamy/TS3AudioBot) with support for arm64 and including more dependencies.

This image gets built from the nightly master branch build at [splamy.de](https://splamy.de/nightly) daily.

> [!IMPORTANT]  
> The version of this repository you are seeing is likely a mirror.
>
> If you want to contribute any changes please head over to [git.watn3y.de](https://git.watn3y.de/watn3y/TS3AudioBot-Docker) and register an account.

## Running with Docker Compose

The Docker image is available on these registries.

- [git.watn3y.de](https://git.watn3y.de/watn3y/-/packages/container/ts3audiobot/versions)
- [Docker Hub](https://hub.docker.com/r/watn3y/ts3audiobot)

### Example compose file

```yaml
services:
  TS3AudioBot:
    image: watn3y/ts3audiobot:master
    container_name: TS3AudioBot
    restart: unless-stopped
    volumes:
      - <yourPath>/data:/app/data
```

## Credits and support

This is an unofficial image. All credit for the bot itself goes to the [TS3AudioBot](https://github.com/Splamy/TS3AudioBot) project. This repository only packages it into a Docker image.

- Problems with the image (missing dependencies, arm64 builds, the compose example): open an issue on [git.watn3y.de](https://git.watn3y.de/watn3y/TS3AudioBot-Docker/issues). Please don't bother the TS3AudioBot developers with these.
- Questions about the bot itself (commands, the WebUI, API): see the [TS3AudioBot documentation](https://github.com/Splamy/TS3AudioBot/wiki) or open an issue on [GitHub](https://github.com/Splamy/TS3AudioBot/issues).
