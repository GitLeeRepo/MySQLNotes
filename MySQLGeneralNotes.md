# Overview

Notes taken while learning/relearning MySQL

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
