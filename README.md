# Docker image to run the Coastal and Regional Ocean COmmunity model - CROCO

NOTE: this project is at an early stage of development.  

## Pre-requisites

- Install docker in your system. Some guidelines [here](https://docs.docker.com/engine/installation/).
- Create a Dockerhub account [here](https://hub.docker.com/).
- Pull the CROCO docker image:
```
docker pull andressepulveda/croco_oceanv1.2.1b
```

## Getting started 


```
docker run -it andressepulveda/croco_oceanv1.2.1b bash
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

In the /home/croco/croco-v1.2.1 directory edit the create_config.bash 
```
nano create_config.bash
```
change this line to the name of your configuration, in this case "Chile"
```
MY_CONFIG_NAME=Chile
```
run the script
```
./create_config.bash
```
Press "Y" and change to the newly created "Chile" directory (the name of your configuration)
```
cd Chile
```
There you should edit crocotools_param.m, cppdefs.h, param.h, croco.in
to suit you needs.

At the moment you can't use CROCOTOOLS to create the input files in this docker container.

## Bugs
Please report any bugs [here](https://github.com/AndresSepulveda/docker-croco-public/issues).
