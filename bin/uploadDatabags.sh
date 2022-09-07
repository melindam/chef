#!/bin/sh
#set -x
# Description:  will upload all encrypted data bags

CHEFDIR=`pwd`
if [[ $CHEFDIR != *chef-repo ]]
then
    CHEFDIR=`dirname $CHEFDIR`
fi
if [[ $CHEFDIR != *chef-repo ]]
then
    echo "You need to be in the chef-repo folder for this to run!"
    exit 1
fi
cd $CHEFDIR/data_bags

DB_DIRS=`find . -type f -name "*.json" -print`

for databag in $DB_DIRS
do
	cd $CHEFDIR/data_bags
	#echo $databag
	fgrep -q "encrypted_data" $databag
	if [ $? == 0 ]
	then
        specific_db=""
        if [ `echo $databag | fgrep "/"` ]
        then
            specific_db=`echo $databag | cut -d"/" -f3`
            databag=`echo $databag | cut -d"/" -f2`
            #echo $specific_item
        fi
        cd $databag
        db_item=`ls`
        if [ -n "$specific_db" ]
        then
            db_item=$specific_db
        fi
        for databagitemfile in $db_item
        do

            databagitem=`echo $databagitemfile | cut -d"." -f1`
            #echo "$databag  $databagitemfile"
            echo "knife data bag from file $databag $databagitemfile"
            `knife data bag from file $databag $databagitemfile`
        done
    else
        echo "*SKIPPING $databag"
    fi

done
