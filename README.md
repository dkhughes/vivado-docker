#vivado-docker

## Building the images

Xilinx has ITAR restrictions and licensing restrictions in place for obtaining
Vivado. As such, you will need to download the *full* installer from your own
Xilinx account and place it in the Jessie-Vivado-[Release] docker image
directory as a local file the docker build process can find. Additionally, get
your wildcard Xilinx.lic file from their webpage and place this in the same
directory. This way Xilinx licensing is still respected.

There is a helper script used to build the images. Edit the top of build_images
script for your image/tag names, etc. You must build this on your local machine
in order for the script to properly build the X sharing files in the container.
The default batch mode config does install SDK, but you can quickly disable it
if necessary. Note: This is not a secure sandbox container! For running the FPGA
tools I don't think that is an issue.

Note: During the build, the Xilinx installer pauses for some time after printing
 Installation completed. Be patient it will finish.

## Running the docker image

Running using your local X server requires the right permissions on the host. On
my machine this is done by xhost. To launch Vivado run:

```sh
$ xhost +
$ ./run_vivado.sh
```
You should see the Vivado gui pop up. Launch the other versions using their
respective scripts. Happy Vivado-ing!
