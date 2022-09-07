#!/bin/bash

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

if [ -z $1 ]
then
        echo "Need a name, dude"
        exit 5
fi
knife node -y delete $1
knife client -y delete $1