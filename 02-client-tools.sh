printf "\n02-Client Tools - Kubernetes The Hard Way\n"
printf "\nhttps://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/02-client-tools.md\n"

printf "\n02.a-Install CFSSL\n"

wget -q --https-only --timestamping https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -O cfssl

wget -q --https-only --timestamping https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -O cfssljson

chmod +x cfssl

chmod +x cfssljson

sudo mv cfssl /usr/local/bin/cfssl

sudo mv cfssljson /usr/local/bin/cfssljson

printf "\n02.b-Verification\n"
cfssl version

printf "\n02.c-Install kubectl\n"
wget -q --https-only --timestamping https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl -O kubectl

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

kubectl version --client

