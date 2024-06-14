FROM ubuntu:16.04
# FROM debian:10-slim

LABEL maintainer="andres.sepulveda@gmail.com"

#
# Based on Dockerfiles from
# RSoutelino (http://github.com/metocean/docker-roms-public)
# Solene Le Gac (http://forum.croco-ocean.org/question/708/croco-in-a-docker-container/#709)
#

RUN apt-get update \
&&  apt-get upgrade -y \
&&  apt-get install gfortran -y \
&&  apt-get install make -y \
&&  apt-get install libopenmpi-dev -y \
&&  apt-get install libhdf5-openmpi-dev -y \
&&  apt-get install libnetcdf-dev -y \
&&  apt-get install libnetcdff-dev -y \
&&  apt-get install bc -y \
&&  apt-get install git -y \
&&  apt-get install curl -y \
&&  apt-get install netcdf-bin -y \
&&  apt-get install nco -y \
&&  apt-get install unzip -y \
&&  apt-get install wget -y \
&&  apt-get install sudo -y \
&&  apt-get install vim -y \
&&  apt-get install octave -y \
&&  apt-get install octave-octcdf -y \
&&  apt-get clean -y

RUN useradd -m croco && echo "croco:croco" | chpasswd && adduser croco sudo

RUN mkdir -p /home/croco
RUN chown -R croco:croco /home/croco

USER croco
WORKDIR /home/croco/
RUN wget https://gitlab.inria.fr/croco-ocean/croco/-/archive/v2.0.0/croco-v2.0.0.zip
RUN unzip croco-v2.0.0.zip
RUN rm croco-v2.0.0.zip

RUN wget https://gitlab.inria.fr/croco-ocean/croco_tools/-/archive/v2.0.0/croco_tools-v2.0.0.zip
RUN unzip croco_tools-v2.0.0.zip
RUN rm croco_tools-v2.0.0.zip

RUN wget https://gitlab.inria.fr/croco-ocean/croco_pytools/-/archive/v1.0.1/croco_pytools-v1.0.1.zip
RUN unzip croco_pytools-v1.0.1.zip
RUN rm croco_pytools-v1.0.1.zip

#
# All external datasets (8.9GB)
#
WORKDIR /home/croco/croco_tools
RUN wget https://data-croco.ifremer.fr/DATASETS/DATASETS_CROCOTOOLS.tar.gz
RUN gzip -d DATASETS_CROCOTOOLS.tar.gz
RUN tar -xvf DATASETS_CROCOTOOLS.tar
RUN rm DATASETS_CROCOTOOLS.tar
RUN mv DATASETS_CROCOTOOLS/* .
RUN rm -rf DATASETS_CROCOTOOLS

WORKDIR /home/croco/
