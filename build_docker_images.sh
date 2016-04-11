#!/bin/sh
# These Dockerfiles require docker v1.9 or greater

# The image names you want to use
MAINTAINER="Devin Hughes <devin@jd2.com>"
BASE_IMAGE_NAME="dkhughes/jessie-vivado-base:latest"
XV_IMAGE_NAME="dkhughes/jessie-vivado-2015.4:latest"

DIR="$PWD"
USR=`who mom likes | awk '{print $1}'`

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
docker build --build-arg b_uid=`id -u` \
    --build-arg b_gid=`id -g` \
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

#XV_IMG_SNAME=`echo $XV_IMAGE_NAME | sed "s|[:].*||"`

# Now it's time to run the license manager
#docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --name vivadoguest $XV_IMG_SNAME

echo Creating the run script
cd "$DIR"
# Create the run script
cat << EOF > run_vivado.sh
#!/bin/sh

if [ -z "\$1" ]; then
	echo "Usage: run_vivado.sh [docker image] [--rm]"
	exit 1
fi

docker run -ti -e DISPLAY=\$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \$2 \$1 /opt/Xilinx/Vivado/2015.4/bin/vivado

EOF

#Fixup file ownership
chown $USR:$USR run_vivado.sh
chmod +x run_vivado.sh

echo Done.
