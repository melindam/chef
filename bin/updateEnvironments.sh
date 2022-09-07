#!/bin/sh
#set -x

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
cd $CHEFDIR

echo "Gathing list of chef environments..."
ENVIRONMENTS=`knife environment list`

for envmt in $ENVIRONMENTS
do
  if [ $envmt != "_default" ]
  then
        echo "Creating JSON for $envmt"
	knife environment show $envmt -F json > ./environments/$envmt.json
  fi
done

