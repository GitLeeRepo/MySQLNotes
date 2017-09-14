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

# Show Commands

* `SHOW COLUMNS FROM [<db>.]<table>` - display the tables column structure (col name, type, null, key, default, extra).  Equivellent to the `describe <table>` command.  For coalation and operation privileges use `SHOW FULL COLUMNS FROM [<db>.]<table>`.

* `SHOW CREATE TABLE [<db>.]<table>` - display the CREATE statement used to create the table, this includes the engine, current increment number, and character set.

* `SHOW DATABASES` - display a list of databases.

* `SHOW GRANTS [FOR <user>]` - show the grant privelleges for a particular user, if the `FOR <user>` is not specified it is for the current user.

* `SHOW INDEX FROM [<db>.]<table>` - display the tables indexes.

* `SHOW TABLES` - display a list of tables in the current database.


# Alter Table

## Changing a column name and type

For a table called [name], change the column name from [first] to [firstname]

```MySQL
ALTER TABLE `name` CHANGE COLUMN `first` `firstname` VARCHAR(40) NULL;
```
# Setting up MySQL connectivity in python3

Python3 needs the mysql-connector module to interact with MySQL databases

* `sudo apt-get install python3-mysql.connector`

Here's an example of a simple python3 (works in 2 also but that's a different install above) script for connecting to a MySQL database

```python

import mysql.connector

cnx = mysql.connector.connect(user='root', password='xxxxxx',
                              host='127.0.0.1',
                              database='test')
cnx.close()

```
# Checking and Setting Configurations

## Creating a user and granting access privileges

* To create a user with both localhost access and access from all other hosts:

```mysql
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'username'@'%' IDENTIFIED BY 'password';
```
* To grant them all privileges on a specific database:

```mysql
GRANT ALL ON dbname.* TO 'username'@'localhost';
GRANT ALL ON dbname.* TO 'username'@'%';
```

* To grant them all priveleges on a all databases:

```mysql
GRANT ALL ON *.* TO 'username'@'localhost';
GRANT ALL ON *.* TO 'username'@'%';
```
Note: Specifying the localhost in addition to the wildcard above is necessary if there is an anonymous user on the local host, since its settings will take precedence when connecting from the local host.  Refer to the [MySQL Reference Manual for details](https://dev.mysql.com/doc/refman/5.7/en/adding-users.html).
* Reloading Grant changes (not necessary here):

The following is often mentioned, but not necessary when changes are made with the GRANT command.  It is necessary however if the grants are updated directly in the database:

```mysql
FLUSH PRIVILEGES;
```

## Allowing remote access to MySQL

1. Edit the `/etc/mysql/mysql.conf.d/mysqld.cnf` file changing the bind-address from 127.0.0.0 to 0.0.0.0:

```mysql
bind-address        = 0.0.0.0
```

Note this allows remote access from any host, to specify a particular host use its ip instead of 0.0.0.0

2. Set up the desired users to have remote access privileges

Refer to the [Creating a user and granting access privileges](MySQLGeneralNotes.md#creating-a-user-and-granting-access-privileges) section above, with the key part being the allowing of remote hosts (through the `%` wildcard) when creating the user and granting access privileges, i.e:

```mysql
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'username'@'%' IDENTIFIED BY 'password';
GRANT ALL ON *.* TO 'username'@'localhost';
GRANT ALL ON *.* TO 'username'@'%';
```

3. Restart MySQL

```mysql
sudo systemctl restart mysql.service
```
4. Verify it is listening on all interfaces (i.e 0.0.0.0)

```mysql
netstat -tulnp | grep mysql

tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      3562/mysqld
```

## Check the port used by MySQL

* `MySQL> SHOW GLOBAL VARIABLES LIKE 'PORT';`
## Reset password of a user including root

```MySQL
mysql -u root -p

use mysql;
SET PASSWORD FOR root@localhost = PASSWORD('newpassword');
flush privileges;
```
