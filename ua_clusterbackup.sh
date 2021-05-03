#!/usr/bin/bash #!/usr/bin/env bash

dx select "002_210222_cluster_archive" # project-G0pJggj45qJxX84V6g7gjzG1
PROJECT='project-G0pJggj45qJxX84V6g7gjzG1'
UA="/mnt/storage/apps/software/dnanexus_ua/1.5.31/ua"
LOGS="/mnt/storage/home/ratkais/archiveVCF/backuplogs"

while read folderName; do # $folderName is the name, $runfolder is the absolute path
    # read name of runfolder from input file: one runfolder per line
    runfolder=/mnt/storage/data/NGS/$folderName
    echo $runfolder

    # upload files in root of runfolder
    $UA --project $PROJECT ${runfolder} > $LOGS/$folderName.log
    s=0 # --do-not-compress --project "002_210222_cluster_archive"
    while s=0; do
    case `grep "failed" $LOGS/$folderName.log > /dev/null; echo $?` in
        0)
        echo $folderName >> $LOGS/failed_folders.log
        # if upload of any files failed, repeat upload
        $UA --project $PROJECT ${runfolder} > $LOGS/$folderName.log
        ;;
        1)
        echo "$folderName moving on" >> $LOGS/completed_folders.log
        s=1
        break
        ;;
        *)
        echo "$folderName grep error" >> $LOGS/errorfolders.log
        ;;
    esac
    done

    # upload files in runfolder/vcfs, logs, stats
    for folder in $( ls -d $runfolder/*/ ); do # $folder is the absolute path!!
        subdir=$( basename ${folder} )
        if [[ $subdir == logs ]] || [[ $subdir == stats ]] || [[ $subdir == vcfs ]]; then
            echo ${runfolder}/${subdir}
            $UA --project $PROJECT --folder /$folderName ${runfolder}/${subdir} --recursive > $LOGS/$folderName_$subdir.log
            s=0
            while s=0; do
            case `grep "failed" $LOGS/$folderName_$subdir.log > /dev/null; echo $?` in
                0)
                echo $folderName_$subdir >> $LOGS/failed_folders.log
                # if upload of any files failed, repeat upload
                $UA --project $PROJECT --folder /$folderName ${runfolder}/${subdir} --recursive > $LOGS/$folderName_$subdir.log
                ;;
                1)
                echo "$folderName_$subdir moving on" >> $LOGS/completed_folders.log
                s=1
                break
                ;;
                *)
                echo "$folderName_$subdir grep error" >> $LOGS/errorfolders.log
                ;;
            esac
            done
        fi
    done
done < $1
