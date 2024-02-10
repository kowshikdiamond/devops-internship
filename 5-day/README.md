# RHEL UPGRADATION 

Verify that the system is subscribed using subscription-manager: 
```
subscription-manager status
```
Ensure you have appropriate repositories enabled. The following command enables the Base and AppStream repositories.

For the 64-bit Intel architecture:
```
subscription-manager repos --enable rhel-8-for-x86_64-baseos-rpms --enable rhel-8-for-x86_64-appstream-rpms
```
For 64-bit ARM:
```
subscription-manager repos --enable rhel-8-for-aarch64-baseos-rpms  --enable  rhel-8-for-aarch64-appstream-rpms
```
Set the system release version:
```
subscription-manager release --set <source_os_version>
```
This command is used to set different minor versions within major versions. It’s essentially adjusts the system to receive updates and packages specific to that particular minor release

If the set-release command is not available on your system, you can set the expected system release version by updating the `/etc/dnf/vars/release` file:
```
echo "<source_os_version>" > /etc/dnf/vars/releasever
```
If you use the dnf versionlock plugin to lock packages to a specific version, clear the lock by running:
```
dnf versionlock clear
```
Update all packages to the latest version:
```
dnf update
```
Reboot the system:
```
reboot
```
Install the Leapp utility:
```
dnf install leapp-upgrade
```
Leapp is a tool developed by Red Hat for upgrading major versions of Red Hat Enterprise Linux (RHEL). It stands for "Linux Early Application and PlayPen." 
- Pre-upgrade analysis: Leapp analyzes the existing system to identify potential issues or conflicts that may arise during the upgrade.
- Checking for deprecated features: It checks for any deprecated features in the current version that may have been removed or replaced in the target version.
- Dependency resolution: Leapp resolves package dependencies to ensure that all required packages for the new version are installed.
- Configuration adjustments: Leapp helps in adjusting system configurations and settings to be compatible with the new version.
- Kernel and bootloader updates: It handles the installation of a new kernel and updates the bootloader configuration.
- Rollback capabilities: Leapp includes a rollback mechanism, allowing users to revert to the previous system state in case the upgrade encounters critical issues.

Identify potential upgrade problems during the pre-upgrade phase before the upgrade:
```
leapp preupgrade
```
If you are using custom repositories from the `/etc/yum.repos.d/` directory for the upgrade, enable the selected repositories as follows:
```
leapp preupgrade --enablerepo <repository_id1> --enablerepo <repository_id2>
```
Examine the report in the `/var/log/leapp/leapp-report.txt` file and manually resolve all the reported problems. Some reported problems contain remediation suggestions. 
Inhibitor problems prevent you from upgrading until you have resolved them.

On your system, start the upgrade process:
```
leapp upgrade
```
If you are using custom repositories from the `/etc/yum.repos.d/` directory for the upgrade, enable the selected repositories as follows:
```
leapp upgrade --enablerepo <repository_id1> --enablerepo <repository_id2>
```
Manually reboot the system:
```
reboot
```
Verify the the current OS version:
```
cat /etc/redhat-release
```

Check the OS kernel version. 
```
uname -r
```
# How to create a local repository

Install the `yum-utils` and `createrepo` packages:
```
yum install yum-utils createrepo
```
`yum-utils` contains the tools you will need to manage your soon to be created repository, and createrepo is used to create the xml based rpm metadata you will require for your repository.

It downloads all the dependencies and required packages in a directory:
```
yumdownloader --resolve --destdir=give_name package_name
```
`yumdownloader`  is used to download RPM packages from repositories

Navigate to the directory and use the following command:
```
createrepo .
```
`createrepo` generates metadata files needed by YUM to efficiently manage and install packages. These metadata files include information about the available packages, their versions, dependencies, and other relevant details

Now that you have set up the local repository, you can use it on your system. 
```
sudo nano /etc/yum.repos.d/local.repo
```
Add the below code

```[local]
name=Local Repository
baseurl=file:///home/diamond/nginx-packages {folder location]}
enabled=1
gpgcheck=0
priority=1
```

enabled=1 enables the repository, 0 means disabled.

GPG (GNU Privacy Guard) signature is a digital signature that helps ensure the integrity and authenticity of the packages in the repository.

priority=1 helps in prioritizing installing packages from local repositories.

`sudo yum makecache`
`yum makecache` was used to create or update the metadata cache

# Setting up FTP server

Install vsftpd:
```
sudo apt update
```
```
sudo apt-get install vsftpd
```
After installation check weather vsftpd is running or not:
```
sudo systemctl status vsftpd
```
If it’s not running:
```
sudo systemctl start vsftpd
```
COnfigure vsftp config file which is usually located in `/etc/vsftpd.conf`
```
sudo nano /etc/vsftpd.conf
```
Enable Uploading to the FTP server:
```
write_enable=YES
```
The `write_enable` flag must be set to YES in order to allow changes to the filesystem, such as uploading: If this entry is comment, uncomment it.

Create a new user on our system through below commands:
```
adduser awsftpuser
passwd awsftpuser
```
Remember this user and password as these are required to login to ftp server

Then add the following lines to the bottom of the vsftpd.conf file:
```
pasv_enable=YES
pasv_min_port=1024
pasv_max_port=1048
pasv_address=<Public IP of your instance>
```
`pasv_enable=YES`This option enables Passive Mode (PASV) for the FTP server. In Passive Mode, the server opens a random port for data transfer, and the client connects to that port to download or upload files. This is particularly useful when the client is behind a firewall or NAT.

`pasv_min_port=1024 and pasv_max_port=1048`These options set the range of passive mode ports that the FTP server will use for data connections. In the provided configuration, the server will use a range of ports from 1024 to 1048 for passive mode data connections.

`pasv_address=<Public IP of your instance>`This option specifies the public IP address that the FTP server will advertise to clients for passive mode data connections. 

Restart after editing:
```
sudo systemctl restart vsftpd
```
Connect to the ftp server:
```
ftp ipaddress
```
# Create an offline repo in a system that can be used to update and install packages from any system

Install apache:
```
yum install httpd
```
Start the service:
```
sudo service httpd start
```
Give permissions to apache to read or write files in the directory
```
sudo chown -R apache:apache /path/to/your/folder
```
Now edit configuration file for the Apache HTTP Server
```
sudo nano /etc/httpd/conf/httpd.conf
```
Make sure you set correct Document Root and direcotry in `/etc/httpd/conf/httpd.conf`.

i.e.
```
DocumentRoot "/home/ec2-user"

<Directory "/home/ec2-user/packages">
    AllowOverride None
    # Allow open access:
    Require all granted
</Directory>

# Further relax access to the default document root:
<Directory "/home/ec2-user">
```
Now restart the server:
```
sudo service httpd restart
```
Setting up local repository in another system by adding below code:
```
name=Local Repository
baseurl=http://ipaddress
enabled=1
gpgcheck=0
priority=1
```     
in `/etc/yum.repos.d/local.repo`