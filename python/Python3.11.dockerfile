# PYTHON 3.11 DOCKERFILE BASED ON DEBIAN TESTING DISTRIBUTION
# TO RUN SHELL IN IMAGE ENTER `docker run --entrypoint /bin/bash -it <image>`

ARG DEBIAN

FROM $DEBIAN as release

# INSTALL PYTHON
RUN apt-install python3.11-minimal libpython3.11-stdlib python3.11-distutils python3.11-venv python3-pip
