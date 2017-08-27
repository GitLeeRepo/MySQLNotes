# Overview

Notes taken while learning/relearning MySQL

# Installation

* `sudo apt-get update`
* `sudo apt-get install mysql-server`
* `sudo mysql_secure_installation`

## Verifying Installation

* `systemctl status mysql.service` This will display its status.  If it is not running type: `sudo systemctl start mysql`

## Version info

* `mysqladmin -p -u root version`  This will display version and other useful information.


# Reset password of a user including root

```MySQL
mysql -u root -p

use mysql;
SET PASSWORD FOR root@localhost = PASSWORD('newpassword');
flush privileges;
```

# Alter Table

## Changing a column name and type

For a table called [name], change the column name from [first] to [firstname]

```MySQL
ALTER TABLE `name` CHANGE COLUMN `first` `firstname` VARCHAR(40) NULL;
```
