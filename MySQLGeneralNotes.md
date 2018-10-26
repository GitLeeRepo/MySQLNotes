# Overview

Notes taken while learning/relearning MySQL

# References

## My Other Notes

* [MySQLInstallNotes](https://github.com/GitLeeRepo/MySQLNotes/blob/master/MySQLInstallNotes.md#overview)
* [SqlSource](https://github.com/GitLeeRepo/SqlSource) - SQL source code for multiple servers
* [SqlServerNotes](https://github.com/GitLeeRepo/SqlServerNotes/blob/master/SqlServerNotes.md#overview)
* [PostgreSQLNotes](https://github.com/GitLeeRepo/PostgreSQLNotes/blob/master/PostgreSQLNotes.md#overview)
* [DownloadedImageNotes#mysql](https://github.com/GitLeeRepo/DockerNotes/blob/master/DownloadedImageNotes.md#mysql) for details on setting up and using a **MySQL Docker Image**.
* [DockerNotes](https://github.com/GitLeeRepo/DockerNotes/blob/master/DockerNotes.md#overview) more general **Docker notes**

# Installation

Refer to:

* [MySQLInstallNotes](https://github.com/GitLeeRepo/MySQLNotes/blob/master/MySQLInstallNotes.md#overview)


# Running MySQL

```bash
mysql -u username -p
```

## Version info

* `mysqladmin -p -u root version`  This will display version and other useful information.


# Show Commands

* `SHOW COLUMNS FROM [<db>.]<table>` - display the tables column structure (col name, type, null, key, default, extra).  Equivalent to the `describe <table>` command.  For collation and operation privileges use `SHOW FULL COLUMNS FROM [<db>.]<table>`.

* `SHOW CREATE TABLE [<db>.]<table>` - display the CREATE statement used to create the table, this includes the engine, current increment number, and character set.

* `SHOW DATABASES` - display a list of databases.

* `SHOW GRANTS [FOR <user>]` - show the grant privileges for a particular user, if the `FOR <user>` is not specified it is for the current user.

* `SHOW INDEX FROM [<db>.]<table>` - display the tables indexes.

* `SHOW TABLES` - display a list of tables in the current database.


# Alter Table

## Changing a column name and type

For a table called [name], change the column name from [first] to [firstname]

```MySQL
ALTER TABLE `name` CHANGE COLUMN `first` `firstname` VARCHAR(40) NULL;
```
# Setting up MySQL connectivity in Python3

Python3 needs the mysql-connector module to interact with MySQL databases

* `sudo apt-get install python3-mysql.connector`

Here's an example of a simple Python3 (works in 2 also but that's a different install above) script for connecting to a MySQL database

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

* To grant them all privileges on a all databases:

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

* Getting a list of users:

```
SELECT `user`, `host`
FROM `mysql`.`user`
ORDER BY `user`, `host`;
```

## Allowing remote access to MySQL

Refer also to the **More Remote Connections Info** section below, including a **Troubleshooting Remote Connection Issues** section.  You may also want to refer to the **Configuration Files** section below.

1. Edit the `/etc/mysql/mysql.conf.d/mysqld.cnf` file changing the bind-address from 127.0.0.0 to 0.0.0.0:

```mysql
bind-address        = 0.0.0.0
```

Note this allows remote access from any host, to specify a particular host use its IP instead of 0.0.0.0

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

# Creating a test Database and Tables

## Create Database

```sql
CREATE DATABASE test;
```

## Create Tables

```sql
USE test;

CREATE TABLE `name` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(40) DEFAULT NULL,
  `lastname` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
```

```sql
 CREATE TABLE `address` (
  `id` int(11) NOT NULL,
  `street` varchar(40) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
```

## Insert into Tables

```sql
INSERT INTO name(firstname, lastname)
VALUES ('Billy', 'Bob');

INSERT INTO name(firstname, lastname)
VALUES ('Willy', 'Nilly');
```

```sql
INSERT INTO address(id, street, city) 
VALUES (8, 'Billy Bob Ave', 'Hickeryville');

INSERT INTO address(id, street, city) 
VALUES (9, 'Willy Nilly Lane', 'Hickeryville');
```

## Select the Test Data

```sql
SELECT n.firstname, n.lastname, a.street, a.city
FROM name n
JOIN address a ON n.id = a.id;
```

## test Database as a Script

```sql
CREATE DATABASE test;

USE test;

CREATE TABLE `name` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(40) DEFAULT NULL,
  `lastname` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

 CREATE TABLE `address` (
  `id` int(11) NOT NULL,
  `street` varchar(40) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO name(firstname, lastname)
VALUES ('Billy', 'Bob');

INSERT INTO name(firstname, lastname)
VALUES ('Willy', 'Nilly');

INSERT INTO address(id, street, city) 
VALUES (8, 'Billy Bob Ave', 'Hickeryville');

INSERT INTO address(id, street, city) 
VALUES (9, 'Willy Nilly Lane', 'Hickeryville');

SELECT n.firstname, n.lastname, a.street, a.city
FROM name n
JOIN address a ON n.id = a.id;
```

# More Remote Connections Info

Refer also to the **Allowing remote access to MySQL** section above, and the section above it for **configuring users** for **remote access**.

## Connect a mysql client on One Host to another Host

```bash
mysql -u username -p --host 172.17.0.4
# if necessary include the port number
mysql -h 172.17.0.4 -P 3306 -u username -p
```

### Troubleshooting Remote Connection Issues

Refer to:

* [Fixing Connection Issues](https://www.tecmint.com/fix-error-2003-hy000-cant-connect-to-mysql-server-on-127-0-0-1-111/)


On the **remote**:

```
# first verify connectivity
> ping server_ip_address

# try accessing with
> mysql -u username -p -h host_address  

# if not check the port on the server
server>  netstat -lnp | grep mysql

# use the port indicated
```

On the **server**:

```
# verify the daemon is running
> ps -Af | grep mysqld

# if not running
> sudo systemctl start mysql.service

# check the port (on the **tcp** line, not the **unix** line)
>  netstat -lnp | grep mysql
```

Now for the one that **fixed my issue**:

```bash
> sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf 

vi> # comment out the following
vi> bind-address = 127.0.0.1 
vi> # becomes
vi> #bind-address = 127.0.0.1 
# back to bash to restart the mysql.service
> sudo systemctl restart mysql.service
```

The commenting of this line and restarting mysql **fixed my issue**.

**Important** - don't confuse the **/etc/mysql/mysql.conf.d/mysqld.cnf** file with '/etc/mysql/my.cnf' file, which I did at first.  While on some systems they may be the same (since it suggest you can copy this file there) on my default **Ubuntu 18-04** this **my.cnf** file condtained **directory includes** for the **/etc/mysql/mysql.conf.d/** directory where the **mysqld.cnf** file resides.  By default, I also didn't have a **/etc/my.cnf** file.  Based on the comments in the main file this is the intention:

* **/etc/my.cnf** -- current local users settings
* **/etc/mysql/my.cnf** -- global system wide settings
* **/etc/mysql/mysql.conf.d/mysqld.cnf** -- the main configuration file -- changing here fixed my issue

The clue that you are in the wrong file (in my environment) was that there wasn't much content in **/etc/mysql/my.cnf**, while the **/etc/mysql/mysql.conf.d/mysqld.cnf** had lots of content, such as **socket definitions**.

# Docker Containers

**MySQL** can be used inside **Docker Containsers**, with **docker pull mysql** pulling the latest **Official image** from **Docker Hub**.

Refer to:

* My [DownloadedImageNotes#mysql](https://github.com/GitLeeRepo/DockerNotes/blob/master/DownloadedImageNotes.md#mysql) for details on setting up and using a **MySQL Docker Image**.

# Configuration Files

* **/etc/my.cnf** -- current local users settings -- didn't exist on my default starting set up
* **/etc/mysql/my.cnf** -- global system wide settings -- existed on my default initial setup with the following **directory includes**:
  * **`!includedir /etc/mysql/conf.d/`**  -- has mysql.cnf which is empty on my setup
  * **`!includedir /etc/mysql/mysql.conf.d/`** -- contains the main configuration file I list below
* **/etc/mysql/mysql.conf.d/mysqld.cnf** -- the main configuration file

The main **/etc/mysql/mysql.conf.d/mysqld.cnf** has lots of content, such as **socket definitions**, **data files location**, **temp file location**, **configuration tuning** parameters such as **buffer size**, **log file location**, **SSL configurations**, etc.

## My Configuration File Strategy

For the most part I will put my changes in the **/etc/mysql/my.cnf** file **after the directory include** for the main **/etc/mysql/mysql.conf.d/mysqld.cnf** file.  This is not always possible, such as when you need to **comment out** an existing setting such as the **bind-address = 127.0.0.1** to **enable remote connections**.  As an alternative, you could override this setting by adding **bind-address = 0.0.0.0**.

