# 0.4

## 0.4.3

- upgraded java for 8, 11, 15
- removed java13

## 0.4.2

- included Java 15 as Oracle Open JDK
- upgraded java for 8 & 11

## 0.4.1

- creation of `['jmh_java'][['java_hash']` so we can change a java_version per environment/node easier.
- upgraded java for 8 & 11
- removal of java deprecated code

## 0.4.0

- removed java cookbook (multiple oracle installs seems to be deprecated)
- added java 11

# 0.3

## 0.3.0

- including java 13
- upgrading java 8 to 241

# 0.2

## 0.2.14

- added the `java_security/jdk.json` data bag for certs for specific jdk's
- started the move to jdk 12

## 0.2.13

- upgrade to java 201

## 0.2.12

- upgrade of java 8 to 191

## 0.2.11

- added `JmhJavaUtil.get_java_certs(node)` so we get certs to install into java the same way

## 0.2.10

- upgrade java 8 to 161

## 0.2.9

- Moved all certs to a databag

## 0.2.8

- fixing java cookbook default. Is now set to 8

## 0.2.7

- added new mychart build cert - expires on 2022

## 0.2.6

- added new cert for mychart - expires in 2027

## 0.2.5

- java 8 upgrade to latest 131

## 0.2.4

- included epicmychartprd.hsys.local cert install

## 0.2.3

- updated java versions
- install mychartXV certs
