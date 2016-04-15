#!/bin/sh
# These Dockerfiles require docker v1.9 or greater
# I invoke docker with sudo to remind me that it's
# running as root. USR pulls back out the actual invokers
# user name.

DIR="$PWD"
USR=`who mom likes | awk '{print $1}'`

# --- Configure Here ---
MAINTAINER="Devin Hughes <devin@jd2.com>"
BASE_IMAGE_NAME="dkhughes/jessie-vivado-base:latest"
XV_IMAGE_NAME="dkhughes/jessie-vivado-2015.4:latest"
XV_SHARE_PATH=/home/"$USR"/docker-share/vivado

# Populate the docker files with the config
sed "s|@maintainer@|$MAINTAINER|" \
    "$DIR"/Jessie-Vivado-Base/Dockerfile.in > \
    "$DIR"/Jessie-Vivado-Base/Dockerfile
sed -e "s|@maintainer@|$MAINTAINER|" \
    -e "s|@jessie-base-image@|$BASE_IMAGE_NAME|" \
    "$DIR"/Jessie-Vivado-2015.4/Dockerfile.in >\
    "$DIR"/Jessie-Vivado-2015.4/Dockerfile

# Now build the base image
cd "$DIR"/Jessie-Vivado-Base
docker build --build-arg b_uid=`id -u $USR` \
    --build-arg b_gid=`id -g $USR` \
    -t "$BASE_IMAGE_NAME" .

if [ $? -ne 0 ]; then
    echo ERROR: Failed to build base image.
    exit 1
fi

echo Base image built. Building final image...
cd "$DIR"/Jessie-Vivado-2015.4
docker build -t "$XV_IMAGE_NAME" .

if [ $? -ne 0 ]; then
  echo ERROR: Failed to build final image.
  exit 1
fi

XV_IMG_SNAME=`echo $XV_IMAGE_NAME | sed "s|[:].*||"`

echo Creating the run script
cd "$DIR"
# Create the run script
cat << EOF > run_vivado.sh
#!/bin/sh
# Runs Vivado and cleans up when done.
docker run --rm -ti -e DISPLAY=\$DISPLAY \
--user developer \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v $XV_SHARE_PATH:/home/developer \
$XV_IMG_SNAME \
/opt/Xilinx/Vivado/2015.4/bin/vivado

EOF

#Fixup file ownership
chown $USR:$USR run_vivado.sh
chmod +x run_vivado.sh

echo Done.
