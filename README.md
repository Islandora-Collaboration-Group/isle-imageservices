# ISLE Image Services

## Part of the ISLE Islandora 7.x Docker Images
Running Cantaloupe as a IIIF compliant image server for ISLE.

Based on:
  - [ISLE-tomcat](https://github.com/Islandora-Collaboration-Group/isle-tomcat)
  - [Cantaloupe 4.0.1](https://medusa-project.github.io/cantaloupe/) an IIIF comliant open-source dynamic image server

Contains and Includes:
  - [ImageMagick 7](https://www.imagemagick.org/)
    - Features: Cipher DPC HDRI OpenMP
    - Delegates (built-in): bzlib djvu mpeg fontconfig freetype jbig jng jpeg lcms lqr lzma openexr openjp2 png ps raw rsvg tiff webp wmf x zlib
  - [OpenJPEG](http://www.openjpeg.org/)
  - [FFmepg](https://www.ffmpeg.org/)

## Cantaloupe Default Admin User

Username: admin  
Password: isle_admin