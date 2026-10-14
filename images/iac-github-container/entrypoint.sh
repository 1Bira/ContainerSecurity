#!/usr/bin/env bash
set -e 

TOKEN=$3
#NAME=$4

#if [ -z "$RUNNER_NAME" ] || [ -z "$RUNNER_TOKEN" ] || [ -z "$REPO_URL" ]; then
#    echo "Erro: as seguintes variaveis de ambiente são obrigatorias"
#    echo "RUNNER_NAME, PAT_TOKEN, RUNNER_REPOSITORY_URL"
#    exit 1
#fi
ACCESS_TOKEN=$PAT_TOKEN

REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/love-all/dev-love/actions/runners/registration-token | jq .token --raw-output)

if [ -z "$REG_TOKEN" ]; 
then
    echo "Erro: a variavel REG_TOKEN esta vazia"
    exit 1
fi

#echo "REG_TOKEN: ${REG_TOKEN}"

./config.sh \
    --url   https://github.com/love-all/dev-love \
    --token ${REG_TOKEN} \
    --name  lov-runner-app-prod \
    --work  _work \
    --labels azcli,app,prod

./run.sh

