#!/usr/bin/env bash
languages=`echo "golang lua cpp c typescript nodejs python" | tr ' ' '\n'`
core_utils=`echo "awk xargs find sed " | tr ' ' '\n'`

selected=`printf "$languages\n$core_utils" | fzf`
read -p "query: " query

if printf $languages | grep -qs $selected; then
	tmux neww bash -c "curl cht.sh/$selected/`echo $query | tr ' ' '+'` & while [ : ]; do sleep 1; done"
else
	tmux neww bash -c "curl cht.sh/$selected~`echo $query | tr ' ' '+'` & while [ : ]; do sleep 1; done"
fi
