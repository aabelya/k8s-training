#!/bin/bash

RES_PORT=53709
SONGS_PORT=53736

worker_id=$1
if [ -z $worker_id ]; then
  echo "worker_id needed"
  exit 1
fi
duration=$2
if [ -z $duration ]; then
  echo "duration needed"
  exit 1
fi

function log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S.%N') [worker-$worker_id] - $1"
}

log "Started worker-$worker_id"
health=$(curl -s -f http://localhost:$RES_PORT/actuator/health)
if [ ! $? -eq 0 ]; then
  log "Resources-service health check failed. Exiting"
  exit 1;
fi
health=$(curl -s -f http://localhost:$SONGS_PORT/actuator/health)
if [ ! $? -eq 0 ]; then
  log "Songs-service health check failed. Exiting"
  exit 1;
fi

t1=$(date '+%s')
while [ $(($(date '+%s') - t1)) -le $duration ]; do
    res_resp=$(curl -s -f -H "X-WorkerId: $worker_id" -F "file=@016-HURRA_PP1_podr_stud.mp3" http://localhost:${RES_PORT}/resources/file)
    if [ ! $? -eq 0 ]; then
      log "resources/file request failed"
      continue
    fi
    id=$(echo $res_resp|sed -E 's/\{"id":([0-9]+)\}/\1/g')
    if [ -z $id ]; then
      log "couldn't extract id from response \'$res_resp\'"
      continue
    fi
    song_res=$(curl -s -f -H "X-WorkerId: $worker_id" http://localhost:${SONGS_PORT}/songs/$id)
    if [ ! $? -eq 0 ]; then
      log "songs/$id request failed"
      continue
    fi
    log "resources/file: $res_resp; songs/$id: $song_res"
done