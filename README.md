# meta-turris
External layer for turris omnia

### Quick Build steps

Follow this build steps to generate RDKB image and assuming that yocto environment setting is already done.
```
$ mkdir <workspace dir> 
$ cd <workspace dir> 
$ repo init -u https://code.rdkcentral.com/r/reference/manifests/ -m rdkb-turris.xml -b master 
$ repo sync -j4 --no-clone-bundle 
$ source meta-turris/setup-environment (Select option against meta-turris/conf/machine/turris.conf) 
$ bitbake rdk-generic-broadband-image 
```
