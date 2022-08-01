#! /bin/bash

SEARCH=$(sed 's/ /+/' <<< $1)
pre=$"https://www.youtube.com/feeds/videos.xml?channel_id="
HTML=$(curl -s "https://www.youtube.com/results?search_query=$SEARCH&sp=EgIQAg%253D%253D")



# grabs the channel id needed for the rss feed
if [[ $HTML =~ (channelId)\":.{25} ]]; then
  ID=$"'${BASH_REMATCH[0]}'"
fi
ID=${ID:13:24}
RSS_URL="$pre$ID"
XML=$(curl -s $RSS_URL)


# gets the name of the channel, I hope to find a better way...
if [[ $XML =~ name.{25} ]]; then
  ID=$"'${BASH_REMATCH[0]:5}'"
fi
IFS='/'; NAME=($ID); unset IFS;
NAME="${NAME::-1}"
NAME="${NAME:1}"



INSERT=$"$RSS_URL Youtube \"~$NAME\""

FILE=~/.newsboat/urls
if test -f "$FILE"; then
    echo $INSERT >> $FILE
    echo "inserted $NAME's  youtube channel to  $FILE."
fi

