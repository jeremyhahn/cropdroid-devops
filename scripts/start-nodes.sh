docker run -d \
        --name roach1 \
        --hostname=roach1 \
        --net=cropnet \
        -p 26257:26257 -p 8080:8080  \
        -v "${PWD}/cockroach-data:/cockroach/cockroach-data"  \
        jeremyhahn/builder-cockroach-ubuntu cockroach start \
        --insecure \
        --join=roach1,roach2,roach3
docker run -d \
        --name cropdroid-c1-n1 \
        --hostname=cropdroid-c1-n1 \
        --net=cropnet \
        --ip 172.20.0.11 \
        -p 80:80 -p 60010:60010 -p 60020:60020 \
        -v "${PWD}/cropdroid-data:/cropdroid/db" \
        jeremyhahn/cropdroid-builder-cluster-ubuntu /cropdroid/cropdroid cluster \
        --debug \
        --ssl=false \
        --datastore cockroach \
        --datastore-host roach1 \
        --enable-registrations \
        --listen 172.20.0.11 \
        --raft "192.168.0.157:60020,192.168.0.156:60020,192.168.0.139:60020"
docker logs -f cropdroid-c1-n1

docker run -d \
        --name roach2 \
        --hostname=roach2 \
        --net=cropnet \
        -p 26257:26257 -p 8080:8080  \
        -v "${PWD}/cockroach-data:/cockroach/cockroach-data"  \
        jeremyhahn/builder-cockroach-ubuntu cockroach start \
        --insecure \
        --join=roach1,roach2,roach3
docker run -d \
        --name cropdroid-c1-n2 \
        --hostname=cropdroid-c1-n2 \
        --net=cropnet \
        --ip 172.20.0.12 \
        -p 80:80 -p 60010:60010 -p 60020:60020 \
        -v "${PWD}/cropdroid-data:/cropdroid/db" \
        jeremyhahn/cropdroid-builder-cluster-ubuntu /cropdroid/cropdroid cluster \
        --debug \
        --ssl=false \
        --datastore cockroach \
        --datastore-host roach2 \
        --enable-registrations \
        --listen 192.168.0.156 \
        --gossip-peers "192.168.0.157:60010" \
        --raft "192.168.0.157:60020,192.168.0.156:60020,192.168.0.139:60020"
docker logs -f cropdroid-c1-n2

docker run -d \
        --name roach3 \
        --hostname=roach3 \
        --net=cropnet \
        -p 26257:26257 -p 8080:8080  \
        -v "${PWD}/cockroach-data:/cockroach/cockroach-data"  \
        jeremyhahn/builder-cockroach-ubuntu cockroach start \
        --insecure \
        --join=roach1,roach2,roach3
docker run -d \
        --name cropdroid-c1-n3 \
        --hostname=cropdroid-c1-n3 \
        --net=cropnet \
        --ip 172.20.0.13 \
        -p 80:80 -p 60010:60010 -p 60020:60020 \
        -v "${PWD}/cropdroid-data:/cropdroid/db" \
        jeremyhahn/cropdroid-builder-cluster-ubuntu /cropdroid/cropdroid cluster \
        --debug \
        --ssl=false \
        --datastore cockroach \
        --datastore-host roach3 \
        --enable-registrations \
        --listen 192.168.0.139 \
        --gossip-peers "192.168.0.157:60010,192.168.0.156:60010" \
        --raft "192.168.0.157:60020,192.168.0.156:60020,192.168.0.139:60020"
docker logs -f cropdroid-c1-n3


docker exec -it roach1 cockroach init --insecure
docker exec -it cropdroid-c1-n1 /cropdroid/cropdroid config --init --datastore cockroach --datastore-host roach1
