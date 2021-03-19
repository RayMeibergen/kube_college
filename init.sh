#!/bin/bash

source /root/.bashrc

if [[ ! -e /root/.aws/config ]]; then
    mv /root/.aws/config.default /root/.aws/config
fi

if [[ ! -e /root/.aws/credentials ]]; then
    mv /root/.aws/credentials.default /root/.aws/credentials
fi