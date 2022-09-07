#!/bin/bash
set -x

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

EC2_INFO=`knife ec2 server list | grep running | grep $1 | head -1`
ec2server=`echo $EC2_INFO | cut -d" " -f1`
ec2node=`echo $EC2_INFO | cut -d" " -f2`

if [[ $ec2node == $1 ]]
then
  knife node -y delete $1
  knife client -y delete $1
  knife ec2 server delete $ec2server -y
else
  echo "UNIQUE NODE NOT FOUND, NOT DELETING"
fi

