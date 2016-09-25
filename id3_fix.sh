#!/bin/bash


  # We are being called with an DIR, ARTIST, ALBUM and TITLE/FILE
  if [ "${1}" != "" ] && [ "${2}" != "" ] && [ "${3}" != "" ] && [ "${4}" != "" ]; then
    #echo "DIR: ${1} ARTIST: ${2} ALBUM: ${3} FILE: ${4}"

    if [ -f "${4}" ]; then 
      echo "##################################################################################################"
      echo 
      echo "BEFORE"
      echo "~~~~~~"
      id3v2 -l "${4}"

      NEWTITLE=`basename "${4}" | tr "_" " " | sed -e "s/.mp3//g"`
      echo
      sel1="Change Artist, Album and Title?"
      sel2="Change Artist and Album?"
      sel3="Change Title?"
      sel4="Type in Title?"
      sel5="Change Artist and Album and rename file/Title?"
      
      select ACTION in "${sel1}" "${sel2}" "${sel3}" "${sel4}" "${sel5}"; do
        if [ "$REPLY" -eq "1" ]; then
          id3v2 -A "${3}" "${4}"
          id3v2 -a "${2}" "${4}"
          id3v2 -t "${NEWTITLE}" "${4}"
        elif [ "$REPLY" -eq "2" ]; then
          id3v2 -A "${3}" "${4}"
          id3v2 -a "${2}" "${4}"
        elif [ "$REPLY" -eq "3" ]; then
          id3v2 -t "${NEWTITLE}" "${4}"
        elif [ "$REPLY" -eq "4" ]; then
          echo -n "Please enter the new Title: "
          read NEWTITLE;
          id3v2 -t "${NEWTITLE}" "${4}"
        elif [ "$REPLY" -eq "5" ]; then
          id3v2 -A "${3}" "${4}"
          id3v2 -a "${2}" "${4}"
          echo -n "Please enter the new filename: "
          read NEWTITLE;
          file="`echo ${NEWTITLE} | tr \" \" \"_\"`" # swap space to underscore
          if [ "`echo \"${file}\" | grep \".mp3\"`" = "" ]; then file="${file}.mp3"; fi;
          mv "${4}" "${file}"
          id3v2 -t "`echo ${NEWTITLE} | tr \"_\" \" \"`" "${file}" # and set the title (with underscores stripped out)
        fi      
        break
      done;
      
      echo 
      echo "AFTER"
      echo "~~~~~"
      if [ -f "${4}" ]; then id3v2 -l "${4}"; elif [ -f "${file}" ]; then id3v2 -l "${file}"; fi;
      echo
    fi

# If passed one argument
elif [ "${1}" != "" ]; then

  # If it's a file
  if [ -f "${1}" ]; then DIR=`dirname "${1}"`

  # Else if it's a directory
  elif [ -d "${1}" ]; then DIR=${1}

  # Else error!
  else echo "Error not passed a directory or file: ${1}"; exit; fi 

  # Validation on ${DIR}
  if [ ! -d "${DIR}" ]; then
    echo "Error not a directory: ${DIR}"
    exit;
  fi

  # Validation on ${DIR}
  if [ "`echo \"${DIR}\" | grep \"_-_\"`" = "" ]; then
    echo "Error name does not contain: _-_ (to determine Artist and Album)" 
    exit;
  fi


  # If it has the string _-_ then separate it into album and artist, also swap the _ / for spaces
  ARTIST=`echo "${DIR}" | tr _/ " " | sed -e "s/-.*//g"`
  ALBUM=`echo "${DIR}" | tr _/ " " | sed -e "s/.* - //g"`

  if [ "${ARTIST}" != "" ] && [ "${ALBUM}" != "" ]; then
    echo "Artist: ${ARTIST} Album: ${ALBUM}" 
    cd "${DIR}"

    # If only one file 
    if [ "${1}" != "" ] && [ -f "`basename \"${1}\"`" ]; then
      ../$0 "${DIR}" "${ARTIST}" "${ALBUM}" "`basename \"${1}\"`"

    # If operate on whole directory
    else
      find . -exec ../$0 "${DIR}" "${ARTIST}" "${ALBUM}" "{}" \;
    fi
    cd ..
  else
    echo "Artist: ${ARTIST} Album: ${ALBUM}" 
    echo "Error unable to determine ARTIST and ALBUM from directory: ${DIR}"
  fi
fi

