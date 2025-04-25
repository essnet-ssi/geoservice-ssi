# geoservice-ssi

Microservice which performs trajectory segmentation based on self-Adapting Trajectory Segmentation[1] and OPTICS clustering[2].

1. Agnese Bonavita, Riccardo Guidotti, Mirco Nanni. “Self-Adapting Trajectory Segmentation.” In EDBT/ICDT Workshop on Big Mobility Data Analytics (BMDA 2020), CEUR, vol 2578, 2020.
2. Mihael Ankerst; Markus M. Breunig; Hans-Peter Kriegel; Jörg Sander (1999). OPTICS: Ordering Points To Identify the Clustering Structure. ACM SIGMOD international conference on Management of data. ACM Press. pp. 49–60.

## Overview

### Trajectory segmentation

The algorithm processes geotracking points in 4 steps:

- filter GPS points based on accuracy (default is 100m)
- perform self-Adapting Trajectory Segmentation (sATS) to find split points (significant stop points),
- run OPTICS over the set of stop points for clustering, taking into account the time aspect as well,
- do postprocessing to reduce the number of clusters (merging) and guarantee stops and tracks alternately.

The required input parameters are timestamp, longitude, latitude and accuracy. The list of geolocation points needs to be time-ordered.

## Installation

### Connecting to rabbitmq bus

The python message bus consumer requires a ```params.py``` configuration file with the following content:

```bash
rabbitmq_host="<host e.g. localhost>"
rabbitmq_port=<rabbitmq port number e.g. 5672>
rabbitmq_user="<username>"
rabbitmq_password="<password>"
rabbitmq_vhost="<vhost e.g. />"
rabbitmq_exchange="<exchange e.g. exchange_geoservice>"
rabbitmq_queue_process="<process queue e.g. geopoints.process>"
rabbitmq_queue_processed="<processed queue e.g. geopoints.processed>"
process_timeout_seconds=60*5
```

In case of using docker, this file needs to be mounted in the same directory as ```message_bus_consumer.py``.

### Building the docker container

An example Dockerfile and docker-compose.yml can be found in the ```docker/``` directory.

Run this command to build the docker container:

```bash
sudo docker build -t geoservice -f docker/Dockerfile .
```

### Testing the algorithm

```bash
sudo docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix -v /<your-path>/geoservice-ssi:/opt/geoservice -e DISPLAY=$DISPLAY --rm geoservice bash
cd R
R
source('test.R')
mymap
```

## Usage

### Rabbitmq message formats

#### Incoming messages

```bash
{
    "id": <string>,
    "settings": {
        "accuracy_meter": <integer>,
        "temporal_threshold_seconds": <integer>,
        "spatial_threshold_meter": <integer>,
        "start_new_cluster_meter": <integer>,
        "start_new_cluster_seconds": <integer>
    },
    "geopoints": [
        {
            "id": <string>,
            "t": <unix timestamp>,
            "lon": <latitude -- double>,
            "lat": <longitude -- double>,
            "acc": <integer>,
            "metadata": <string>,
        },
        ...
    ],
    "geolocations": [
        {
            "id": <string>,
            "lon": <latitude -- double>,
            "lat": <longitude -- double>,
            "radius": <integer>,
            "metadata": <string>,
        },
        ...
    ],
    "metadata": <any json type, to support system/platform integration>
}
```

If a GPS point falls within a geolocation then it is always regarded as a split point in sATS.

#### Outgoing messages

```bash
{
    "settings": {
        "accuracy_meter": <integer>,
        "temporal_threshold_seconds": <integer>,
        "spatial_threshold_meter": <integer>,
        "start_new_cluster_meter": <integer>,
        "start_new_cluster_seconds": <integer>
    },
    "id": <string>,
    "clusters": [
        {
            "cluster_id": <integer>,
            "index_start": <integer>,
            "index_stop": <integer>,
            "lon": <double>,
            "lat": <double>,
            "time_start": <integer>,
            "time_end": <integer>,
            "duration": <integer>,
            "radius": <double>,
            "event": <string: track,stop>,
            "geopoints": [
                {
                "id": <string>,
                "t": <unix timestamp>,
                "lon": <latitude -- double>,
                "lat": <longitude -- double>,
                "acc": <integer>,
                "metadata": <string>,
                },
                ...
            ]

        },
        ...
    ],
    "metadata": <any json type, to support system/platform integration>
}
```
