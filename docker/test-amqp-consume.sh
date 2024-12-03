#!/bin/bash

amqp-consume --server=localhost --port=5672 \
    --vhost=/ \
    --username=geo --password=geo \
    --exchange=exchange_geo \
    --routing-key=geopoints.processed \
    --queue=geopoints.processed \
    cat
