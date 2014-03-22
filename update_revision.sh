#!/bin/sh

# run with the Git command prompt (git-cmd.bat)
# sh update_revision.sh

cur_version=`cat AssemblyInfo.cs | sed -n 's/\[.*AssemblyVersionAttribute("//p' | sed -n 's/")]//p'`
cur_revision=`echo $cur_version | awk -F$'.' '{print $3}'`
new_revision=`git rev-list HEAD | wc -l | awk '{print $1+6}'`
echo "#define REVISION "$new_revision>revision.h
new_version=${cur_version/${cur_revision}/${new_revision}}

sed -i 's/'$cur_version'/'$new_version'/g;s/$/\r/' AssemblyInfo.cs
