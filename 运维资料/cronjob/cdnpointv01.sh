#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install Cdnpoint"
    exit 1
fi

clear
echo "========================================================================="
echo "Cdnpoint for CentOS/RadHat Linux  Written by Shu88.cn"
echo "========================================================================="
	get_char()
	{
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
	}
	echo ""
	echo "Press any key to start..."
	char=`get_char`

#Stop httpd
echo "======Stop httpd========"
service httpd stop
echo "======Stop httpd OK==========="

#download software
echo "======download software in /usr/local/src========"
wget http://www.xxx.cn/software/cdnpointv01.tar.gz
tar zxvf cdnpointv01.tar.gz
cp -r conf /usr/local/src
mkdir /home/wwwlogs
cd /usr/local/src
yum -y install make zlib-devel gcc-c++ subversion
wget http://nginx.org/download/nginx-1.0.12.tar.gz
wget http://downloads.sourceforge.net/project/pcre/pcre/8.32/pcre-8.32.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpcre%2F&ts=1367934757&use_mirror=nchc
wget http://labs.frickle.com/files/ngx_cache_purge-1.5.tar.gz
rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el5/noarch/varnish-release-3.0-1.noarch.rpm
svn checkout http://substitutions4nginx.googlecode.com/svn/trunk/ substitutions4nginx-read-only
echo "======download OK==========="

#install varnish
echo "======install varnish==========="
yum -y install varnish
echo "======install varnish OK==========="

#install pcre
echo "======install pcre in /usr/local/src========"
cd /usr/local/src
echo "=====创建安装目录====="
   mkdir /usr/local/pcre
   unzip pcre-8.32.zip
   cd pcre-8.32
   ./configure  --prefix=/usr/local/pcre
   make
   make install
echo "======install pcre OK========"

#install nginx
echo "======install ngnix==========="
#添加www组
groupadd  www   
#创建nginx运行账户www并加入到www组，不允许www用户直接登录系统
useradd -g www www -s /bin/false   
   cd /usr/local/src
   tar  zxvf  ngx_cache_purge-1.5.tar.gz
   tar  zxvf nginx-1.0.12.tar.gz
   cd nginx-1.0.12
#注意:--with-pcre=/usr/local/src/pcre-8.21指向的是源码包解压的路径，而不是安装的路径，否则会报错，还有记得substitutions4nginx的解压和安装
   ./configure --prefix=/usr/local/nginx --with-http_gzip_static_module --with-ipv6 --user=www --group=www --with-http_stub_status_module --with-openssl=/usr/ --with-pcre=/usr/local/src/pcre-8.32 --add-module=../ngx_cache_purge-1.5 --add-module=../substitutions4nginx-read-only

   make   
   make install   
   /usr/local/nginx/sbin/nginx    
   chown www.www -R /usr/local/nginx/html   
   chmod 700 -R /usr/local/nginx/html    
cp /usr/local/src/conf/nginx /etc/rc.d/init.d/nginx
chmod 775 /etc/rc.d/init.d/nginx  
cp /usr/local/src/conf/varnish /etc/sysconfig/varnish
cp /usr/local/src/conf/default.vcl /etc/varnish/default.vcl
cp /usr/local/src/conf/nginx.conf /usr/local/nginx/conf/nginx.conf
cp /usr/local/src/conf/proxy.conf /usr/local/nginx/conf/proxy.conf
cp -r /usr/local/src/conf/vhost /usr/local/nginx/conf/vhost
chkconfig nginx on    
#设置开机启动
chkconfig varnish on    
#设置varnish开机启动
chkconfig httpd off    
#取消apache开机启动
/etc/rc.d/init.d/nginx restart
service nginx restart
service varnish restart
echo "======install nginx OK==========="

echo "Install Cdnpoint v0.1 completed! enjoy it."
echo "========================================================================="
echo "Cdnpoint v0.1 for CentOS/RadHat Linux  Written by xxx.cn "
echo "========================================================================="
echo ""