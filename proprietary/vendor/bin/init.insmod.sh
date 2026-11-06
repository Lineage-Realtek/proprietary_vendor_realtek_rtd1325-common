#!/vendor/bin/sh

#############################################################
### init.insmod.cfg format:                               ###
### ----------------------------------------------------- ###
### [insmod|setprop|enable/moprobe|wait] [path|prop name] ###
### ...                                                   ###
#############################################################

# imitates wait_for_file() in init
wait_for_file()
{
    filename="${1}"
    timeout="${2:-5}"

    expiry=$(($(date "+%s")+timeout))
    while [[ ! -e "${filename}" ]] && [[ "$(date "+%s")" -le "${expiry}" ]]
    do
        sleep 0.01
    done
}

if [ $# -eq 1 ]; then
  cfg_file=$1
else
  cfg_file="/vendor/etc/init.insmod.cfg"
  #exit 1
fi


if [ -f $cfg_file ]; then
  while IFS=" " read -r action arg
  do
    case $action in
      "insmod")
        echo "<7>Loading module $arg" > /dev/kmsg
        insmod $arg
        echo "<7>Loaded kernel module $arg" > /dev/kmsg
        ;;
      "setprop")
        setprop $arg 1
        echo "<7>setprop $arg 1" > /dev/kmsg
        ;;
      "enable")
        echo 1 > $arg
        echo "<7>enable $arg 1" > /dev/kmsg
        ;;
      "wait")
        wait_for_file $arg
        echo "<7>wait_for_file $arg" > /dev/kmsg
        ;;
      "wifi_auto_insmod")
        wifi_auto_insmod
        echo "<7>wifi_auto_insmod" > /dev/kmsg
        ;;
      "modprobe")
        case ${arg} in
          "-b *" | "-b")
            arg="-b $(cat /vendor/lib/modules/modules.load)" ;;
          "*" | "")
            arg="$(cat /vendor/lib/modules/modules.load)" ;;
        esac
        echo "<7>Probing module $arg" > /dev/kmsg
        modprobe -a -d /vendor/lib/modules $arg
        echo "<7>Loaded kernel module $arg" > /dev/kmsg
        ;;
    esac
  done < $cfg_file
fi

# set property even if there is no insmod config
# as property value "1" is expected in early-boot trigger
setprop vendor.all.modules.ready 1
setprop vendor.all.devices.ready 1
