# Command  to run that encrypted this file
openssl aes-256-cbc -a -salt -in node-output.txt -out node-output.txt.enc -kfile <passfile>

# Command to run that will unencrypt this file
openssl aes-256-cbc -a -salt -d -in node-output.txt.enc -out node-output.txt -kfile <passfile>

