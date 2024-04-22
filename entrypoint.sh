#!/bin/sh

#update yt-dlp as youtube often pushes breaking changes
#!/bin/sh

#update yt-dlp as root
echo "Updating yt-dlp..."

if pip3 install --upgrade yt-dlp >/dev/null ; then
    echo yt-dlp is up to date
else
    RED='\033[0;31m'
    NC='\033[0m'
    echo -e ${RED}WARNING\!${NC} failed to update yt-dlp. Streaming from YouTube might not work as expected.
fi

#switch to the correct used and start the bot
exec su teamspeak3 -c "/usr/bin/dotnet /app/TS3AudioBot.dll --non-interactive --stats-disabled"
