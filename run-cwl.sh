#!/bin/bash

source activate cwl-pipeline
set -ex

WORKFLOW_NAME=$1
basedir=$( cd "$(dirname "$0")" ; pwd -P )
python ${basedir}/create_workflow_inputs.py inputs.json
WORKFLOW_INPUTS=$(ls $PWD/workflow-inputs.yml)
export MAAP_CONF=/app/maap-py/
# pushd is important for the ymls to find the python file doing a $PWD
pushd ${basedir}/workflow
cwltool --parallel --disable-color --timestamps ${WORKFLOW_NAME}.yml ${WORKFLOW_INPUTS}
popd

set -x
mkdir -p output
mv *.log output/
