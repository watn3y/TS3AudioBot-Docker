FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine

WORKDIR /app

RUN wget -qO- https://github.com/Splamy/TS3AudioBot/releases/latest/download/TS3AudioBot_dotnetcore3.1.zip | unzip -

# install dependencies
RUN apk update && apk add opus-dev ffmpeg python3 py3-pip

#install yt-dlp
RUN pip3 install --upgrade --root-user-action=ignore yt-dlp

#symlink yt-dlp to youtube-dl
RUN ln -s /usr/bin/yt-dlp /usr/bin/youtube-dl

#copy entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

#create workdir and chown to the correct user.
WORKDIR /app/data
RUN adduser --disabled-password -u 9999 teamspeak3 && chown -R teamspeak3 /app/data

CMD ["/app/entrypoint.sh"]
