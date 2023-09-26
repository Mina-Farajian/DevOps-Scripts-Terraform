#!/bin/bash

#namespaces= "rc pro monitoring kube-system default"
today=`date +%m-%d-%Y`

for ns in is-rc tc-rc is-pro tc-pro default kube-system default nfs-provisioner monitoring ; do
          echo "Backing up namespace: $ns"
          echo "Creating backup directory: /tmp/kube-backup/bkp-$today/"
          mkdir -p /tmp/kube-backup/bkp-$today/$ns
          echo "Running backups for namespace: $ns"
          kubectl get deployment,statefulset,daemonset,replicaset --namespace=$ns -o=yaml > /tmp/kube-backup/bkp-$today/$ns/deployments.yaml
          kubectl get service --namespace=$ns -o=yaml > /tmp/kube-backup/bkp-$today/$ns/services.yaml
	  kubectl get secrets --namespace=$ns -o=yaml > /tmp/kube-backup/bkp-$today/$ns/secrets.yaml
          kubectl get configmap --namespace=$ns -o=yaml > /tmp/kube-backup/bkp-$today/$ns/configmaps.yaml
          kubectl get cronjob --namespace=$ns -o=yaml > /tmp/kube-backup/bkp-$today/$ns/cronjobs.yaml
	  kubectl get networkpolicy --namespace=$ns -o=yaml > /tmp/kube-backup/bkp-$today/$ns/network-policy.yaml
          kubectl get role,rolebinding,serviceaccount --namespace=$ns -o=yaml | sed '/^[[:space:]]*creationTimestamp/d' > /tmp/kube-backup/bkp-$today/$ns/accesses.yaml
done

for ns in is-rc tc-rc is-pro tc-pro default kube-system default nfs-provisioner monitoring; do


        mkdir -p /tmp/kube-backup/bkp-$today/$ns/$ns-detail
	mkdir -p /tmp/kube-backup/bkp-$today/$ns/$ns-detail/service
	mkdir -p /tmp/kube-backup/bkp-$today/$ns/$ns-detail/configmap
	mkdir -p /tmp/kube-backup/bkp-$today/$ns/$ns-detail/cronjob
	mkdir -p /tmp/kube-backup/bkp-$today/$ns/$ns-detail/role
	mkdir -p /tmp/kube-backup/bkp-$today/$ns/$ns-detail/deployment
	mkdir -p /tmp/kube-backup/bkp-$today/$ns/$ns-detail/secret
	mkdir -p /tmp/kube-backup/bkp-$today/$ns/$ns-detail/network-policy
	echo "Running backups for namespace: $ns"

	for svc in $(kubectl get service --namespace=$ns -o=name) ; do
          kubectl get "$svc" --namespace=$ns -o=yaml > "/tmp/kube-backup/bkp-$today/$ns/$ns-detail/service/$(echo "$svc" | cut -d/ -f2)-svc.yaml"
        done
        for cm in $(kubectl get configmap --namespace=$ns -o=name); do
          kubectl get "$cm" --namespace=$ns -o=yaml > "/tmp/kube-backup/bkp-$today/$ns/$ns-detail/configmap/$(echo "$cm" | cut -d/ -f2)-cofgmp.yaml"
        done
        for cj in $(kubectl get cronjob --namespace=$ns -o=name); do
          kubectl get "$cj" --namespace=$ns -o=yaml > "/tmp/kube-backup/bkp-$today/$ns/$ns-detail/cronjob/$(echo "$cj" | cut -d/ -f2)-cronjob.yaml"
        done
        for role in $(kubectl get role,rolebinding,serviceaccount --namespace=$ns -o=name); do
          kubectl get "$role" --namespace=$ns -o=yaml | sed '/^[[:space:]]*creationTimestamp/d' > "/tmp/kube-backup/bkp-$today/$ns/$ns-detail/role/$(echo "$role" | cut -d/ -f2)-role.yaml"
        done
	for dp in $(kubectl get deployment --namespace=$ns -o=name); do
          kubectl get "$dp" --namespace=$ns -o=yaml > "/tmp/kube-backup/bkp-$today/$ns/$ns-detail/deployment/$(echo "$dp" | cut -d/ -f2)-dep.yaml"

      done
      for nw in $(kubectl get networkpolicy --namespace=$ns -o=name); do
          kubectl get "$nw" --namespace=$ns -o=yaml > "/tmp/kube-backup/bkp-$today/$ns/$ns-detail/network-policy/$(echo "$nw" | cut -d/ -f2)-nw.yaml"

      done
      for se in $(kubectl get secret --namespace=$ns -o=name); do
          kubectl get "$se" --namespace=$ns -o=yaml > "/tmp/kube-backup/bkp-$today/$ns/$ns-detail/secret/$(echo "$se" | cut -d/ -f2)-sec.yaml"
        done
    done
############################################## Rsync #############################################################################################
backup_file="/tmp/kube-backup/"

#remote server's hostname or IP address
remote_server="10.10.10.2"

#remote server to store the backup file
remote_path="/home/bk-test/backup/kuber"

  # rsync the updated config file to the remote server
  rsync -av --progress $backup_file bk-user@$remote_server:$remote_path
