#vivado-docker

## Building the images

Xilinx has ITAR restrictions and licensing restrictions in place for obtaining Vivado. As such, you will need to download the *full* installer from your own Xilinx account and place it in the Jessie-Vivado-<Release> docker image directory as a local file the docker build process can find. Additionally, get your wildcard Xilinx.lic file from their webpage and place this in the same directory. This way Xilinx licensing is still respected.

There is a helper script used to build the images. Edit the top of build_images script for your image/tag names, etc. You must build this on your local machine in order for the script to properly build the X sharing files in the container. Note: This is not a secure sandbox container! For running the FPGA tools I don't think that is an issue.

Note: During the build, the xilinx installer pauses for some time after printing Installation completed. Be patient it will finish.

## Running the docker container

Running using your local X server requires the right permissions on the host. On my machine this is done by xhost. To launch Vivado run:

```sh
$ xhost +
$ ./run_vivado.sh [your image tag here]
```
Add the --rm tag to the command line if you want to automatically clean up the container on exit. You should see vivado gui pop up. Happy vivado-ing!
