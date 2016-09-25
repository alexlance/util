#!/usr/bin/python
import os
import sys
import pyinotify
import threading
import time
import re


# When a file is changed, add it to the queue of changed files
# Every 2 minutes, commit locally
# After 15 minutes push remotely

# The directory to archive
dir="/home/alla/archiver"

# Global var stores the stack of files to be added, removed or modified
files = []

# The local committer sets this variable, and subsequently triggers the remote push
triggerRemotePush = False
triggerLocalCommit = False
threadSafeCounter = 0

# Global var has a list of file to ignore
ignore = ['^'+dir+'/.git($|/.*)'
         ,'^'+dir+'/tmp($|/.*)'
         ]

class FileTracker(pyinotify.ProcessEvent):

  def file_good(self,file):
    global ignore
    for regex in ignore:
      if re.search(regex,file):
        return False
    return True

  def process_IN_CREATE(self, event):
    f = os.path.join(event.path, event.name)
    if self.file_good(f):
      global files
      files.append(f)
      global triggerLocalCommit
      triggerLocalCommit = True

  def process_IN_DELETE(self, event):
    f = os.path.join(event.path, event.name)
    if self.file_good(f):
      global triggerLocalCommit
      triggerLocalCommit = True

  def process_IN_MODIFY(self, event):
    f = os.path.join(event.path, event.name)
    if self.file_good(f):
      global files
      files.append(f)
      global triggerLocalCommit
      triggerLocalCommit = True


class WatchDirectory(threading.Thread):

  # Watch a dir and log changes
  def run (self):
    wm = pyinotify.WatchManager()
    mask = pyinotify.IN_DELETE | pyinotify.IN_CREATE | pyinotify.IN_MODIFY
    ft = FileTracker();
    notifier = pyinotify.Notifier(wm, ft)
    wdd = wm.add_watch(self.dir, mask, rec=True, auto_add=True)

    while True:
      try:
        notifier.process_events()
        if notifier.check_events():
          notifier.read_events()
      except KeyboardInterrupt:
        notifier.stop()
        break

 
class LocalCommit(threading.Thread):

  # Run a local commit every 2 minutes
  def run(self):
    global files
    global triggerLocalCommit
    global triggerRemotePush
    global threadSafeCounter
    while True:
      time.sleep(2) # change to 120 (2min)
      if triggerLocalCommit:
  
        # Copy files[] to new memory and note how many items are
        # in the copy. Next time this method is called, the
        # threadSafeCounter will ensure that we pick-up from where we
        # left off in files[]
        files_copy = files[threadSafeCounter:]
        threadSafeCounter = len(files_copy) + threadSafeCounter

        # Performs: git add "file1" "file2"
        print 'git add %s' % '"' + '" "'.join(unique(files_copy))+'"'
        
        # time.sleep(30) fake a delay
        # print "Files:", files ... oh noes more files got loaded up!
        #
        # If the commit takes a significant amount of time, then
        # the files[] list may get loaded up with additional filesystem
        # changes, so we may need to re-enter this method (to `git add`
        # the new items in files[]) by leaving the triggerLocalCommit
        # value set to True.
        if len(files) == len(files_copy) + threadSafeCounter:
          # Once the changes have settled down we can run a commit
          print 'git commit -a -m "Local commit."'
          triggerLocalCommit = False
          triggerRemotePush = True


class RemotePush(threading.Thread):

  # Push patches to a remote repo every 15 minutes
  def run(self):
    global files
    global triggerRemotePush
    while True:
      time.sleep(7) # change to 900 (15min)
      if triggerRemotePush:
        print "git push"
        print "counter: %s" % threadSafeCounter
        triggerRemotePush = False


def unique(seq): 
  # Not order preserving 
  keys = {} 
  for e in seq: 
    keys[e] = 1 
  return keys.keys()


# Fire up three threads
try:

  # 1. Monitor a directory in real time using inotify
  thread1 = WatchDirectory()
  thread1.dir = dir
  thread1.daemon = True
  thread1.start()

  # 2. Local git commit any file changes every 2min
  thread2 = LocalCommit()
  thread2.dir = dir
  thread2.daemon = True
  thread2.start()

  # 3. Push git patches remotely every 15min
  thread3 = RemotePush()
  thread3.dir = dir
  thread3.daemon = True
  thread3.start()

  # permits keyboard interrupt
  while True: time.sleep(100) 

except KeyboardInterrupt:
  sys.exit()



