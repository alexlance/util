set -e
set -x

if [ -z "$1" ]; then
  echo "$0 /path/to/music_folder"
  echo "Make sure there are no spaces or funny characters in the folder/file name"
else
  adb shell "mkdir /sdcard/Music/$(basename "$1")/"
  adb push $1 /sdcard/Music/$(basename "$1")/
fi

