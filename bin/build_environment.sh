#!/bin/sh
#set -x

#EPICENV=poc
EPICENV=tst
SERVERS="publisher author apps01 apps02 apps03"
#SERVERS="author apps01 apps02 apps03"
cd /Users/smarshal/gitrepo/chef-repo

for serverBuild in $SERVERS
do
  #echo $serverBuild
  if [ "${serverBuild}" == 'publisher' ]
  then
    CHEFROLE='role[base],role[mail_server]'
  elif [ "${serverBuild}" == "apps01" ] || [ "${serverBuild}" == "apps03" ] || [ "${serverBuild}" == "apps02" ]
  then
    CHEFROLE='role[base],recipe[jmh-db::server]'
  else
    CHEFROLE='role[base]'
  fi
  echo "knife ec2 server create ${serverBuild}-${EPICENV} -N ${serverBuild}-${EPICENV} -f t2.large -r "${CHEFROLE}" -E aws${EPICENV} -i .chef/pems/jmh_ebiz.pem --sudo -y"
  knife ec2 server create ${serverBuild}-${EPICENV} -N ${serverBuild}-${EPICENV} -f t2.large -r "${CHEFROLE}" -E aws${EPICENV} -i .chef/pems/jmh_ebiz.pem --sudo -y

  sleep 10
done
