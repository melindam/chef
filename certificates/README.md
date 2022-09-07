# Private Keys
## Create a Private Key and CSR
```
cd private
openssl req -newkey rsa:4096 -nodes -sha256 -keyout johnmuirhealth.com.key -out ../csr/<server name>.johnmuirhealth.com.csr
```

_Note: New certs are created differently_ 
(http://stackoverflow.com/questions/17733536/how-to-convert-a-private-key-to-an-rsa-private-key)
```
cd private
openssl rsa -in server.key -out server_new.key
```
## Create A Private Key with a passphrase

```
cd private
openssl genrsa -des3 -rand file1:file2:file3 -out johnmuirhealth.com.key 4096
```
## Create a Private Key without a passphrase (recommended)

```
cd private
openssl genrsa -out johnmuirhealth.com.key 4096
```

# Certificate Signing Requests (CSR)
## Create the CSR

1. Start the Cert
    ```
    cd csr
    openssl req -new -key ../private/johnmuirhealth.com.key -out <server name>.johnmuirhealth.com.csr
    ```
1. Answer the questions
 * Country Name (2 letter code) [AU]: **US**
 * State or Province Name (full name) [Some-State]: **California**
 * Locality Name (eg, city) []: **Walnut Creek**
 * Organization Name (eg, company) [Internet Widgits Pty Ltd]: **John Muir Health**
 * Organizational Unit Name (eg, section) []: **EBusiness**
 * Common Name (eg, YOUR name) []: **\<name of cert\>**
 * Email Address []: **ebusiness@johnmuirhealth.com**
 * A challenge password []:
 * An optional company name []:

# Certificate Conversions 
## Create PFX for IIS Server 
*Note.Finished Certs are no longer kept here in the repo*
1. Download certs in Apache format from GoDaddy
1. Decrypt private key with chef-repo/certificates/private/decrypt.sh
1. Create output of PFX type
    ```
    openssl pkcs12 -export -out ~/Desktop/jmhconnect.net.pfx -inkey ./private/jmhconnect.net.key -in ./finished_certs/jmhconnect.net/jmhconnect.net.crt -certfile <chainfile>
    ```
## DER to PEM

- To DER from PEM
```
openssl x509 -outform der -in your-cert.pem -out your-cert.crt
```
- To PEM from DER
```
openssl x509 -outform pem -in your-cert.pem -out your-cert.crt


# Validation
```
openssl x509 -noout -modulus -in certificate.crt | openssl md5
openssl rsa -noout -modulus -in privateKey.key | openssl md5
openssl rsa -noout -modulus -in public_key.pub -pubin | openssl md5
openssl req -noout -modulus -in CSR.csr | openssl md5
```

# Self-signed certs

## Using Openssl
``
openssl x509 -req -days 360 -in <server name>.johnmuirhealth.com.csr  -signkey ../private/johnmuirhealth.com.key -out <server name>.johnmuirhealth.com.crt
``
## Using Java
```
/usr/lib/jvm/java/jre/bin/keytool -genkey -alias crowd2027 -keyalg RSA
Enter keystore password:   ** Use a passphrase you will need to import into keystore with **
Re-enter new password:    
What is your first and last name?  ** This will be what you want to connect to host as its hostname **
  [ ]:  crowd.jmh.internal
What is the name of your organizational unit?
  [ ]: John Muir Health
What is the name of your organization?
  [ ]: ebusiness  
What is the name of your City or Locality?
  [ ]: Walnut Creek
What is the name of your State or Province?
  [ ]: CA  
What is the two-letter country code for this unit?
  [ ]: US  
Is CN=crowd.jmh.internal, OU=John Muir Health, O=ebusiness, L=Walnut Creek, ST=CA, C=US correct?
Enter key password for <crowd2027>
	(RETURN if same as keystore password):  ** same as password above **
-> This creates a .keystore file which you use AS they keystore for the application (e.g. crowd uses for its SSL keystore)
```

# Create your own Certificate of Authority(CA)

1. Create a RSA private key for your server (will be Triple-DES encrypted and PEM formatted)
    ```
    openssl genrsa -des3 -out server.key 1024
    ```
1. Please backup this host.key file and the pass-phrase you entered in a secure location. You can see the details of this RSA private key by using the command
    ```
    openssl rsa -noout -text -in server.key
    ```
1. If necessary, you can also create a decrypted PEM version (not recommended) of this RSA private key with:
    ```
    openssl rsa -in server.key -out server.key.unsecure
    ```
1. Create a self-signed Certificate 10 year expiration (X509 structure) with the RSA key you just created (output will be PEM formatted):
    ```
    openssl req -new -x509 -nodes -sha1 -days 3650 -key server.key -out server.crt
    ```
    This signs the server CSR and results in a server.crt file.

# LDAP Certs
```
openssl genrsa -out ldap.key
openssl req -new -key ldap.key -out ldap.csr
openssl x509 -req -days 1095 -in ldap.csr  -signkey ldap.key -out ldap.cert
```

# Encrypting/decrypting keys
**Encrypt**
```
cd private
sh encrypt_keys.sh <Path to Passfile>
```
**Decrypt**
```
cd private
sh decrypt_keys.sh <Path to Passfile>
```
