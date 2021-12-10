#!/bin/bash
eval "$(jq -r '@sh "export chart=\(.chart) region=\(.region) project_id=\(.project_id)"')"
gcloud container clusters get-credentials ${project_id}-gke  --region  $region 
username=$(helm -n $chart status $chart | grep username: | head -n 1 | cut -d ':' -f2 | tr -d ' ')
password=$(helm -n $chart status $chart | grep password: | head -n 1 | cut -d ':' -f2 | tr -d ' ')
jq -n \
      --arg username "$username" \
      --arg password "$password" \
      '{"username":$username,"password":$password}'
