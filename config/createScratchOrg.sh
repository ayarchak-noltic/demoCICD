now=$(date "+%s")
username="test-u_$now@example.com"
orgAlias="Scratch_$now"
sfdx force:org:create -f project-scratch-def.json -v andriy.yarchak.20@playful-goat-290lbh.com -a "$orgAlias"
echo "Org created"
echo "$username"
sfdx force:org:display -u "$orgAlias" --verbose
echo "Finished creating scratch org"
echo $(date "+%F %H:%M:%S")
