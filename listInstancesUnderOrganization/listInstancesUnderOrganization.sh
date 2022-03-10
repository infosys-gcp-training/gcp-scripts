#!/bin/bash
fltr=$1
project_id=$2
echo "Filter: $1"
echo "Project Id: $2"
echo $(gcloud organizations list | awk '{print $2}' | tail -n +2)
for org in $(gcloud organizations list | awk '{print $2}' | tail -n +2)
do
	echo "Looking inside the Organization..." $org
	echo $(gcloud projects list --filter 'project_id='$project_id | tail -n +2)
# Iteration in projects 
	#for prj in $(gcloud projects list --filter 'parent.id='$org' AND parent.type=organization AND name=$project_id' | awk '{print $1}' | tail -n +2)
	#for prj in $(gcloud projects list --filter 'name='$project_id | awk '{print $1}' | tail -n +2)
	for prj in $(gcloud projects list --filter 'project_id='$project_id | awk '{print $1}' | tail -n +2)
	do
		echo "Searching projects... " $prj
	# Iteration vm inside project
		#for vm in $(gcloud compute instances list | awk '{print $1, $3}' | tail -n +2)
		for machine_type_uri in $(gcloud compute instances list --project $prj --format="table(machine_type)" | tail -n +2 )
		do
			machine_type=${machine_type_uri##*/} 
			echo "Machine Type: $machine_type"
			# Looking for those with machine type -ext
			if [[ "$machine_type" == *$fltr ]]
			then
				echo "================================"
				echo "ORGANIZATION = "$org
				echo "PROJECT = " $prj
				echo "MACHINE TYPE = " $machine_type
				echo "================================"
			fi
			#echo -e "Looking for another project... \n"
		done
	done
	echo -e "Trying other organization... \n"
done
