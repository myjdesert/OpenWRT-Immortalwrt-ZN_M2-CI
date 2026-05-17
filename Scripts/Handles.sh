#!/bin/bash
# Description: OpenWrt DIY script - Handles.sh

PKG_PATCH="$GITHUB_WORKSPACE/wrt/package/"

# 完美剔除 PassWall 里的旧版 Shadowsocks 组件，大幅度降低固件体积
PW_FILE=$(find ./ -maxdepth 3 -type f -wholename "*/luci-app-passwall/Makefile")
if [ -f "$PW_FILE" ]; then
	sed -i '/config PACKAGE_$(PKG_NAME)_INCLUDE_Shadowsocks_Libev/,/x86_64/d' $PW_FILE
	sed -i '/config PACKAGE_$(PKG_NAME)_INCLUDE_ShadowsocksR/,/default n/d' $PW_FILE
	sed -i '/Shadowsocks_NONE/d; /Shadowsocks_Libev/d; /ShadowsocksR/d' $PW_FILE
	echo "Passwall structures fixed!"
fi

# 修复基础通话协议依赖冲突
FW_FILE=$(find ../feeds/telephony/ -maxdepth 3 -type f -wholename "*/freeswitch/Makefile")
if [ -f "$FW_FILE" ]; then
	sed -i "s/libpcre/libpcre2/g" $FW_FILE
fi
