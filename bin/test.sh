#!/bin/bash

while read prefix; do
    echo "Found prefix: $prefix"
done < prefix.txt
