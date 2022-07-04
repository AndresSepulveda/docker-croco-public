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

RUN chmod 666 /etc/sudoers && \
   echo "croco ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
   chmod 440 /etc/sudoers &&\
   chown -R croco:croco /home/croco
RUN mkdir -p /home/croco

USER croco
WORKDIR /home/croco/
RUN wget https://data-croco.ifremer.fr/CODE_ARCHIVE/croco-v1.2.1.tar.gz
RUN gzip -d croco-v1.2.1.tar.gz
RUN tar -xvf croco-v1.2.1.tar
RUN rm croco-v1.2.1.tar

WORKDIR /home/croco/croco-v1.2.1
RUN wget https://data-croco.ifremer.fr/CODE_ARCHIVE/croco_tools-v1.2.tar.gz
RUN gzip -d croco_tools-v1.2.tar.gz
RUN tar -xvf croco_tools-v1.2.tar
RUN rm croco_tools-v1.2.tar
