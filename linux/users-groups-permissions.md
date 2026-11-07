Add Linux users groups and permissions documentation

Linux Users, Groups and Permissions

1. Objective

The goal of this lab was to understand and practice Linux user and group management, file permissions, ownership, the setgid bit, and umask behavior.

A shared directory structure was created to demonstrate how multiple users can collaborate through a Linux group.

2. Lab Environment

* OS: Ubuntu Server
* Hostname: ubuntu-server-01
* Primary user: sgy
* Test user: devops-test
* Shared group: devops-lab

3. User and Group Management

Initial user information

The primary user was sgy, with UID 1001.

id sgy

A dedicated group was created:

sudo groupadd devops-lab

The primary user was added to the group:

sudo usermod -aG devops-lab sgy

The -aG options append the specified supplementary group without replacing existing supplementary group memberships.

Group membership was verified using:

getent group devops-lab
id sgy

The group was successfully created with GID 1002.

Group membership and SSH sessions

A user needs a new login session for updated supplementary group membership to become active in that session.

After adding sgy to devops-lab, the existing SSH session did not immediately recognize the new membership.

Reconnecting through SSH resolved the issue.

This demonstrates the difference between the account information stored on the system and the group memberships active in an existing process session.

4. Linux Permission Model

Linux permissions are divided into three categories:

* Owner (user)
* Group
* Others

Each category can have three permissions:

Permission	Symbol	Numeric value
Read	r	4
Write	w	2
Execute	x	1

For example:

-rwxrwx---

This represents:

* Owner: read, write and execute
* Group: read, write and execute
* Others: no permissions

The numeric equivalent is 770.

Inspecting permissions

The following commands were used:

ls -l
ls -ld /srv/devops-lab
stat -c '%A %a %U:%G %n' /srv/devops-lab

The stat command provided both symbolic and numeric permissions, as well as ownership information.

5. Important System Files and Directories

The permissions of several important system resources were inspected.

stat -c '%A %a %U:%G %n' /etc/passwd /etc/shadow /tmp

Observed results:

Resource	Permissions	Purpose
/etc/passwd	644	User account information
/etc/shadow	640	Password hashes and password-related information
/tmp	1777	Shared temporary directory

/etc/passwd

Contains user account information and is readable by normal users. Password hashes are not stored here.

/etc/shadow

Contains password hashes and related password policy information. Access is restricted.

/tmp

Uses the sticky bit (t).

The sticky bit prevents ordinary users from deleting or renaming files belonging to other users in a shared writable directory, unless they have the necessary privileges.

6. Creating the Shared Directory Structure

The following directory structure was created:

/srv/devops-lab/
├── scripts/
├── logs/
└── configs/

Creation command:

sudo mkdir -p /srv/devops-lab/{scripts,logs,configs}

Ownership was assigned to root and the devops-lab group:

sudo chown -R root:devops-lab /srv/devops-lab

Directory permissions were configured:

sudo chmod -R 2770 /srv/devops-lab

The intended directory permission model was:

drwxrws---

This means:

* Owner: root
* Group: devops-lab
* Owner permissions: read, write and execute
* Group permissions: read, write and execute
* Others: no access
* Setgid: enabled

Understanding the setgid bit

The setgid bit on a directory causes newly created files and subdirectories to inherit the directory’s group ownership.

This is useful for shared directories where multiple users need to collaborate.

It does not automatically grant group write permissions to newly created files. File permissions are also affected by the creating process’s umask.

7. Correcting File and Directory Permissions

The initial recursive chmod command also set the setgid bit on files.

The permissions were refined so that setgid was applied only to directories:

sudo find /srv/devops-lab -type d -exec chmod 2770 {} +
sudo find /srv/devops-lab -type f -exec chmod 660 {} +

This established the following model:

Resource	Permissions
Directories	2770
Regular files	660

The find command was used with -type d to select directories and -type f to select regular files.

The -exec option executes a command on the matching entries. The {} placeholder represents the matched paths, and + passes multiple paths efficiently.

8. Understanding Umask

The umask determines which permissions are removed from the default permissions when new files and directories are created.

The current shell umask was inspected using:

umask
umask -S

Observed result:

0002
u=rwx,g=rwx,o=rx

Default permissions

The default permission base is:

* Regular files: 666
* Directories: 777

With an umask of 0002, a regular file is normally created with permissions 664.

666
-002
----
664

This gives the owner and group read/write access, while others receive read-only access.

Testing a different umask

The umask was temporarily changed:

umask 0027

A test file was created:

touch /srv/devops-lab/scripts/test-umask.txt

The resulting permissions were:

-rw-r----- 640 sgy:devops-lab

This demonstrated that umask affects the permissions of newly created files.

The original shell setting was restored:

umask 0002

The umask change applied only to the current shell and did not modify the system-wide configuration.

9. Testing Group Inheritance with a Second User

A separate test account was created:

sudo useradd -m -s /bin/bash devops-test
sudo usermod -aG devops-lab devops-test

The account’s group membership was verified:

id devops-test

Observed result:

uid=1002(devops-test) gid=1003(devops-test) groups=1003(devops-test),1002(devops-lab)

The test user created a file in the shared directory:

sudo -u devops-test touch /srv/devops-lab/scripts/second-user-test.txt

The resulting ownership was:

devops-test:devops-lab

Although devops-test has its own primary group, the new file inherited the devops-lab group from the parent directory.

Testing cross-user write access

The primary user then modified the file:

echo "Modified by sgy" >> /srv/devops-lab/scripts/second-user-test.txt

The file contents were verified:

cat /srv/devops-lab/scripts/second-user-test.txt

Output:

Modified by sgy

The test was successful.

This confirmed that both users could collaborate through the shared group.

The test file was created with permissions 664, showing that the creating user’s umask also influences the resulting file permissions.

10. Final Verification

The final directory structure and permissions were inspected:

find /srv/devops-lab -printf '%M %u:%g %p\n'

Verified configuration:

Path	Owner	Group	Permissions
/srv/devops-lab	root	devops-lab	2770
scripts/	root	devops-lab	2770
logs/	root	devops-lab	2770
configs/	root	devops-lab	2770
test-permissions.txt	sgy	devops-lab	660
test-umask.txt	sgy	devops-lab	660
second-user-test.txt	devops-test	devops-lab	664

The current sgy shell umask was verified as 0002.

11. Key Learnings

During this lab, I practiced and verified:

* Creating and managing Linux users and groups.
* Adding supplementary group memberships.
* Understanding active group membership in existing SSH sessions.
* Inspecting file ownership and permissions.
* Using chmod, chown, stat, and find.
* Understanding numeric and symbolic permission notation.
* Understanding the sticky bit and setgid bit.
* Configuring shared directories with group-based access.
* Understanding umask and its effect on new files.
* Verifying cross-user file access in a shared group.

Conclusion

A shared Linux directory structure was successfully configured using group-based permissions and the setgid bit.

Two separate users were able to create and modify files through their shared group membership.

The lab demonstrated how Linux ownership, permissions, group inheritance, and umask work together in a practical multi-user environment.