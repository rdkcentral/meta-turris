# meta-turris
External layer for turris omnia

### Quick Build steps

Follow this build steps to generate RDKB image and assuming that yocto environment setting is already done.
```
$ mkdir <workspace dir> 
$ cd <workspace dir> 

$ repo init -u https://code.rdkcentral.com/r/manifests -m rdkb-turris-extsrc.xml -b rdk-next
(or)
$ repo init -u https://code.rdkcentral.com/r/manifests -m rdkb-turris-nosrc.xml -b rdk-next

$ repo sync -j4 --no-clone-bundle 
$ MACHINE=turris source meta-turris/setup-environment
$ bitbake rdk-generic-broadband-image 
```
