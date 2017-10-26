FROM ubuntu:16.04

RUN apt-get update && apt-get -y install sudo

RUN apt-get update && apt-get -y install sudo wget build-essential gfortran &&\
    apt-get -y install subversion libnetcdf-dev libhdf5-serial-dev  &&\
    apt-get -y install libkernlib1-gfortran netcdf-bin hdf5-tools mpich
    
RUN useradd -u 1001 roms &&\
    mkdir -p /home/croco/packages &&\
    mkdir -p /home/croco/include &&\
    mkdir -p /home/croco/applications/upwelling/out

COPY build /home/croco/build
COPY packages /home/croco/packages

#COPY ocean_upwelling.in /home/croco/applications/upwelling
#COPY run_mpich.sh /home/roms/applications/upwelling

RUN chmod 666 /etc/sudoers &&\
    echo "croco ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
    chmod 440 /etc/sudoers &&\
    chown -R croco:croco /home/croco 

USER croco
#ARG croco_username
#ARG croco_password
ENV croco_app=UPWELLING
# ARG netcdf_version
# ARG hdf5_major
# ARG hdf5_version
# RUN cd /home/roms/packages && wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${hdf5_major}/hdf5-${hdf5_version}/src/hdf5-${hdf5_version}.tar.gz
# RUN cd /home/roms/packages && wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${netcdf_version}.tar.gz
# RUN svn checkout --username $roms_username --password $roms_password https://www.myroms.org/svn/src/trunk /home/roms/roms_src
RUN wget ftp://ftp.ifremer.fr/ifremer/cersat/users/sjullien/CROCO/croco_beta.tar.gz
# RUN cp /home/roms/roms_src/ROMS/Include/upwelling.h /home/roms/include/upwelling.h
# RUN cd /home/roms/build && make all
# RUN cd /home/roms/applications/upwelling && cp /home/roms/bin/${roms_app} . && ./run_mpich.sh
# RUN rm -rf /home/roms/applications/upwelling/out/*.nc
