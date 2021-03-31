#!/bin/bash
# Script downloading content for all m3u-files found in current directory

# prerequisites: install id3v2 to set id3-tag

# set logfile
LOGFILE="dlm3u.log"

# Functions

# ================ function dlm3u: download all mp3s found in all lines of all m3u-files =====
dlm3u () {
  for playlist in *.m3u; do
        logtext "Processing $playlist"
        declare -i lines=$(wc -l < $playlist)
        declare -i songs=($lines-1)/2

        SEP=$IFS
        IFS="/"
        read -a array <<< "$(head -1 $playlist)"
        IFS=$SEP
        album="${array[4]}"
        logtext "Scanning album $album"
        mkdir "$album"

        for ((song = 1; song <= $lines; song++)); do
                songtitle="$(awk "NR==$song {print}" $playlist)"
                logtext "============================================="
                logtext "Full Songtitle: $songtitle"
# trim songtitle
                songtitle=$(echo $songtitle | sed "s/^[^ ]* //")
                logtext "Trimmed songtitle $songtitle"
                songlink=$(sed "${song}q;d" $playlist)
                logtext "Songlink: $songlink"
                if [ ! -f "$album/$songtitle" ]; then
                    logtext "Downloading file!"
                    wget -O "$album/$songtitle" --tries==5 "$songlink"
# check for success
                  if [ $? -eq 0 ]; then
                    logtext "Download $song $songtitle OK"
                  else
                    logtext "Download $song $songtitle FAILED"
                    LIMIT=1000
                    FILESIZE=$(stat -c %s "$album/$songtitle")
                    if [ $FILESIZE -lt $LIMIT ]
                    then
                        logtext "File $songtitel seems empty/corrupt --> delete"
                        rm "$album/$songtitle"
                    else
                        logtext "File $songtitel seems OK  --> NO delete"
                    fi
                  fi
                else
                    logtext "File exists!"
                fi
                logtext "Processing complete:  $song $songtitle"
# set id3-tag album             
                id3v2 --album "$album" "$album/$songtitle"
        done

        logtext "Done!"
        logtext " "
  done
}


# ===================== function logtext ======================================
# function for writing text to logfile
logtext () {
   echo "`date`: " $1 2>&1 | tee -a $LOGFILE
}

# ============================ MAIN ===================================

rm $LOGFILE
STARTDIR=$(pwd)
logtext "Starting downloading m3us from $STARTDIR"
logtext  "==================  Starting==================  "
cd $STARTDIR
logtext "starting at dir: $STARTDIR"
dlm3u

exit 0

# End of Main


# EOF
