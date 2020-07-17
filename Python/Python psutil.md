#psutil

psutil(process and system utilities) is a cross-platform library for retrieving information on running processes and system utilization (CPU, memory, disks, network) in Python. It is useful mainly for system monitoring, profiling and limiting process resources and management of running processes. It implements many functionalities offered by command line tools such as: ps, top, lsof, netstat, ifconfig, who, df, kill, free, nice, ionice, iostat, iotop, uptime, pidof, tty, taskset, pmap. It currently supports Linux, Windows, OSX, Sun Solaris, FreeBSD, OpenBSD and NetBSD, both 32-bit and 64-bit architectures, with Python versions from 2.6 to 3.5 (users of Python 2.4 and 2.5 may use 2.1.3 version)

* [github](https://github.com/giampaolo/psutil)
* [docs](http://pythonhosted.org/psutil/#)

##Install

###Linux

Ubuntu / Debian (use python3-dev and python3-pip for python 3):

```
sudo apt-get install gcc python-dev python-pip
pip install psutil
```
RedHat (use python3-devel and python3-pip for python 3):

```
sudo yum install gcc python-devel python-pip
pip install psutil
```

###OSX

Install [XcodeTools](https://developer.apple.com/downloads/?name=Xcode) first, then:

```
pip install psutil
```