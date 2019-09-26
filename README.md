# ISLE Image Services

## Part of the ISLE Islandora 7.x Docker Images
Running Cantaloupe as a IIIF compliant image server for ISLE.

Based on:
  - [ISLE-tomcat](https://github.com/Islandora-Collaboration-Group/isle-tomcat)
  - [Cantaloupe 4.0.3](https://medusa-project.github.io/cantaloupe/) an IIIF compliant open-source dynamic image server

Contains and Includes:
  - [ImageMagick 7](https://www.imagemagick.org/)
    - Features: Cipher DPC HDRI OpenMP
    - Delegates (built-in): bzlib djvu mpeg fontconfig freetype jbig jng jpeg lcms lqr lzma openexr openjp2 png ps raw rsvg tiff webp wmf x zlib
  - [OpenJPEG](http://www.openjpeg.org/)
  - [FFmepg](https://www.ffmpeg.org/)

## Usage

* For general usage of this image and [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE), please refer to [ISLE documentation](https://islandora-collaboration-group.github.io/ISLE/)