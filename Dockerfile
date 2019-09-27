FROM islandoracollabgroup/isle-tomcat:1.3.0

# Set up environmental variables for tomcat & dependencies
ENV JAVA_MAX_MEM=${JAVA_MAX_MEM:-2G} \
    JAVA_MIN_MEM=${JAVA_MIN_MEM:-0} \
    ## Per Gavin, we are no longer using -XX:+UseConcMarkSweepGC, instead G1GC.
    JAVA_OPTS='-Djava.awt.headless=true -server -Xmx${JAVA_MAX_MEM} -Xms${JAVA_MIN_MEM} -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=70' \
    KAKADU_HOME=/usr/local/cantaloupe/deps/Linux-x86-64/bin \
    KAKADU_LIBRARY_PATH=/usr/local/cantaloupe/deps/Linux-x86-64/lib \
    CATALINA_OPTS="-Dcantaloupe.config=/usr/local/cantaloupe/cantaloupe.properties \
    -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true \
    -Dkakadu.home=/usr/local/cantaloupe/deps/Linux-x86-64/bin \
    -Djava.library.path=/usr/local/cantaloupe/deps/Linux-x86-64/lib:/usr/local/tomcat/lib \
    -DLD_LIBRARY_PATH=/usr/local/cantaloupe/deps/Linux-x86-64/lib:/usr/local/tomcat/lib" \
    CANTALOUPE_VERSION=${CANTALOUPE_VERSION:-4.0.3}

## Dependencies 
RUN GEN_DEP_PACKS="ffmpeg \
    ffmpeg2theora \
    libavcodec-extra \
    ghostscript \
    xpdf \
    poppler-utils" && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --no-install-recommends $GEN_DEP_PACKS && \
    ## Cleanup phase.
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## ImageMagick and OpenJPG
RUN BUILD_DEPS="build-essential \
    cmake \
    pkg-config \
    libtool" && \
    IMAGEMAGICK_LIBS="libbz2-dev \
    libdjvulibre-dev \
    libexif-dev \
    libgif-dev \
    libjpeg8 \
    libjpeg-dev \
    liblqr-dev \
    libopenexr-dev \
    libopenjp2-7-dev \
    libpng-dev \
    libraw-dev \
    librsvg2-dev \
    libtiff-dev \
    libwmf-dev \
    libwebp-dev \
    libwmf-dev \
    libltdl-dev  \
    zlib1g-dev" && \
    ## I believe these are unused and actually install by libavcodec-extra.
    IMAGEMAGICK_LIBS_EXTENDED="libfontconfig \
    libfreetype6-dev" && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --no-install-recommends -o APT::Get::Install-Automatic=true $BUILD_DEPS && \
    apt-mark auto $BUILD_DEPS && \
    apt-get install -y --no-install-recommends $IMAGEMAGICK_LIBS && \
    cd /tmp && \
    git clone https://github.com/uclouvain/openjpeg && \
    cd openjpeg && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make && \
    make install && \
    ldconfig && \
    cd /tmp && \
    curl -O https://www.imagemagick.org/download/ImageMagick.tar.gz && \
    tar xf ImageMagick.tar.gz && \
    cd ImageMagick-* && \
    ./configure --enable-hdri --with-quantum-depth=16 --without-magick-plus-plus --without-perl --with-rsvg && \
    make && \
    make install && \
    ldconfig && \
    ## Cleanup phase.
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


## Cantaloupe
RUN cd /tmp && \
    curl -O -L https://github.com/medusa-project/cantaloupe/releases/download/v$CANTALOUPE_VERSION/cantaloupe-$CANTALOUPE_VERSION.zip && \
    unzip cantaloupe-$CANTALOUPE_VERSION.zip && \
    rm cantaloupe-$CANTALOUPE_VERSION/*.sample && \
    mkdir -p /usr/local/cantaloupe /usr/local/cantaloupe/temp /usr/local/cantaloupe/cache /usr/local/tomcat/logs/cantaloupe && \
    cp -r cantaloupe-$CANTALOUPE_VERSION/* /usr/local/cantaloupe && \
    chmod 755 /usr/local/cantaloupe/deps/Linux-x86-64/bin/kdu_expand && \
    ln -s /usr/local/cantaloupe/deps/Linux-x86-64/bin/kdu_expand /usr/local/bin/kdu_expand && \
    ln -s /usr/local/cantaloupe/deps/Linux-x86-64/lib/libkdu_a7AR.so /usr/local/lib/libkdu_a7AR.so && \
    ln -s /usr/local/cantaloupe/deps/Linux-x86-64/lib/libkdu_jni.so /usr/local/lib/libkdu_jni.so && \
    ln -s /usr/local/cantaloupe/deps/Linux-x86-64/lib/libkdu_v7AR.so /usr/local/lib/libkdu_v7AR.so && \
    mv /usr/local/cantaloupe/cantaloupe-$CANTALOUPE_VERSION.war /usr/local/tomcat/webapps/cantaloupe.war && \
    unzip /usr/local/tomcat/webapps/cantaloupe.war -d /usr/local/tomcat/webapps/cantaloupe && \
    chown tomcat /usr/local/cantaloupe -R && \
    ## Cleanup Phase.
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Labels
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="ISLE Image Services" \
      org.label-schema.description="Serving all your images needs." \
      org.label-schema.url="https://islandora-collaboration-group.github.io" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Islandora-Collaboration-Group/isle-imageservices" \
      org.label-schema.vendor="Islandora Collaboration Group (ICG) - islandora-consortium-group@googlegroups.com" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      traefik.port="8080"

COPY rootfs /

EXPOSE 8080

ENTRYPOINT ["/init"]
