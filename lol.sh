#!/bin/bash

NAMESPACE=$1

for RESOURCE_NAME in StatefulSet boshdeployments extendedjobs extendedsecrets extendedstatefulsets; do
    kubectl -n "${NAMESPACE}" get "${RESOURCE_NAME}" --no-headers | awk '{print $1}' | while read -r ITEM; do
      if [ "${ITEM}" != "" ]; then
        kubectl -n "${NAMESPACE}" patch "${RESOURCE_NAME}" "${ITEM}"  --type json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
      fi
    done
done
