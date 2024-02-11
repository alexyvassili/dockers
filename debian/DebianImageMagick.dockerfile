# DEBIAN BUILD DOCKERFILE BASED ON DEBIAN BASE IMAGE
# TO RUN SHELL IN IMAGE ENTER `docker run --entrypoint /bin/bash -it <image>`

ARG DEBIAN
ARG DEBIAN_BUILD

FROM $DEBIAN_BUILD as builder

ENV VERSION=1

WORKDIR /tmp

# INSTALL IMAGEMAGICK BUILD LIBRARIES
RUN aptitude update &&  \
    aptitude install -y bzip2 cairosvg gir1.2-pangocairo-1.0-dev gsfonts-other libbzip3-dev  \
             libdjvulibre-dev libdjvulibre21 libfontconfig-dev libfreetype-dev libfreetype6-dev  \
             libgif-dev libgs-dev libgvc6 libheif-dev libjpeg-dev libjpeg62 libjxl-dev libjxl-devtools  \
             liblcms2-dev liblqr-dev liblzma-dev libopenexr-dev libopenjp2-7-dev libpango1.0-dev  \
             libperl-dev libpng-dev libraqm-dev libraw-dev librsvg2-dev libtiff-dev libtiff5-dev  \
             libwebp-dev libwebpdemux2 libwebpmux3 libwmf-dev libxml2-dev libzip-dev libzstd-dev  \
             libzstd1 pango1.0-tools wmf && \
    aptitude clean

# DOWNLOAD IMAGEMAGICK-7.1.1-27
RUN wget https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.1.1-27.tar.gz -O ImageMagick-7.1.1-27.tar.gz
RUN tar -xvzf ImageMagick-7.1.1-27.tar.gz

# COMPILE IMAGEMAGICK-7.1.1-27
WORKDIR ImageMagick-7.1.1-27
RUN mkdir -p /app/ImageMagick-7.1.1-27/usr/local
RUN ./configure --disable-shared --disable-installed --disable-openmp  \
                --prefix=/app/ImageMagick-7.1.1-27/usr/local  \
                --without-x --with-gslib --with-modules --with-bzlib -with-djvu --with-dps --with-fontconfig  \
                --with-freetype --with-gslib --with-gvc --with-heic --with-jbig --with-jpeg --with-jxl  \
                --with-dmr --with-lcms --with-lqr --with-lzma --with-magick-plus-plus --with-openexr  \
                --with-openjp2 --with-pango --with-png --with-raqm --with-raw --with-rsvg --with-tiff  \
                --with-webp --with-wmf --with-xml --with-zip --with-zlib --with-zstd
RUN make
RUN make install

WORKDIR /app
RUN tar cvzf ImageMagick-7.1.1-27.local.tar.gz ImageMagick-7.1.1-27


FROM $DEBIAN as release

WORKDIR /tmp

RUN aptitude update &&  \
    aptitude install -y libdjvulibre21 libgs10 libheif1 libjxl0.7 liblqr-1-0 libopenexr-3-1-30 \
             libpangocairo-1.0-0 libraqm0 libraw-bin libraw23 librsvg2-2 librsvg2-bin libwebpdemux2 \
             libwebpmux3 libwmflite-0.2-7 libzip4 && \
    aptitude clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=builder /app/ImageMagick-7.1.1-27.local.tar.gz ImageMagick-7.1.1-27.local.tar.gz
RUN tar -xvzf ImageMagick-7.1.1-27.local.tar.gz
RUN cp -R /tmp/ImageMagick-7.1.1-27/usr/local/* /usr/local*
