FROM ubuntu:16.04

RUN apt-get update && apt-get -y install sudo

RUN apt-get update && apt-get -y install sudo wget build-essential gfortran &&\
    apt-get -y install subversion libnetcdf-dev libhdf5-serial-dev  &&\
    apt-get -y install libkernlib1-gfortran netcdf-bin hdf5-tools mpich
    
RUN useradd -u 1001 roms &&\
    mkdir -p /home/roms/packages &&\
    mkdir -p /home/roms/include &&\
    mkdir -p /home/roms/applications/upwelling/out

COPY build /home/roms/build
# COPY packages /home/roms/packages

COPY ocean_upwelling.in /home/roms/applications/upwelling
COPY run_mpich.sh /home/roms/applications/upwelling

RUN chmod 666 /etc/sudoers &&\
    echo "roms ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
    chmod 440 /etc/sudoers &&\
    chown -R roms:roms /home/roms 

USER roms
ARG roms_username
ARG roms_password
ARG netcdf_version
RUN cd /home/roms/packages && wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${netcdf_version}.tar.gz
RUN svn checkout --username $roms_username --password $roms_password https://www.myroms.org/svn/src/trunk /home/roms/roms_src
RUN cp /home/roms/roms_src/ROMS/Include/upwelling.h /home/roms/include/upwelling.h
RUN cd /home/roms/build && make all
RUN cd /home/roms/applications/upwelling && cp /home/roms/bin/UPWELLING . && ./run_mpich.sh
RUN rm -rf /home/roms/applications/upwelling/out/*.nc