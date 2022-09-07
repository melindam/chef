#!/bin/bash

if [ -z ${2} ]
then 
  echo "Usage: ${0} [chef_environment] [uptime|updates|reboot|rm-oldkernels]"
  exit 2
else
  case ${2} in
  uptime)
      knife ssh "chef_environment:${1}" "sudo uptime" -x melindam -i ~/.ssh/id_rsa -A
    ;;
  updates) 
    knife ssh "chef_environment:${1}" "sudo yum update -y --security; sudo yum update -y kernel" -x melindam -i ~/.ssh/id_rsa -A
    ;;
  reboot)
      knife ssh "chef_environment:${1}" "sudo /usr/sbin/reboot" -x melindam -i ~/.ssh/id_rsa -A
    ;;
  rm-oldkernels)
     knife ssh "chef_environment:${1}" "sudo package-cleanup --oldkernels --count=1" -x melindam -i ~/.ssh/id_rsa -A
    ;;
  esac
fi
