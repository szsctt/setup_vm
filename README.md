# setup_vm

```
gcloud compute instances create instance-1 --project=mine-355502 --zone=australia-southeast1-b --machine-type=e2-medium --network-interface=network-tier=PREMIUM,subnet=default --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=mine-service-account@mine-355502.iam.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20220712,mode=rw,size=10,type=projects/mine-355502/zones/australia-southeast1-b/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud compute ssh instance-1

gcloud compute ssh instance-1 -- -NL 8888:localhost:8888 

gcloud compute instances set-machine-type instance-1 --machine-type e2-highmem-2
```

[List of instance types on GCP](https://gcpinstances.doit-intl.com/)



Access:
https://cloud.google.com/architecture/building-internet-connectivity-for-private-vms


Sharing images between accounts:
[creating](https://cloud.google.com/compute/docs/images/create-custom)
[sharing](https://cloud.google.com/compute/docs/images/managing-access-custom-images)


Creating ssh key:
https://www.linode.com/docs/guides/use-public-key-authentication-with-ssh/


