#!/vendor/bin/sh

get_cur_filenum()
{
    path=$1
    min_num="$(ls $path | grep -E '^[0-9]+$' | sort -n  | head -n 1)"
    max_num="$(ls $path | grep -E '^[0-9]+$' | sort -n  | tail -n 1)"

    if [ "$max_num" -gt 9995 ] && [ "$min_num" -lt 5 ]; then
        cur_filenum=`expr $(ls $path | grep -E '^[0-9]+$' | awk '$0 >= 0 && $0 <= 4' | sort -n | tail -n 1)`
    elif [ -z "$max_num" ]; then
        cur_filenum=0
    else
        cur_filenum=$max_num
    fi

    echo $cur_filenum
}

emmc_lob_path="/mnt/vendor_logs/LastLogs/logs"
mkdir -p $emmc_lob_path

usb_existed=0
usb_name=$(ls /mnt/media_rw | grep -E "[0-9a-fA-F]+-[0-9a-fA-F]+$")
usb_log_path=""

if [ -z $usb_name ]; then
    usb_existed=0
else
    if [ -e "/mnt/media_rw/$usb_name/.logcatcher-enable" ]; then
        cur_filenum=$(get_cur_filenum "/mnt/media_rw/$usb_name/logcatcher")
        cur_file_folder="/mnt/media_rw/$usb_name/logcatcher/$cur_filenum"
        mkdir -p $cur_file_folder
        usb_log_path="$cur_file_folder/tee"
        mkdir -p $usb_log_path
        # find and exec will fail by running as a service
        for file in `find $cur_file_folder -maxdepth 1 -type f -name "*.log"`;
        do
            mv  $file $usb_log_path
        done
        usb_existed=1
    fi
fi

if [ $usb_existed -eq 0 ]; then
    /vendor/bin/tee_log_service $emmc_lob_path 15 1
else
    /vendor/bin/tee_log_service $usb_log_path 15 1
fi

