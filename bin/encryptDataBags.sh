#!/bin/sh
#set -x
#  knife solo data bag edit apache_ssl encrypttest --secret-file .secret
#  
# This will not work with upgrade to new chef version.... Said Scott

#DB_DIRS="apache_ssl crowd db_users mysql jmh_archiva postfix deploy_keys broker/secure.json \
		#operations/secure.json operations/subversion.json apache_ssl/jmh_internal_cert_2024.json \
		#jmh_apps/apptapi-secure.json jmh_apps/splunk-secure.json jmh_apps/cq.json \
		#jmh_apps/events.json jmh_apps/fad.json jmh_apps/myjmh.json jmh_apps/prereg-admin.json \
		#jmh_apps/preregistration.json jmh_apps/profile.json jmh_apps/trustcommerce-secure.json jmh_apps/zipnosis.json jmh_apps/pingfed.json"
		
#DB_DIRS="apache_ssl/www_johnmuirhealth_com_cert.json"
DB_DIRS="jmh_apps/vvisits-api.json"


decrypt=false
while [[ $# -ge 1 ]]
do
	key="$1"
	case $key in
	    -e|--encrypt)
	    decrypt=false
	    ;;
	    -d|--decrypt)
	    decrypt=true
	    ;;
	    -f|--secret-file)
	    secret_file="$2"
	    shift # past argument
	    ;;
	    -h|--help)
		echo "Usage:"
  		echo "  encryptDataBags.sh -e -f <secret file> #encrypt"
  		echo "  encryptDataBags.sh -d -f <secret file> #decrypt"
  		exit 1
	    ;;
	esac
	shift
done


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

DATABAG_DIR=$CHEFDIR/data_bags


cd $CHEFDIR

if [ -z "$secret_file" ]
then
  secret_file=$CHEFDIR/.secret
fi

echo "decrypt is: $decrypt"
echo "secret file is $secret_file"


for databag in $DB_DIRS
do
	echo $databag
	specific_db=""
	if [ `echo $databag | fgrep "/"` ]
	then
		specific_db=`echo $databag | cut -d"/" -f2`
		databag=`echo $databag | cut -d"/" -f1`
		#echo $specific_item
	fi 
	cd $DATABAG_DIR/$databag
	db_item=`ls`
	if [ -n "$specific_db" ]
	then
		db_item=$specific_db
	fi
		
	for databagitemfile in $db_item
	do
		databagitem=`echo $databagitemfile | cut -d"." -f1`
		echo "  $databagitemfile"
		RESULT=`grep "encrypted_data" $databagitemfile`
		if [ $? -eq 0 ]
		then
		    if $decrypt
		    then 
		       echo "I will decrypt"
		       cd $CHEFDIR
		       knife data bag show $databag $databagitem --secret-file $secret_file -F json -z > $DATABAG_DIR/$databag/${databagitem}.tmp
		       ##knife solo data bag show $databag $databagitem --secret-file $secret_file -F json -z > $DATABAG_DIR/$databag/${databagitem}.tmp
		       mv -f $DATABAG_DIR/$databag/${databagitem}.tmp $DATABAG_DIR/$databag/${databagitem}.json
		       cd $DATABAG_DIR/$databag
		    else 
			  echo "    *Encrypted*"
			fi
		else
			if $decrypt
			then
				echo "    *Decrypted*"
			else
				cd $CHEFDIR
				knife data bag create $databag $databagitem data_bags/$databag/$databagitemfile --secret-file $secret_file -z --no-listen
				##knife solo data bag create $databag $databagitem --json-file data_bags/$databag/$databagitemfile --secret-file $secret_file  --data-bag-path ./data_bags -z
				cd $DATABAG_DIR/$databag  
			fi
		fi
		
	done
done
