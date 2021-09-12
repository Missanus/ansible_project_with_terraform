SNAPSHOT_LOG_FILE="/var/log/ec2_snapshot.log"

REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed -e 's/.$//')
AWS="aws --region $REGION"

function log_msg()
{
	local MSG="$(date +"%Y-%m-%d %H:%M:%S" --utc) - ${*}" 
    echo $MSG >> "${SNAPSHOT_LOG_FILE}"
    #echo $MSG
}

# Numbers of holding snapshots
# 0: delete no snapshots
SNAPSHOTS_PERIOD=3
# Set extra tags
EXTRA_TAGS="Key=Name,Value=app-instance-flyway-vol"

#REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed -e 's/.$//')
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
HOSTNAME=$(hostname -s)
DATE=$(date +"%Y-%m-%d %H:%M:%S" --utc)


# Target EBS volume id
VOL_ID=$($AWS ec2 describe-instances --instance-ids "$INSTANCE_ID" | jq -r '.Reservations[].Instances[].BlockDeviceMappings[].Ebs.VolumeId')
if [ -z "$VOL_ID" ]; then
    log_msg "ERROR: no EBS ID."
    exit 1
fi

# create a snapshot
log_msg "Creating snapshot."
SNAPSHOT=$($AWS ec2 create-snapshot --volume-id "$VOL_ID" --description "Created by ec2snapshot ($INSTANCE_ID) from $VOL_ID")
RET=$?
if [ $RET != 0 ]; then
    log_msg "$SNAPSHOT"
    log_msg "ERROR: create-snapshot failed:$RET"
    exit 2
fi
SNAPSHOT_ID=$(echo $SNAPSHOT | jq -r '.SnapshotId')
$AWS ec2 create-tags --resources "$SNAPSHOT_ID" --tags "Key=Name,Value=$HOSTNAME $DATE" "Key=Hostname,Value=$HOSTNAME" $EXTRA_TAGS
log_msg "$SNAPSHOT_ID \($HOSTNAME $DATE\) created."

# delete old snapshots
if [ $SNAPSHOTS_PERIOD -ge 1 ]; then
    log_msg "Deleting old snapshots."
    SNAPSHOTS=$($AWS ec2 describe-snapshots --owner-ids self --filters "Name=volume-id,Values=$VOL_ID" --query "reverse(sort_by(Snapshots,&StartTime))[$SNAPSHOTS_PERIOD:].[SnapshotId,StartTime]" --output text)
    while read snapshotid starttime; do
	if [ -z "$snapshotid" ]; then
	    continue
	fi
	$AWS ec2 delete-snapshot --snapshot-id "$snapshotid"
	RET=$?
	if [ $RET != 0 ]; then
	    log_msg "ERROR: delete-snapshot $snapshotid failed:$RET"
	    exit 3
	fi
	log_msg "$snapshotid \($starttime\) deleted."
    done <<EOF
$SNAPSHOTS
EOF
fi

exit 0