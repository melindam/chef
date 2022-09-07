# --DEPRECATED--

The Broker app used to collect zipnosis appointments was deprecated on July 23, 2019  


# NOTE for passwords

By default the passwords for activeMQ will be a secure password. 
If you would like to hard code values, we have them set in the environment file.

If the environment does not have the passwords - the node will have them.

```
    "activemq": {
      "admin_console": {
        "credentials": {
          "password": "My.New_Password"
        }
      },
      "web_console": {
        "system_password": "My.New_Password"
      },
      "simple_auth_password": "My.New_Password"
    }
    
```




