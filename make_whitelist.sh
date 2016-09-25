#!/bin/bash


SENTMAIL="/home/alla/Mail/sent-mail"

for x in `grep -rs "^To:" $SENTMAIL |
        grep -o "[[:alnum:]\.\+\-\_]*@[[:alnum:]\.\-]*" |
        tr "A-Z" "a-z" |
        sort -u` ;
        
        do echo "whitelist_from $x" >> /home/alla/.spamassassin/whitelist_from.txt
done
