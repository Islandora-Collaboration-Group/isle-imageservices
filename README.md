# ISLE Image Services

## Part of the ISLE Islandora 7.x Docker Images
Running Cantaloupe as a IIIF compliant image server for ISLE.

Based on:
* [ISLE-tomcat](https://github.com/Islandora-Collaboration-Group/isle-tomcat)
* [Cantaloupe 4.1.6](https://medusa-project.github.io/cantaloupe/) an IIIF compliant open-source dynamic image server

Contains and Includes:
* [ImageMagick 7](https://www.imagemagick.org/)
  * Features: Cipher DPC HDRI OpenMP
  * Delegates (built-in): bzlib djvu mpeg fontconfig freetype jbig jng jpeg lcms lqr lzma openexr openjp2 png ps raw rsvg tiff webp wmf x zlib
* [OpenJPEG](http://www.openjpeg.org/)
* [FFmepg](https://www.ffmpeg.org/)

## Usage

* For general usage of this image and [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE), please refer to [ISLE documentation](https://islandora-collaboration-group.github.io/ISLE/)

---

### (Manual - Docker image build process for Kakadu)
* **Please note:** As of ISLE release 1.5.1, the demo Kakadu binaries, libraries and paths are no longer used in the compiling of the `isle-imageservices` Docker image. If you require them, you will need to do the following:

#### Dockerfile

* Within the `Dockerfile`: comment out the following lines, e.g. add a `#` in front of those lines and save the file.

```bash
JAVA_OPTS='-Djava.awt.headless=true -server -Xmx${JAVA_MAX_MEM} -Xms${JAVA_MIN_MEM} -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=70 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true' \
CATALINA_OPTS="-Dcantaloupe.config=/usr/local/cantaloupe/cantaloupe.properties \
-Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true \
-Djava.library.path=/usr/local/lib:/usr/local/tomcat/lib \
-DLD_LIBRARY_PATH=/usr/local/lib:/usr/local/tomcat/lib"
```

* Within the `Dockerfile`: uncomment the following lines and save the file.

```bash
#KAKADU_HOME=/usr/local/cantaloupe/deps/Linux-x86-64/bin \
#KAKADU_LIBRARY_PATH=/usr/local/cantaloupe/deps/Linux-x86-64/lib \
#JAVA_OPTS='-Djava.awt.headless=true -server -Xmx${JAVA_MAX_MEM} -Xms${JAVA_MIN_MEM} -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=70 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true' \
#CATALINA_OPTS="-Dcantaloupe.config=/usr/local/cantaloupe/cantaloupe.properties \
#-Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true \
#-Dkakadu.home=/usr/local/cantaloupe/deps/Linux-x86-64/bin \
#-Djava.library.path=/usr/local/cantaloupe/deps/Linux-x86-64/lib:/usr/local/tomcat/lib \
#-DLD_LIBRARY_PATH=/usr/local/cantaloupe/deps/Linux-x86-64/lib:/usr/local/tomcat/lib"
```

* Within the Dockerfile, uncomment the following lines and save the file.

```bash
# chmod 755 /usr/local/cantaloupe/deps/Linux-x86-64/bin/kdu_expand && \
# ln -s /usr/local/cantaloupe/deps/Linux-x86-64/bin/kdu_expand /usr/local/bin/kdu_expand && \
# ln -s /usr/local/cantaloupe/deps/Linux-x86-64/lib/libkdu_a7AR.so /usr/local/lib/libkdu_a7AR.so && \
# ln -s /usr/local/cantaloupe/deps/Linux-x86-64/lib/libkdu_jni.so /usr/local/lib/libkdu_jni.so && \
# ln -s /usr/local/cantaloupe/deps/Linux-x86-64/lib/libkdu_v7AR.so /usr/local/lib/libkdu_v7AR.so && \
```    

#### Changes to files within the rootfs directory

* Within the following two files, edit the following: 
  * `rootfs/usr/local/cantaloupe/cantaloupe.properties`
  * `rootfs/etc/confd/templates/imageserv/cantaloupe.properties.tpl`
    * Find this line `KakaduDemoProcessor.path_to_binaries = `
    * add the path to the KaduDemoProcessor or paid Kakadu Processor binaries.
    * save the file.

* Within `rootfs/fix-attrs.d/11-cantaloupe`, edi the following:
  * Uncomment the following `# /usr/local/cantaloupe/deps/Linux-x86-64/bin/kdu_expand true tomcat 0755`
  * save the file

* Once finished, check in your changes into a new git repository.

#### Manual build process

* Open a terminal and either clone down this new git repository to your local laptop or `cd` to the project on your laptop

* Build the image
  * `docker build -t yourdockerimagerepohere/isle-imageservices:1.5.1 .`

* Push the image to your docker image repo
  * `docker push yourdockerimagerepohere/isle-imageservices:1.5.1`

* Use the newly built image in ISLE
  * Within all of the `docker-compose.*.yml` files in your ISLE project, change `image: islandoracollabgroup/isle-imageservices:1.5.1` to `image: yourdockerimagerepohere/isle-imageservices:1.5.1`
  * Save all of the files after editing and check the changes into git.