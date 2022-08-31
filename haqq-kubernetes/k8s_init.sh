#!/bin/bash

NETWORK=haqq_53211-1
MONIKER=nodeblocks

if [ -f "/root/.haqqd/haqq-k8s-init" ]; then
    echo already init
else
    haqqd config chain-id $NETWORK
    haqqd init $MONIKER -o --chain-id $NETWORK
    touch /root/.haqqd/haqq-k8s-init
fi

if [ -f "/root/.haqqd/haqq-k8s-genesis" ]; then
    echo already downloaded
else
    wget https://storage.googleapis.com/haqq-testedge-snapshots/genesis.json -O /root/.haqqd/config/genesis.json
    touch /root/.haqqd/haqq-k8s-genesis
fi

if [ -f "/root/.haqqd/haqq-k8s-state-sync" ]; then
    echo state-sync already configured
else
    wget https://raw.githubusercontent.com/haqq-network/testnets/main/TestEdge/state_sync.sh -O state_sync.sh
    bash state_sync.sh
    touch /root/.haqqd/haqq-k8s-state-sync
fi
