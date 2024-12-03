# geoservice-ssi

Microservice which performs trajectory segmentation (sATS + OPTICS) and transport mode prediction.

## Overview

### Trajectory segmentation

3-step algorithm:

- performs self-Adaptive Trajectory Segmentation (sATS) to find split points,
- runs OPTICS over the set of split points for clustering to significant stops,
- some postprocessing such as filling gaps between stops with tracks.

### Transport mode detection

TODO

## Installation

### Connecting to rabbitmq bus

The python message bus consumer requires a ```params.py``` configuration file with the following content:

```bash
rabbitmq_host="rabbitmq host"
rabbitmq_port=5672
rabbitmq_user="geo"
rabbitmq_password="geo"
rabbitmq_vhost="/"
rabbitmq_exchange="exchange_geoservice"
rabbitmq_queue_process="geopoints.process"
rabbitmq_queue_processed="geopoints.processed"
process_timeout_seconds=60*5
```

In case of using docker, this file needs to be mounted in the same directory as ```message_bus_consumer.py``.

### Building the docker container

An example Dockerfile and docker-compose.yml can be found in the ```docker/``` directory.

Run this command to build the docker container:

```bash
sudo docker build -t geoservice -f docker/Dockerfile .
```

### Testing the algorithm (without docker)

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

TODO

#### Outgoing messages

TODO
