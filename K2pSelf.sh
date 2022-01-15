##修改模板中的配置，此处是将所有的y改成n，即全部关闭，然后针对IPV6和中文语言的选项，单独改成y。
echo "define templates"
cd ${{ env.DIR }}/trunk/configs/templates/
sudo sed -i 's/=y/=n/g' *.config
sudo sed -i 's/CONFIG_FIRMWARE_ENABLE_IPV6=n/CONFIG_FIRMWARE_ENABLE_IPV6=y/g' *.config
sudo sed -i 's/CONFIG_FIRMWARE_INCLUDE_LANG_CN=n/CONFIG_FIRMWARE_INCLUDE_LANG_CN=y/g' *.config
sudo sed -i 's/CONFIG_FIRMWARE_INCLUDE_VLMCSD=n/CONFIG_FIRMWARE_INCLUDE_VLMCSD=y/g' *.config

##修改主界面的版本号，将后面一小串小版本号去掉
echo "change defaults"
cd /opt/rt-n56u/trunk/
sudo sed -i '3c FIRMWARE_BUILDS_REV=' versions.inc

##修改WIFI的地区，源码中默认2.4G是中国区，5G是美国区，统一改成中国区。
cd /opt/rt-n56u/trunk/user/shared/
sudo sed -i 's/"US"/"CN"/g' defaults.h

##修改NTP时钟同步服务器；
sudo sed -i 's/"ntp1.aliyun.com"/"pool.ntp.org"/g' defaults.h
sudo sed -i 's/"2001:470:0:50::2"/"time.pool.aliyun.com"/g' defaults.h

##修改DHCP分配时自带的域名，原来会有一个域叫lan，现在改为空白。
sudo sed -i 's/"lan"/"wzh"/g' defaults.c

##无线高级设置中的参数，改为打开。默认状态应该为开（界面中有*号标识，表示默认状态），源码中改为了关，现在又将它开启。
sudo sed -i 's/"wl_APSDCapable", "0"/"wl_APSDCapable", "1"/g' defaults.c
sudo sed -i 's/"rt_APSDCapable", "0"/"rt_APSDCapable", "1"/g' defaults.c

##系统高级设置中的参数，全部关闭，具体功能可以参照界面去调。
sudo sed -i 's/"sshd_enable", "1"/"sshd_enable", "0"/g' defaults.c
sudo sed -i 's/"lltd_enable", "1"/"lltd_enable", "0"/g' defaults.c
sudo sed -i 's/"crond_enable", "1"/"crond_enable", "0"/g' defaults.c
sudo sed -i 's/"watchdog_cpu", "1"/"watchdog_cpu", "0"/g' defaults.c

##ppp拨号时，自动响应lcp请求的开关，这里关闭。
sudo sed -i 's/"wan_ppp_lcp", "1"/"wan_ppp_lcp", "0"/g' defaults.c

##修改中文翻译字典，统一将2.4G改成2.4GHz、5G改成5GHz，更加严谨。
##注意批量修改的先后顺序，关键字匹配时，如果原来就是2.4GHz，会将前面的2.4G匹配成2.4GHz，再加上后面的Hz，结果会变成2.4GHzHz。
cd /opt/rt-n56u/trunk/user/www/dict/
sudo sed -i 's/2.4G/2.4GHz/g' CN.dict
sudo sed -i 's/5G/5GHz/g' CN.dict
sudo sed -i 's/GO_2G=2.4GHz 设置/GO_2G=转到 2.4GHz 设置/g' CN.dict
sudo sed -i 's/GO_5GHz=5GHz 设置/GO_5G=转到 5GHz 设置/g' CN.dict

##修改界面中的字符，将2.4G改成2.4GHz、5G改成5GHz，更加严谨。
cd /opt/rt-n56u/trunk/user/www/n56u_ribbon_fixed/
sudo sed -i 's/2.4G/2.4GHz/g' state.js
sudo sed -i 's/value="5G"/value="5GHz"/g' state.js

##在编译K2P的固件之前，修改所有IP地址为192.168.2.1，把DHCP地址限制在101-199之间。
##部分原来就是192.168.2.1的，又写了一遍，是方便之后编译其他固件时准备的。
##源码中修改的不完整，导致部分界面还显示错误的IP地址，应该是192.168.2.1的，还显示192.168.1.1。
echo "change ip to 192.168.2.1"
cd /opt/rt-n56u/trunk/user/shared/
sudo sed -i 's/"192.168.2.1"/"192.168.2.1"/g' defaults.h
sudo sed -i 's/"192.168.2.100"/"192.168.2.101"/g' defaults.h
sudo sed -i 's/"192.168.2.244"/"192.168.2.199"/g' defaults.h

cd /opt/rt-n56u/trunk/user/www/dict/
sudo sed -i 's/192.168.2.1/192.168.2.1/g' CN.dict
sudo sed -i 's/192.168.2.1/192.168.2.1/g' EN.footer

cd /opt/rt-n56u/trunk/user/www/n56u_ribbon_fixed/
sudo sed -i 's/192.168.2.1/192.168.2.1/g' Restarting.asp
sudo sed -i 's/192.168.1.1/192.168.2.1/g' Advanced_APLAN_Content.asp
sudo sed -i 's/192.168.1.1/192.168.2.1/g' Advanced_LAN_Content.asp
sudo sed -i 's/192.168.1.1/192.168.2.1/g' Advanced_SettingBackup_Content.asp
sudo sed -i 's/192.168.1.1/192.168.2.1/g' general.js
