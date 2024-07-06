#!/bin/sh

#set -e

ARCH=`uname -m`
CORES=`nproc`

AWS_HOME=/root/.aws
AWS_ACCESS_KEY_ID=********************
AWS_SECRET_ACCESS_KEY=**********************
ARTIFACTS_BUCKET=s3://cropdroid/artifacts/arm64
INSTALL_USER=ubuntu

GITHUB_USER=jeremyhahn
GITHUB_TOKEN=**********************

CROPDROID_VERSION=feature/clustering
ROCKSDB_VERSION=v6.10.2
COCKROACH_VERSION=v20.1.4
GO_VERSION=1.15.7

GO_HOME=$HOME/go
mkdir -p $GO_HOME

SOURCES=$HOME/sources

COCKROACH_HOME=$GO_HOME/src/github.com/cockroachdb/cockroach
mkdir -p $COCKROACH_HOME

CROPDROID_HOME=$SOURCES/go-cropdroid
mkdir -p $CROPDROID_HOME

mkdir $AWS_HOME
cat <<EOF >$AWS_HOME/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF

# Install golang
wget https://golang.org/dl/go$GO_VERSION.linux-arm64.tar.gz
tar -C /usr/local -xzf go$GO_VERSION.linux-arm64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
export PATH=$PATH:/usr/local/go/bin


# Build CockroachDB
cd $SOURCES
apt-get install -y build-essential autoconf bison cmake ccache libtinfo-dev
wget -qO- https://binaries.cockroachdb.com/cockroach-$COCKROACH_VERSION.src.tgz | tar  xvz
cd cockroach-$COCKROACH_VERSION
#https://github.com/cockroachdb/cockroach/pull/58895/commits/0de1fd4d19b9cf39ea2c4cce668714c8ec9394b4
#CFLAGS="-fcommon"
make -j$CORES build
make install


# Build RocksDB
apt-get install -y libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev libzstd-dev liblz4-dev
cd $SOURCES
git clone --depth=1 https://github.com/facebook/rocksdb.git
cd rocksdb
git fetch --all --tags
git checkout tags/$ROCKSDB_VERSION
#ubuntu-20.04-arm64: CFLAGS="-Wno-deprecated-copy -Wno-redundant-move -Wno-pessimizing-move" make static_lib
#raspios-arm64:      CFLAGS="-Wno-unused-function" make static_lib
CFLAGS="-Wno-unused-function" make -j$CORES static_lib
make -j$CORES install-static


# Build CropDroid
cd $SOURCES
git clone https://$GITHUB_USER:$GITHUB_TOKEN@github.com/jeremyhahn/cropdroid go-cropdroid
cd $CROPDROID_HOME
git checkout $CROPDROID_VERSION
make -j$CORES build-cluster-$ARCH-static
cp cropdroid /usr/local/bin/cropdroid


# RaspiOS arm64 kernel
#echo "kernel=kernel8.img" >> /boot/config.txt


# Upload to S3
#aws s3 cp /usr/local/bin/cropdroid $ARTIFACTS_BUCKET/cropdroid
#aws s3 cp /usr/local/bin/cockroach $ARTIFACTS_BUCKET/cockroach
#aws s3 cp /usr/local/lib/librocksdb.* $ARTIFACTS_BUCKET/
