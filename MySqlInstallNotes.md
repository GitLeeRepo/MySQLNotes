# Overview


# Installation

## Linux Install MySQL on Ubuntu 18.04

### Install

```bash
sudo apt-get install mysql-server

sudo mysql_secure_installation
```

### Verifying Installation

```bash
systemctl status mysql.service 
```
This will display its status.  If it is not running type: 

```bash
sudo systemctl start mysql
```

If you want to restart mysql

```bash
sudo systemctl restart mysql
```

Check Version info:

```bash
mysqladmin -p -u root version
```

### Try Logging in

```bash
mysql -u root -p
```

### Issue

Note I ran into an issue of being able to login with MySQL's root password (which was provided in **mysql_secure_installation**), both when telling it to **flush priveleges** as the last step, and without telling it to do so.  I don't recall ever running into this before.  The solution involved two different fixes, first:

```bash
sudo vi /etc/mysql/my.cnf
```

Adding the following at the end of the file (it only had two includes):

```
[mysqld]
skip-grant-tables
```

Which was based on the following steps from stackoverflow:

1. Open & Edit /etc/my.cnf
2. Add **skip-grant-tables under [mysqld]**
3. Restart Mysql **sudo systemctl restart mysql**
4. You should be able to login to mysql now using the below command **mysql -u root -p**
5. Run mysql> **flush privileges;**
6. Set new password by **ALTER USER 'root'@'localhost' IDENTIFIED BY 'NewPassword';**
7. Go back to **/etc/mysql/my.cnf** and **remove/comment skip-grant-tables**
8. Restart Mysql **sudo systemctl restart mysql**
9. Now you will be able to login with the new password **mysql -u root -p**

The problem was I got the following error during the **ALTER USER** and when trying to login to MySQL from another terminal: **ERROR 1524 (HY000): Plugin 'auth_socket' is not loaded**

I then found this solution, which in conjunction with the above solution **solved the problem**:

```
use mysql;
update user set authentication_string=PASSWORD("rootpassword") where User='root';
update user set plugin="mysql_native_password" where User='root';  # THIS LINE

flush privileges;
quit;
```

Not sure if I would have used the **password** setting method of the 2nd solution (without the plugin load) if that would have worked or if the original syntax would have worked if I added the **plugin** line in the 1st solution.  I suspect if I do this again, but follow all the steps of the first solution, and just replace the password part with the two lines from the second, it should work.  But also note that the 2nd solution does the **flush priveleges** after chaning the password, instead of before.  Regardless, the combination of the two, done it order, solved the problem. Provided that after the 2nd solution, you remember to go back and comment out the **skip-grant-tables** and **restart** found in the 1st solution.  To play it safe, make sure you stay in MySQL during the 1st soluton, so you don't get locked out.
