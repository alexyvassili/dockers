# AUTOPUBLISHER BASE DOCKERFILE BASED ON DEBIAN BASE IMAGE
# TO RUN SHELL IN IMAGE ENTER `docker run --entrypoint /bin/bash -it <image>`

ARG DEBIAN_IMAGEMAGICK

FROM $DEBIAN_IMAGEMAGICK as release

ENV VERSION=1

# INSTALL DEPENDENCIES
RUN apt-install firefox-esr firefox-esr-l10n-ru libmagic1 libpython3.11-stdlib \
                libreoffice-writer python3-pip python3-xvfbwrapper python3.11-distutils \
                python3.11-minimal python3.11-venv xvfb

# INSTALL GECKO DRIVER
ENV GECKODRIVER="https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz"
RUN wget $GECKODRIVER -O /tmp/geckodriver.tar.gz && \
    mkdir -p /tmp/geckodriver && \
    tar xvzf /tmp/geckodriver.tar.gz -C /tmp/geckodriver && \
    cp /tmp/geckodriver/geckodriver /usr/bin && \
    rm /tmp/geckodriver/* && \
    rmdir /tmp/geckodriver && \
    rm /tmp/geckodriver.tar.gz
