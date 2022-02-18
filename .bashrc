# .bashrc

# User specific aliases and functions

#avoid interferring non-interact programes --ycMia
[ -z "$PS1" ] && return

echo "[info] ------ Hello! here's /root/.bashrc running~ (0w0) ------"
echo "[info] Written By ycMia, Thu Feb 17 17:31:02 CST 2022"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Below there are ycMia's settings

# function: check if the specificated screen is exist
Screen_check()
{
	if [ -z "$1" ];then
		return
	fi
		
	result=`screen -ls | grep "[^w]*\.$1[[:space:]]([A-Za-z]*)$"`
	return 
}

frp_home="/home/ycmia/tools/frp"
frp_version="frp_0.37.1_linux_amd64"

# function: Start frpSupport, give this device a tunnel to public network
frpSupportForSSH_start_safe()
{
	frpSupport_ScreenName="frpSupport_ssh"
	
	Screen_check "$frpSupport_ScreenName"
	if [[ -z $result ]]
	then
		screen -dmS "$frpSupport_ScreenName"
		screen -x -S $frpSupport_ScreenName -p 0 -X stuff "cd $frp_home/$frp_version\n"
		screen -x -S $frpSupport_ScreenName -p 0 -X stuff "./frpc -c ./frpc.ini\n"
	fi
	echo "[info] frp support for ssh have been set, for more information, see \"$frp_home/$frp_version/frpc.ini\""
}

# function: open Minecraft Server
minecraftServer_start_safe()
{
	serverNames=("minecraftServer")
	frpSupportNames=("frpSupport_minecraftServer")
	frpSupport_minecraftServer_configName="frpc_minecraftServer.ini";
	
	Screen_check "${serverNames[0]}"
	if [[ -z $result ]]
	then
		echo "[info] into \"minecraftServer_start_safe()\" ..."
		home="/home/ycmia/mount/minecraftServer"
		version="1.12.2"
		forgeVersion="14.23.5.2859"
		
		cmds=("cd $home/forge/$version/$forgeVersion/" "./run.sh")
		cmds_length=2
		
		frp_cmds=("cd $frp_home/$frp_version" "./frpc -c ./$frpSupport_minecraftServer_configName")
		frp_cmds_length=2
		
		echo -e "[info] Creating screens...\c"
		screen -dmS ${serverNames[0]}
		screen -dmS ${frpSupportNames[0]}
		echo -e "Screens have been created. Wait a moment...\c"
		sleep 0.2s
		echo "done"
		
		echo -e "[info] Giving commands to game server ...\c"
		for (( i=0; i<$cmds_length; i++))
		do
			screen -x -S ${serverNames[0]} -p 0 -X stuff "${cmds[$i]}\n"
		done
		echo "done"

		echo -e "[info] Giving commands to frpSupport for game ...\c"
		for (( i=0; i<$frp_cmds_length; i++))
		do
			screen -x -S ${frpSupportNames[0]} -p 0 -X stuff "${frp_cmds[$i]}\n"
		done
		echo "done"
	fi
	echo "[info] minecraftServer have been launched, now available on screen \"${serverNames[0]}\""
	echo "[info] support for minecraftServer have been set, for more information, see \"$frp_home/$frp_version/$frpSupport_minecraftServer_configName\""
}

# function calls

frpSupportForSSH_start_safe
minecraftServer_start_safe

# ycMia's environment setting

alias java17='/home/ycmia/Environment/jdk-17/bin/java'

export http_proxy=http://127.0.0.1:10809
export https_proxy=https://127.0.0.1:10809

echo "[info] ------ Root's .bashrc end ------"
