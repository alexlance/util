#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 SOURCEDIRECTORY MAXWIDTH"
  echo "Eg: $0 the_images/ 200" 
  echo "This will create the_images_gallery with the website gallery inside and index.html file inside."
  exit 1
fi

pwd=$(pwd)
pwd=${pwd%/}
g=${1%/}_gallery

if [ ! -d "$g" ]; then 
  mkdir $g && echo "Created $g/"
else
  echo "$g already exists, remove it and try again."
  exit 1
fi

echo "Creating images in $g of max ${2}px in width."

cd $1


# create a resized version of the images.
find ./ -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.gif \) -exec convert -format jpg -scale "${2}x>" {} ${pwd}/${g}/{} \;

cd ${pwd}/${g}

# write out an index.html file
echo -e "<html>\n<head></head>\n<body>\n\n" > ${pwd}/${g}/index.html
find ./ -type f | sort -V | grep -v index.html | xargs -I{} echo -e "<img src='{}'>\n<br>" >> ${pwd}/${g}/index.html
echo -e "</body>\n</html>" >> ${pwd}/${g}/index.html
echo "Wrote ${pwd}/${g}/index.html"
