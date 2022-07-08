# Docker image to run the Coastal and Regional Ocean COmmunity model - CROCO

NOTE: this project is at an early stage of development.  

## Pre-requisites

- Install docker in your system. Some guidelines [here](https://docs.docker.com/engine/installation/).
- Create a Dockerhub account [here](https://hub.docker.com/).
- Pull the CROCO docker image:
```
docker pull andressepulveda/croco_oceanv1.2.1b
```
- Or if you use the Dockerfile type this command in the same directory where the Dockerfile is located (this will take several minutes). Change "andressepulveda/croco_ocean1.2.1b" with a name of your choice
```
docker build -t andressepulveda/croco_oceanv1.2.1_full .
```


## Getting started 


### Working inside the container

```
docker run -it --user croco andressepulveda/croco_oceanv1.2.1b
```

- Done, you're inside the docker container now. Let's run the Benguela test case. 
```
./create_myconfig.bash
(press "Y")
cd 
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_grd.nc
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_frc.nc
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_clm.nc
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_ini.nc
cd ..
./jobcomp
./croco croco.in
```
and your output files will be located in */home/croco/croco-v1.2.1/Run/CROCO_FILES*

### Storing input and out files outside the container

Create a local directory e.g. *croco_docker* and store the input files there

```
mkdir croco_docker
cd croco_docker
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_grd.nc
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_frc.nc
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_clm.nc
wget http://mosa.dgeo.udec.cl/CROCO2022/CursoBasico/Tutorial01/ArchivosIniciales/croco_ini.nc
cd ..
```
Now launch the container linking that local directory with the input/output directory in the container using the -v option

```
docker run -it -v /home/dgeo/croco_docker:/home/croco/croco-v1.2.1/Benguela/CROCO_FILES andressepulveda/croco_oceanv1.2.1c /home/croco/croco-v1.2.1/Benguela/croco /home/croco/croco-v1.2.1/Benguela/croco.in
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

## Create inputs file

If you create your container with the Dockerfile, we have added Octave v4.0.0 and octcdfv1.1.8
and all the datasets to allow the use of CROCO_TOOLS. 

**The following instructions will not work for the containers in DockHub**

### Known Errors

Before starting, fix this issues

- "oct_start.m"

Firt you need to edit "oct_start.m"
```
vim oct_start.m
```
and change
```
tools_path='../croco_tools/';
```
to
```
tools_path='../../croco_tools/';
```

-"make_clim" fails as a ";" is missing at the end of line 206 in the create_clim.m file located in 
```
/home/croco/croco_tools/Preprocessing_tools
```

### Initial steps 
```
octave_cli
>oct_start
>make_grid
>make_forcing
>make_clim
```
Now all the input files shoul be located in the **CROCO_FILES** directory and the default
Benguela simulation can be run by typing

```
./jobcomp
./croco croco.in
```


## Bugs
Please report any bugs [here](https://github.com/AndresSepulveda/docker-croco-public/issues).
