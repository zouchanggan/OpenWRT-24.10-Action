#!/bin/bash

# =====================
# 配置参数
# =====================

# 脚本URL
# export mirror=https://script.kejizero.online

##配置IP
sed -i "s/192.168.1.1/$LAN/g" package/base-files/files/bin/config_generate

##删除软件
rm -rf ./package/feeds/extraipk/luci-app-turboacc
rm -rf ./package/feeds/extraipk/luci-app-vssr
rm -rf ./package/feeds/extraipk/luci-app-passwall
rm -rf ./package/feeds/extraipk/luci-app-passwall2
rm -rf ./package/feeds/extraipk/luci-app-ssr-plus
rm -rf ./package/feeds/extraipk/luci-app-vssr
rm -rf ./package/feeds/extraipk/luci-app-appfilter
rm -rf ./package/feeds/extraipk/luci-app-ddns-go
rm -rf ./package/feeds/extraipk/luci-app-openclash
rm -rf ./package/feeds/extraipk/luci-app-lucky
rm -rf ./package/feeds/extraipk/luci-app-mosdns


##加入作者信息
# sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
# sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By grandway2025'/g" package/base-files/files/etc/openwrt_release
# sed -i 's|^OPENWRT_RELEASE=".*"|OPENWRT_RELEASE="OpenWrt 定制版"|' package/base-files/files/usr/lib/os-release

##WiFi
# sed -i "s/MT7986_AX6000_2.4G/OpenWrt-2.4G/g" package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat
# sed -i "s/MT7986_AX6000_5G/OpenWrt-5G/g" package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat

##New WiFi
# sed -i "s/ImmortalWrt-2.4G/OpenWrt-2.4G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
# sed -i "s/ImmortalWrt-5G/OpenWrt-5G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

# 删除软件依赖
rm -rf feeds/packages/net/chinadns-ng 
rm -rf feeds/packages/net/hysteria 
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/shadowsocksr-libev
rm -rf feeds/packages/net/shadowsocks-rust 
rm -rf feeds/packages/net/shadowsocks-libev 
rm -rf feeds/packages/net/tcping 
rm -rf feeds/packages/net/trojan
rm -rf feeds/packages/net/trojan-plus
rm -rf feeds/packages/net/tuic-client  
rm -rf feeds/packages/net/v2ray-core  
rm -rf feeds/packages/net/v2ray-plugin
rm -rf feeds/packages/net/xray-core 
rm -rf feeds/packages/net/xray-plugin
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/open-app-filter
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/lucky
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/lang/golang
 
# 删除软件包
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall2
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-appfilter
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-lucky
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-turboacc

#添加额外软件包
# golang 1.24
rm -rf feeds/packages/lang/golang
git clone https://git.kejizero.online/zhao/packages_lang_golang -b 25.x feeds/packages/lang/golang

# SSRP & Passwall
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone -b openwrt-24.10 https://git.kejizero.online/zhao/openwrt_helloworld package/new/helloworld

# lucky
git clone https://github.com/gdy666/luci-app-lucky.git package/new/lucky

# Mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/new/mosdns
cp -r package/new/mosdns/{luci-app-mosdns,mosdns,v2dat} package/new/helloworld
rm -rf package/new/mosdns

# OpenAppFilter
git clone https://github.com/destan19/OpenAppFilter package/new/OpenAppFilter

# adguardhome
git clone https://git.kejizero.online/zhao/luci-app-adguardhome package/new/luci-app-adguardhome
mkdir -p files/usr/bin
AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_arm64 | awk -F '"' '{print $4}')
wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome
chmod +x files/usr/bin/AdGuardHome

# openclash
mkdir -p files/etc/openclash/core
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
chmod +x files/etc/openclash/core/clash*

# 更新feeds 
./scripts/feeds update -a && ./scripts/feeds install -a
