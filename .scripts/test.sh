#!/bin/bash

threshold=54

usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

if [ $usage -gt $threshold ]; then
    echo "Disk space is almost full!"
fi
