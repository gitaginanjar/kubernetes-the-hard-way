printf "\n\n01-Prerequisites - Kubernetes The Hard Way\n"
printf "\nhttps://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/01-prerequisites.md\n"




printf "\n01.a-Install the Google Cloud SDK"
printf "https://cloud.google.com/sdk/docs/quickstart-linux"

sudo apt install -y curl wget tmux

curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-262.0.0-linux-x86_64.tar.gz

tar zxf google-cloud-sdk-*-linux-x86_64.tar.gz google-cloud-sdk

sudo bash google-cloud-sdk/install.sh

gcloud version

printf "\n01.b-Set a Default Compute Region and Zone\n"
gcloud config set compute/region asia-southeast1
gcloud config set compute/zone asia-southeast1-b

gcloud components install app-engine-go

sudo apt install -y google-cloud-sdk-app-engine-go
