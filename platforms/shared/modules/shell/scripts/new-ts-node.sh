#!/bin/sh

project_name=$1

cp -rf ~/code/configs/ts/node $project_name
perl -p -i -e "s/DEFAULT_PROJECT_NAME/${project_name}/g" `ack -f ${project_name}`
cd $project_name
npm update --save
