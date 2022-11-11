#!/bin/bash
set -e

# https://www.rocker-project.org/use/singularity/
# https://www.rc.virginia.edu/userinfo/howtos/rivanna/launch-rserver/

IMG='rstudio.sif'
DOCKER='docker://szctt/rbio:v1.3'

if [ ! -e ${IMG} ]; then
	singularity pull ${PWD}/${IMG} ${DOCKER}
	echo "finished pulling"
fi

cd ..

TMPDIR=rstudio-tmp 
mkdir -p $TMPDIR/tmp/rstudio-server
uuidgen > $TMPDIR/tmp/rstudio-server/secure-cookie-key
chmod 600 $TMPDIR/tmp/rstudio-server/secure-cookie-key
mkdir -p $TMPDIR/var/{lib,run}
touch ${TMPDIR}/var/run/test
mkdir -p ${TMPDIR}/home

printf 'provider=sqlite\ndirectory=/var/lib/rstudio-server\n' > "${TMPDIR}/database.conf"


singularity exec \
    -B $TMPDIR/var/run:/var/run/rstudio-server \
    -B $TMPDIR/var/lib:/var/lib/rstudio-server \
    -B $TMPDIR/database.conf:/etc/rstudio/database.conf \
    -B $TMPDIR/tmp:/tmp \
    ${PWD}/${IMG} \
    rserver --server-user=$(whoami) --www-port=8888
