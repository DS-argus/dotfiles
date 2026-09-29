#!/bin/bash
export LC_TIME=C
TIME_LABEL="$(date '+%H:%M')"
DATE_LABEL="$(date '+%a, %b %d')"
sketchybar --set clock label="$TIME_LABEL" \
           --set calendar label="$DATE_LABEL" \
           --set portrait.clock label="$TIME_LABEL" \
           --set portrait.calendar label="$DATE_LABEL"
