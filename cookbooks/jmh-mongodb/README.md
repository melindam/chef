# jmh-mongodb
Uses sc-mongodb from chef.io community to create default single instance and users

### Syntax

#### Test instance was created
```
mongo admin -u admin -p melinda --eval "printjson(db.adminCommand('listDatabases'))"
```

To Create DB and User
- To create DB 'vv' and add user will only result in the dbs to be created, and not seen
- You must insert data into 'vv' collection to see dbs name 'vv' when running ```show dbs```

#### List collections 

```
mongo admin -u admin -p melinda
use vv
db.SomeValue.insert({valueOne: "that Value"})
db.getCollectionNames()
db.SomeValue.find()
db.getCollection('SomeValue').find({}).forEach(printjson)

```

### Example of DB users 
```
override['mongodb']['users'] = [ 
  {
    'username' => 'user1',
    'password' => 'myPassword123',
    'roles' => %w( readWrite ),
    'database' => 'admin'
  },
  {
   'username' => 'user_for_app',
   'password' => 'AppPassword123',
   'roles' => %w( readWrite ),
   'database' => 'DbName'
   }
]
```


### Authentication
```
use VideoVisits
db.auth( "vvisits", "thePassWord" )
```


### Restore DB
```
mongorestore -vv --host "localhost:27017" --username admin --password ${PASSWD} \\
  --authenticationDatabase admin --db=${DB_NAME} --gzip --archive=${FileName}
```