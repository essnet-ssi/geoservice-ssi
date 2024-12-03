#!/bin/bash

message="{\"settings\": {\"temporal_threshold_seconds\": 180, \"spatial_threshold_meter\": 50, \"start_new_cluster_seconds\": 84600, \"start_new_cluster_meter\": 500, \"accuracy_meter\": 100}, \"id\": \"sadf\", \"geopoints\": [], \"geolocations\": [], \"metadata\": null}"


amqp-publish --server=localhost --port=5672 \
    --vhost=/ \
    --username=geo --password=geo \
    --exchange=exchange_geo \
    --routing-key=geopoints.process \
    -C application/json \
    -b "$message"
