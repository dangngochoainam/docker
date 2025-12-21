#!/bin/bash
# Text to the right of a '#' is treated as a comment - below is the shell command
echo 'Creating network...'
docker network create docker_stack
echo 'Network created successfully!'