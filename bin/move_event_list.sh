#!/bin/bash
#set -x 

AFile="jmh_events"
PFile="jmh_pub_events"

if [ -z $1 ]
then
        echo "AEM PROD Password needed, please enter as first command line argument!"
        exit 5
fi

AdminProdPass=$1

mkdir /tmp/aem_files_gen4
cd /tmp/aem_files_gen4

# build package then get package
# author-aem-prd01 http://192.168.113.70:4502/libs/cq/core/content/login.html
curl -u admin:$AdminProdPass -F name=${AFile} http://192.168.113.70:4502/crx/packmgr/service.jsp?cmd=build
sleep 5
curl -u admin:$AdminProdPass -o ${AFile}.zip http://192.168.113.70:4502/crx/packmgr/service.jsp?name="${AFile}"

# publisher01-aem-prd01 http://192.168.113.71:4503/content/jmh/en/home.html
curl -u admin:$AdminProdPass -F name=${PFile} http://192.168.113.71:4503/crx/packmgr/service.jsp?cmd=build
sleep 5
curl -u admin:$AdminProdPass -o ${PFile}.zip http://192.168.113.71:4503/crx/packmgr/service.jsp?name="${PFile}"	

# Put to author and publisher NEW
# author01-prd http://100.68.179.14:4502/libs/cq/core/content/login.html
curl -u admin:$AdminProdPass -F file=@${AFile}.zip -F name=${AFile} -F force=true http://100.68.179.14:4502/crx/packmgr/service.jsp?cmd=inst

# publisher01-prd http://100.68.179.13:4503/content/jmh/en/home.html
curl -u admin:$AdminProdPass -F file=@${PFile}.zip -F name=${PFile} -F force=true http://100.68.179.13:4503/crx/packmgr/service.jsp?cmd=inst

# publisher02-prd http://100.68.179.21:4503/content/jmh/en/home.html
curl -u admin:$AdminProdPass -F file=@${PFile}.zip -F name=${PFile} -F force=true http://100.68.179.21:4503/crx/packmgr/service.jsp?cmd=inst
