## Vagrant Development Box for CLEAN Platform  
based on [puphpet](https://puphpet.com/), maintained by [@deleomotosho](deleomotosho.com)

### Contains:
- Ubuntu Trusty 14.04 LTS x64
- PHP 5.6 with XDebug 2.3
- MySQL DB 5.5
- Ruby 2.1.3 (via RVM)
- Node 4.1.0
- Beanstalkd
- Mailcatcher
- ElasticSearch
- Ngrok 2


### Usage
1. Clone the CLEAN project: `git clone https://github.com/WirelessAnalytics/clean`

2. Set your vagrant provisioner in [Line 9] (http://git.io/vL5bH) (usually virtualbox, fusion or parallels)

3. In the same folder, clone this box, `git@github.com:WirelessAnalytics/devbox.git`, then `cd devbox` and `vagrant up`. If this is not a fresh clone,  delete all the files in `.\puphpet\files\dot\ssh` (after the vagrant box has run, you should replace it with yours so that you can successfulyl authenticate from insisde the VM).

4. Run the following (_this just needs to be run the first time the box come on_):
 - npm install
 - bower install
 - bundle install
 - grunt # set up JS dependencies
 - composer install # install all PHP dependencies
 - git fat #pull all possible seed files
 - php artisan wa:db migrate # migrate the database

#### URI
Mailcatcher: http://192.168.58.101:1080
Beanstalkd Console: http://192.168.58.101/beanstalkd_console/public


## For Windows 10
- Use [Virtualbox v4.3.30](http://download.virtualbox.org/virtualbox/4.3.30/VirtualBox-4.3.30-101610-Win.exe) and [vagrant v1.7.4](https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4.msi)
- After installing Virtual box and vagrant, apply [this fix](https://www.virtualbox.org/ticket/14040#comment:76)

##  XDebug Setup for Windows
[Mostly this](http://docs.wirelessanalytics.com/Dev_Notes/Getting_Started/Config_XDebug%20_with_PHPStorm)

All done!
