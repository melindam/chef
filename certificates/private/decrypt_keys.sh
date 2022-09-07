#!/bin/sh

# Author: Scott Marshall
# Desc: Used to decrypt the key files in our repo
# passfile is bitbucket /operations/misc/led_zepplin.txt

if [ -z $1 ]
then
	echo "Usage: decrypt_keys.sh <passfile>"
	exit 1
fi


#CERTS=`ls | grep .enc$`
CERTS="www.johnmuirhealth.com.key.enc"

for certfile in $CERTS
do
	echo "Now decrypting $certfile"
	openssl aes-256-cbc -a -salt -d -in ${certfile} -out ${certfile:0:${#certfile} - 4} -kfile $1
done
