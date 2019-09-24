printf "\n03-Compute Resources - Kubernetes The Hard Way\n"
printf "\nhttps://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-compute-resources.md\n"

printf "\n03.a-Virtual Private Cloud Network\n"
gcloud compute networks create kubernetes-the-hard-way --subnet-mode custom

gcloud compute networks subnets create kubernetes --region asia-southeast1 --network kubernetes-the-hard-way --range 10.240.0.0/24

sleep 5s

gcloud compute addresses create kubernetes-the-hard-way --region asia-southeast1
gcloud compute addresses list

printf "\n03.b-Firewall Rules\n"
gcloud compute firewall-rules create kubernetes-the-hard-way-allow-external \
	--allow tcp:22,tcp:6443,icmp \
	--network kubernetes-the-hard-way \
	--source-ranges 0.0.0.0/0
gcloud compute firewall-rules create kubernetes-the-hard-way-allow-internal \
	--allow tcp,udp,icmp \
	--network kubernetes-the-hard-way \
	--source-ranges 10.240.0.0/24,10.200.0.0/16 
	
gcloud compute firewall-rules list

printf "\n00.c-Kubernetes Instance Creation\n"


gcloud beta compute --project=gin-hardway-staging-f536 instances create kubernetes-the-hard-way --zone=asia-southeast1-b --machine-type=custom-1-1024 --subnet=kubernetes --network-tier=PREMIUM --can-ip-forward --maintenance-policy=MIGRATE --service-account=project-service-account@gin-hardway-staging-f536.iam.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform --tags=http-server,https-server --image=debian-9-stretch-v20190916 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-size=200GB --boot-disk-type=pd-standard --boot-disk-device-name=kubernetes-the-hard-way --reservation-affinity=any

gcloud compute --project=gin-hardway-staging-f536 firewall-rules create kubernetes-the-hard-way-allow-http --direction=INGRESS --priority=1000 --network=kubernetes-the-hard-way --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

gcloud compute --project=gin-hardway-staging-f536 firewall-rules create kubernetes-the-hard-way-allow-https --direction=INGRESS --priority=1000 --network=kubernetes-the-hard-way --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server
	
gcloud compute scp ~/kubernetes-the-hard-way/* kubernetes-the-hard-way:~/. \
	--force-key-file-overwrite  \
	--strict-host-key-checking=no \
	--zone asia-southeast1-b \
	--quiet

gcloud compute ssh kubernetes-the-hard-way --command="gcloud init"