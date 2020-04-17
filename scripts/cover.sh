#!/bin/bash

id_current=$(cat ~/.conky/conky-spotify/current/current.txt)
id_new=`~/.conky/conky-spotify/scripts/id.sh`
cover=
imgurl=

if [ "$id_new" != "$id_current" ]; then

	cover=`ls ~/.conky/conky-spotify/covers | grep $id_new`

	if [ "$cover" == "" ]; then

	    imgurl=`~/.conky/conky-spotify/scripts/imgurl.sh $id_new`
	    wget -q -O ~/.conky/conky-spotify/covers/$id_new.jpeg $imgurl &> /dev/null
	    # sets last modified date to current time
	    touch ~/.conky/conky-spotify/covers/$id_new.jpeg
		# clean up covers folder, keeping only the latest X amount
	    rm -f `ls -t ~/.conky/conky-spotify/covers/* | awk 'NR>10'`
	    # rm wget-log #wget-logs are accumulated otherwise
	    # rm `ls -t | awk 'NR>5'`
	    cover=`ls ~/.conky/conky-spotify/covers | grep $id_new`
	fi

	if [ "$cover" != "" ]; then
		cp ~/.conky/conky-spotify/covers/$cover ~/.conky/conky-spotify/current/current.jpeg
	else
		cp ~/.conky/conky-spotify/empty.jpg ~/.conky/conky-spotify/current/current.jpeg
	fi

	echo $id_new > ~/.conky/conky-spotify/current/current.txt
fi
