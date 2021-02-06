import os
import collections
path = "/mnt/storage/samba/samba.ctrulab.uk/cytogenetics/201016_750k_data_backup/log_checks/"
C_folder_path = raw_input('Please provide the full path to the list of folders on C.txt ')
N_folder_path = raw_input('Please provide the full path to the list of folders on N.txt ')

PC_folders=[]
N_folders=[]
missing_folders = []

with open(C_folder_path, 'r') as PCfolders:
    for line in PCfolders:
        PC_folders.append(line.strip('\n'))
with open(N_folder_path, 'r') as Nfolders:
    for line in Nfolders:
        N_folders.append(line.strip('\n'))

for i in range(len(PC_folders)):
    if PC_folders[i] not in N_folders:
        missing_folders.append(PC_folders[i])

with open(path+"missedFolders.txt", 'w') as MF:
    for f in missing_folders:
        MF.write(f+"\n")

print "Done!"
