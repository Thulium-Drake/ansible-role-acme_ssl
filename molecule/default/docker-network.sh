#!/bin/bash
echo "Creating ACMEnet if not present"
docker network create --attachable --subnet 10.30.50.0/24 acmenet &>/dev/null || exit 0
