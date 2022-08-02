#!/bin/bash

search_term=$(sed 's/ /+/g' <<< "$1")
html=$(curl -s https://yewtu.be/search?q="$search_term")
channel_info=$(echo "$html" | sed '/<a href="\/channel\//,$!d' | head -n 10)
channel_id=$(echo "$channel_info" | grep channel | awk -F"/" '{print $NF}' | sed 's/..$//')
channel_name=$(echo "$channel_info" | grep auto | cut -d ">" -f2 | cut -d "&" -f1)

yt_url="https://www.youtube.com/feeds/videos.xml?channel_id="
insert_text=$"$yt_url$channel_id \"~"$channel_name"\" YouTube"
conf_file="$HOME/.config/newsboat/urls"

if [ -f "$conf_file" ]; then
  echo "$insert_text" >> "$conf_file" && echo "Appended $conf_file"
else
  echo "Please create $conf_file"
fi

