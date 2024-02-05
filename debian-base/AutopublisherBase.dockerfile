# AUTOPUBLISHER BASE DOCKERFILE BASED ON DEBIAN BASE IMAGE
# TO RUN SHELL IN IMAGE ENTER `docker run --entrypoint /bin/bash -it <image>`

ARG DEBIAN

FROM $DEBIAN as release

ENV VERSION=1

# INSTALL DEPENDENCIES
RUN apt-install imagemagick libreoffice-writer

# INSTALL GECKO DRIVER
ENV GECKODRIVER="https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz"
RUN wget $GECKODRIVER -O /tmp/geckodriver.tar.gz && \
    mkdir -p /tmp/geckodriver && \
    tar xvzf /tmp/geckodriver.tar.gz -C /tmp/geckodriver && \
    cp /tmp/geckodriver/geckodriver /usr/bin && \
    rm /tmp/geckodriver/* && \
    rmdir /tmp/geckodriver && \
    rm /tmp/geckodriver.tar.gz

# INSTALL PYTHON
RUN apt-install python3.11-minimal libpython3.11-stdlib python3.11-distutils python3.11-venv python3-pip
