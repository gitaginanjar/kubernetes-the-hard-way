printf "\n06-Generating the Data Encryption Config and Key - Kubernetes The Hard Way\n"
printf "\nhttps://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/06-data-encryption-keys.md\n"

printf "\n06.a-The Encryption Key\n"
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

printf "\n06.b-The Encryption Config File\n"
cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

for instance in controller-0 controller-1 controller-2 ; do gcloud compute scp encryption-config.yaml ${instance}:~/ ; done

