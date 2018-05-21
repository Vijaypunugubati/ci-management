#!/bin/bash -eu
set -o pipefail

rm -rf ${WORKSPACE}/gopath/src/github.com/hyperledger/fabric
mkdir -p ${WORKSPACE}/gopath/src/github.com/hyperledger/fabric
WD="${WORKSPACE}/gopath/src/github.com/hyperledger/fabric"
FABRIC_REPO_NAME=fabric

cd ${WORKSPACE}/gopath/src/github.com/hyperledger/$FABRIC_REPO_NAME
git clone git://cloud.hyperledger.org/mirror/$FABRIC_REPO_NAME $WD
cd $WD
git fetch --tags --progress git://cloud.hyperledger.org/mirror/$FABRIC_REPO_NAME +refs/tags/*:refs/remotes/origin/tags/*
fabricLatestTag="$(git describe --tags "`git rev-list --tags --max-count=1`")"
echo "===> Checkingout to $fabricLatestTag"
git checkout $fabricLatestTag

make docker && docker images | grep hyperledger

# Clone fabric-ca git repository
################################

rm -rf ${WORKSPACE}/gopath/src/github.com/hyperledger/fabric-ca
mkdir -p ${WORKSPACE}/gopath/src/github.com/hyperledger/fabric-ca
WD="${WORKSPACE}/gopath/src/github.com/hyperledger/fabric-ca"
CA_REPO_NAME=fabric-ca
git clone git://cloud.hyperledger.org/mirror/$CA_REPO_NAME $WD
cd $WD
git fetch --tags --progress git://cloud.hyperledger.org/mirror/$CA_REPO_NAME +refs/tags/*:refs/remotes/origin/tags/*
caLatestTag="$(git describe --tags "`git rev-list --tags --max-count=1`")"
echo "===> Checkingout to $caLatestTag"
git checkout $caLatestTag
make docker-fabric-ca && docker images | grep hyperledger
