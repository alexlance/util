#!/bin/bash 

# Create a file that just has the file sizes and the file paths
if [ ! -f fd_1 ]; then
  #find . -type f -printf "%s %p\n" -regextype posix-extended -not -regex ".*(_darcs|\.darcs|portage)/.*" > fd_1
  echo "  * Gathering all files to fd_1 ..." 
  find . -type f -printf "%s %p\n" > fd_1
fi

# Sort the results
if [ ! -f fd_2 ]; then
  echo "  * Sorting files into fd_2 ..." 
  sort -n fd_1 > fd_2
fi

# Discard all files under 10MB in size
if [ ! -f fd_3 ]; then
  echo "  * Discarding small files (<10MB) into fd_3 ..." 
  awk '$1 > 10240000' fd_2 > fd_3
fi

# Discard all the uniquely sized files
if [ ! -f fd_4 ]; then
  echo "  * Discarding unique entries, the dupes go to fd_4 ..." 
  awk -- 'BEGIN { FS = " " } { count[$1]++; if (count[$1] == 1) { first[$1] = $0; } if (count[$1] == 2) { print first[$1]; } if (count[$1] > 1) { print } }' fd_3 > fd_4
fi

# Reverse the list to put the largest files first
if [ ! -f fd_5 ]; then
  echo "  * Reversing list into fd_5 ..." 
  sort -n --reverse fd_4 > fd_5
fi



if [ ! -f fd_6 ]; then

echo "#!/bin/bash -x" > fd_6
chmod a+x fd_6

siz=0
fil=""

echo "  * Printing ln for files into fd_6 ..." 
while read line; do
  size=${line%% *}
  file=${line#* }

  if [ "${siz}" = "${size}" ]; then
    echo "$fil"
    echo "$file"
 
    # get the current inodes of the files
    sf1=$(stat -c %i "$file")
    sf2=$(stat -c %i "$fil")
  
    if [ "${sf1}" != "${sf2}" ]; then
     
      # diff each file
      echo -n "  * diffing..." 
      d=$(diff -q "$file" "$fil")
      if [ -z "${d}" ]; then
        # hardlink the identical files
        echo "LINKING"
        echo ln -f "$fil" "$file"
        echo ln -f "\"$fil\"" "\"$file\"" >> fd_6
      else
        echo "files are different"
      fi
    else
      echo "  * inodes already match"
    fi
  fi
  
  siz=$size
  fil=$file
done < "fd_5"

fi
