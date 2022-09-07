#!/bin/sh

# Author: Scott Marshall
# Desc: Used to encrypt the key files in our repo and then delete the source file

if [ -z $1 ]
then
	echo "Usage: encrypt_keys.sh <passfile>"
	exit 1
fi


CERTS=`ls | grep .key$`

for certfile in $CERTS
do
	echo "Now encrypting $certfile"
	openssl aes-256-cbc -a -salt -in ${certfile} -out ${certfile}.enc -kfile $1
	rm $certfile
done

