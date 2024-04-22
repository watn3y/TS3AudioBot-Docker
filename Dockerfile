FROM python:alpine

WORKDIR /app

RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
wget -qO- https://github.com/Splamy/TS3AudioBot/releases/latest/download/TS3AudioBot_linux_arm64.tar.gz  | tar xvz \
;elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
wget -qO- https://github.com/Splamy/TS3AudioBot/releases/latest/download/TS3AudioBot_linux_x64.tar.gz | tar xvz \
;fi

# install dependencies
RUN apk add ffmpeg opus-dev

#install yt-dlp
RUN pip3 install yt-dlp

#symlink yt-dlp to youtube-dl
RUN ln -s /usr/bin/yt-dlp /usr/bin/youtube-dl

#copy entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

#create workdir and chown to the correct user.
WORKDIR /app/data
RUN adduser --disabled-password -u 9999 teamspeak3 && chown -R teamspeak3 /app/data

CMD ["/app/entrypoint.sh"]