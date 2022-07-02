# Docker image to run the Coastal and Regional Ocean COmmunity model - CROCO

NOTE: this project is in very early stages of development.  

## Pre-requisites

- Install docker in your system. Some guidelines [here](https://docs.docker.com/engine/installation/).
- Create a Dockerhub account [here](https://hub.docker.com/).
- Pull the CROCO docker image:
```
docker pull andressepulveda/croco_oceanv1.2.1a
```

## Getting started 


```
docker run -it andressepulveda/croco_oceanv1.2.1a bash
```

- Done, you're inside the docker container now. Let's run the Benguela test case. 
```
cd /home/croco/croco-v1.2.1/Benguela/CROCO_FILES
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_grd.nc
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_frc.nc
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_clm.nc
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_ini.nc
cd ..
./jobcomp
./croco croco.in
```

## Build your own CROCO configuration

- step 1
- step 2

Please report any bugs [here](https://github.com/AndresSepulveda/docker-croco-public/issues).
