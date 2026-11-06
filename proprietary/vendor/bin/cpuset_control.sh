#!/vendor/bin/sh
/vendor/bin/sleep 100
echo "0-3" > /dev/cpuset/top-app/cpus
echo "0-3" > /dev/cpuset/foreground/cpus
echo "0-3" > /dev/cpuset/background/cpus
echo "0-3" > /dev/cpuset/system-background/cpus
echo "0-3" > /dev/cpuset/restricted/cpus

#CH_VALUE=NO
#CHD_VALUE=NO
#RETRY_COUNT=0
#SLEEP_TIME=30
#LIMIT=200
#DEF_MIN=`cat /proc/sys/vm/min_free_kbytes`
#DEF_EXTRA=`cat /proc/sys/vm/extra_free_kbytes`
#DEF_FACTOR=`cat /proc/sys/vm/watermark_scale_factor`
#
#while [ 1 ]
#do
#/vendor/bin/sleep $SLEEP_TIME
#TVTS=`getprop vendor.omxrtk.tvts`
#if [ "$TVTS" = "1" ]; then
#    CH_VALUE=YES
#    RETRY_COUNT=0
#    SLEEP_TIME=5
#elif [ "$TVTS" = "0" ]; then
#    RETRY_COUNT=$(($RETRY_COUNT+1))
#    if [ "$LIMIT" -lt "$RETRY_COUNT" ]; then
#        CH_VALUE=NO
#        RETRY_COUNT=0
#        SLEEP_TIME=30
#    fi
#fi
#
#if [ "$CH_VALUE" = "YES" ] && [ "$CHD_VALUE" = "NO" ]; then
#    echo "1024" > /proc/sys/vm/extra_free_kbytes
#    echo "5496" > /proc/sys/vm/min_free_kbytes
#    echo "20" > /proc/sys/vm/watermark_scale_factor
#    CHD_VALUE=YES
#fi
#
#if [ "$CH_VALUE" = "NO" ] && [ "$CHD_VALUE" = "YES" ]; then
#    echo $DEF_EXTRA > /proc/sys/vm/extra_free_kbytes
#    echo $DEF_MIN > /proc/sys/vm/min_free_kbytes
#    echo $DEF_FACTOR > /proc/sys/vm/watermark_scale_factor
#    CHD_VALUE=NO
#fi
#
#done
