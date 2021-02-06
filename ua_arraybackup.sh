#!/usr/bin/bash
p=$1

while read r; do
echo "$p"/"$r"
/mnt/storage/apps/software/dnanexus_ua/1.5.31/ua --do-not-compress --project 002_750k_data_backup "$p"/"$r" --recursive >"$p"/logs/"$r".log
s=0
while s=0; do
case `grep "failed" "$p"/logs/"$r".log >/dev/null; echo $?` in
0)
echo "$r" >>"$p"/logs/failed_folders.log
/mnt/storage/apps/software/dnanexus_ua/1.5.31/ua --do-not-compress --project 002_750k_data_backup "$p"/"$r" --recursive >"$p"/logs/"$r".log
;;
1)
echo "$r moving on" >>"$p"/logs/completed_folders.log
s=1
break
;;
*)
echo "$r grep error" >>"$p"/logs/errorfolders.log
;;
esac

done
done < "$p"/manifests/backup_on_C.txt
