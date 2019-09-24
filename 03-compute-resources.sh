printf "\n03-Compute Resources - Kubernetes The Hard Way\n"
printf "\nhttps://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-compute-resources.md\n"

printf "\n03.a-Virtual Private Cloud Network\n"
gcloud compute networks create kubernetes-the-hard-way --subnet-mode custom

gcloud compute networks subnets create kubernetes --region asia-southeast1 --network kubernetes-the-hard-way --range 10.240.0.0/24

gcloud compute addresses create kubernetes-the-hard-way --region asia-southeast1

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

printf "\n03.c-Kubernetes Public IP Address\n"
gcloud compute addresses create kubernetes-the-hard-way --region asia-southeast1
gcloud compute addresses list


gcloud compute instances create kubernetes-the-hard-way \
	--async \
	--boot-disk-size 200GB \
	--can-ip-forward \
	--image-family ubuntu-1804-lts \
	--image-project ubuntu-os-cloud \
	--custom-cpu 1 \
	--custom-memory 1 \
	--private-network-ip 10.240.0.5 \
	--scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
	--subnet kubernetes \
	--tags kubernetes-the-hard-way \
	--zone asia-southeast1-b \
	--service-account=gita-ginanjar-bukalapak-com@gin-hardway-staging-f536.iam.gserviceaccount.com
	

printf "\n03.d-Kubernetes Controllers\n"
for i in 0 1 2; do gcloud compute instances create controller-${i} \
	--async \
	--boot-disk-size 200GB \
	--can-ip-forward \
	--image-family ubuntu-1804-lts \
	--image-project ubuntu-os-cloud \
	--custom-cpu 1 \
	--custom-memory 1 \
	--private-network-ip 10.240.0.1${i} \
	--scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
	--subnet kubernetes \
	--tags kubernetes-the-hard-way,controller \
	--zone asia-southeast1-b \
	--service-account=gita-ginanjar-bukalapak-com@gin-hardway-staging-f536.iam.gserviceaccount.com; done

printf "\n03.e-Kubernetes Workers\n"
for i in 0 1 2; do gcloud compute instances create worker-${i} \
	--async \
	--boot-disk-size 200GB \
	--can-ip-forward \
	--image-family ubuntu-1804-lts \
	--image-project ubuntu-os-cloud \
	--custom-cpu 1 \
	--custom-memory 1 \
	--metadata pod-cidr=10.200.${i}.0/24 \
	--private-network-ip 10.240.0.2${i} \
	--scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
	--subnet kubernetes \
	--tags kubernetes-the-hard-way,worker \
	--zone asia-southeast1-b \
	--service-account=gita-ginanjar-bukalapak-com@gin-hardway-staging-f536.iam.gserviceaccount.com; done

printf "\n03.f-Verification\n"
sleep 25s
gcloud compute instances list

printf "\n03.g-Configuring SSH Access\n"


for i in 0 1 2; do gcloud compute ssh controller-${i} \
	--force-key-file-overwrite  \
	--strict-host-key-checking=no \
	--zone asia-southeast1-b \
	--quiet \
	--command=exit; done

for i in 0 1 2; do gcloud compute ssh worker-${i} \
	--force-key-file-overwrite \
	--strict-host-key-checking=no  \
	--zone asia-southeast1-b \
	--quiet \
	--command=exit; done


