(from https://github.com/tarankalra1/useful_funcs/blob/master/aws_create_HPC_environ.md )

These instructions would let one build a parallel cluster using AWS services. It will be equivalent to doing the job of an administrator for installing and maintaing a HPC facility for scientific computing applications. The instructions are heavily borrowed from the work of Jiawei Zhang from Harvard University. His two papers provide all the details related for advancing scientific computing applications on a cloud environment.The following steps require a basic knowledge of setting up COAWST on a local machine and a patient mind. 

A HPC type AWS cloud environment contains two resources that users would use and they include:
* EC2 -> Elastic Compute Cloud that is equivalent of having a machine to run the jobs.
* S3  -> Simple Storage Service that is where one can store (It is much cheaper to store here than EC2). 

#### 1. Obtaining a AWS account 
The AWS account for users is usually created by the overarching agency that is paying for those resources. 
It contains two pieces of information 
* 1.1 Username and password that can be used to login directly to the AWS website (aws.amazon.com) in this case. The user can use the web console to login check the status of resources under Services tab. One example of this could be checking the status of EC2 whether it is running, what amount of resources are being utilized etc., several other options for users to setup their cloud environment. 

* 1.2 AWS Identity and Access Management (IAM) information that contains an access key and secret access key. It is equivalent to having a secret key to use AWS commands from our local machine. The next step shows us how it is exactly utilized. 

#### 2. Setting up our local machine to use AWS commands
There are many ways to install software that can lead to using AWS commands from our local machine. One good idea is to use the anaconda tool that is widely used and is free to use. It can be downloaded in all platforms (Windows, MAC, Linux). The main idea behind using anaconda is to have a command type terminal on our local machine. Legacy users can think of this as CYGWIN. 
Download link: https://www.anaconda.com/distribution/#download-section

Once anaconda is installed it provides a command line environment to install AWSCLI (i.e. AWS Command Line Interface). AWSCLI software would let the users to use AWS commands from their local machine. To install AWSCLI open the anaconda terminal and type the following command to get the AWSCLI:
```
conda install -c conda-forge awscli
```
Next, download the AWS tool that would allow for parallel cluster management
```
conda install -c conda-forge aws-parallelcluster
```

Now we have the software installed to use AWS commands and need to configure them with the secret access key. 
This is done by the command:
```
aws configure 
```
It asks for the following questions that contain the IAM information for each user (Section 1.2). An example is shown here:
```
AWS Access Key ID [None]: ARANTLRADSGH 
AWS Secret Access Key [None]: wxxxxxxxxxxxxxxxxEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```
Now we are all set to use the AWS commandsfrom local machine and can check that this works by logging into AWS console (Section 1.1). We can try to send a simple textfile from local machine to AWS S3 storage.
```
aws s3 textfile_check.txt cp s3://coawst/textfile_check.txt  
```
Transfers a sample textfile_check.txt to S3/coawst directory. One can check that it is copied by accessing the S3 services in AWS console and navigating to the coawst folder.

#### 3. Configuring parallel cluster options 
We create the cluster on a master node. The master node manages the cluster and typically runs master components of distributed applications.  It also tracks the status of jobs submitted to the cluster and monitors the health of the instance groups.
This is similar to a HPC system.

Login to AWS console, search for EC2 service, then select keypair and create a new keypair (we called our "reaper"), selecting ".pem" for openssh. Download the .pem file and move to the ~/.ssh folder on your local machine.

Run 
```
pcluster configure ghost_config
```
where ghost_config is the configuration file name and use "reaper" for the keypair name (We created that keypair above). (Should already be in the selection menu)

It would ask for several options to setup the configuration file and ours are listed below. We have our configuration file below. 
Some of the important options during the setup are noted here:
* base_os = We chose the Centos operating system (Linux OS)
* compute_instance_type= defines the computing power and is associated with our account. We can use a different compute cluster
that has a higher memory and higher number of virtual cores. Because our account had set a maximum default of 16 virtual CPU's, we ended up using c5n.4xlarge. For more on computing instance types, check https://aws.amazon.com/ec2/instance-types/
* VPC instructions for AWS parallelcluster
Automate VPC creation? (y/n) [n]: y
Allowed values for Network Configuration:
a) Master in a public subnet and compute fleet in a private subnet
b) Master and compute fleet in the same public subnet
Network Configuration [Master in a public subnet and compute fleet in a private subnet]: 1
Beginning VPC creation. Please do not leave the terminal until the creation is finalized

* disable_hyperthreading = true (Models like COAWST benefit from disabling hyperthreading because .............communication slowdown..
  Taran check)
* enable_efa = (Not done yet and plan to do that)

##### Configuration file options
```
[aws]
aws_region_name = us-west-2

[global]
cluster_template = default
update_check = true
sanity_check = true

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}

[cluster default]
key_name = reaper
base_os = centos7
scheduler = slurm
master_instance_type = c5n.large
compute_instance_type = c5n.4xlarge
initial_queue_size = 1
max_queue_size = 8
maintain_initial_size = true
vpc_settings = default

[vpc default]
vpc_id = vpc-0402215e278931469
master_subnet_id = subnet-0d6031a19add9b228
compute_subnet_id = subnet-0b84ee057b64da006
use_public_ips = false
```
We have the same configuration file located at this link: https://github.com/rsignell-usgs/coawst-aws/blob/master/ghost_working_config

The we created the cluster with the name "ghost":
```
pcluster create -c ghost_config ghost
```
Note: 11 mins to finish this step  

When configuration was complete setting up it showed no errors in the config file and said that the stack was completed

Note: The configuration file is created on the path ~/.parallelcluster/ghost_config in our local machine

#### 4. Setting up the dependencies for COAWST on AWS cloud
Now that our parallel cluster is configured, we need to ssh into it and start installing the dependencies.
To login into the cluster "ghost" that we created in step 3, use:
```
plcuster start ghost 
``` 
Now we should be logged into our master node and ready to install dependencies for our software. 
This is where we use most of the instructions of Jiawei's latest blog post. 
We will use the package manager Spack which allows for using multiple versions of any software to be easily installed. For example, we 
can chose a particular version of netcdf and ifort. 

* 4.1 So, first we install SPACK 
```
cd $HOME
git clone https://github.com/spack/spack.git
cd spack
git checkout 3f1c78128ed8ae96d2b76d0e144c38cbc1c625df  # Spack v0.13.0 release in Oct 26 2019 broke some previous commands. Freeze it to ~Sep 2019.
echo 'source $HOME/spack/share/spack/setup-env.sh' >> $HOME/.bashrc
source $HOME/.bashrc
spack compilers  # check whether Spack can find system compilers
```
Note: we checked out a particular stable version of SPACK. We saved the path of spack in our .bashrc and then checked for Spack installed
compilers.

* 4.2 We are going to work with Intel license file and copy that to under the directory `/opt/intel/licenses/`. 

and then run 
```
spack config --scope=user/linux edit compilers
```
and edit the file 
```
~/.spack/linux/compilers.yaml
```
Copy and paste the following block into the file, in addition to the original `gcc` section:
```
- compiler:
    target:     x86_64
    operating_system:   centos7
    modules:    []
    spec:       intel@19.0.4
    paths:
        cc:       stub
        cxx:      stub
        f77:      stub
        fc:       stub
```

Install Intel compiler by running
```
spack install intel@19.0.4 %intel@19.0.4
``` 
Spack will spend a long time downloading the installer `http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15537/parallel_studio_xe_2019_update4_composer_edition.tgz`. When the download finishes, need to confirm the license term, by simply exiting the prompted text editor (`:wq` in `vim`).

Run 
```
find $(spack location -i intel) -name icc -type f -ls 
```
to get the compiler executable path like /home/centos/spack/opt/spack/.../icc.
Now we know where icc, ifort, etc. are located. We will add these paths in compiler.yaml of spack that we edited earlier.
Run 
```
spack config --scope=user/linux edit compilers
```
and edit the file 
```
~/.spack/linux/compilers.yaml
```
Fill in the previous stub entries with the actual paths: .../icc, .../icpc, .../ifort. 
(Without this step, will get configure: error: C compiler cannot create executables when later building NetCDF with Spack).

Now that the ifort, icc compilers are installed, we should add them in our .bashrc
```
source $HOME/spack/share/spack/setup-env.sh
source $(spack location -i intel)/bin/compilervars.sh -arch intel64
```

* 4.3 Installing Intel-MPI
AWS ParallelCluster comes with an Intel MPI installation, which can be found by 
```
module show intelmpi
```
and 
```
module load intelmpi
```
Now we will ensure that the intel mpi compiler is utilized instead of GNU compilers. So we modify our .bashrc
  ```
	export I_MPI_CC=icc
	export I_MPI_CXX=icpc
	export I_MPI_FC=ifort
	export I_MPI_F77=ifort
	export I_MPI_F90=ifort
	```
 Verify that `mpicc` uses intel compiler `icc` by:
	```
	module load intelmpi
	mpicc --version  # should be icc instead of gcc
  ```
  Now add these commands in the .bashrc file for future use
```
module load intel-19.0.4-intel-19.0.4-u3y3ya4
module load intelmpi
```
 
 ```
 spack compiler add
 ```
 * 4.4 NETCDF installation
 ```
spack -v install netcdf-fortran %intel ^netcdf~mpi ^hdf5~mpi+fortran+hl
```
Now in general when we build netcdf on local machines, we create a folder where all the libraries for netcdf and netcdf fortran exist
together. But with spack based netcdf installation, we have to softlink the netcdf-frotran to netcdf folder so everything exists in one place.
```
ln -s  $(spack location -i hdf5@1.10.5%intel@19.0.4.243)/lib/* $(spack location -i netcdf@4.7.0%intel@19.0.4.243)/lib/
ln -s  $(spack location -i netcdf-fortran)/lib/*                $(spack location -i netcdf@4.7.0%intel@19.0.4.243)/lib/
```
This creates a softlink for all the HDF5, NETCDF-C and NETCDF-Fortran libaries in the same NETCDF_LIBDIR

Do the same for NETCDF include 
```
ln -s $(spack location -i netcdf-fortran)/include/* $(spack location -i netcdf@4.7.0%intel@19.0.4.243)/include/
```
Now, let us add the paths of netcdf_libdir and netcdf_incdir in the .bashrc file. 
```
export NETCDF_LIBDIR=$(spack location -i netcdf@4.7.0%intel@19.0.4.243)/lib
export NETCDF_INCDIR=$(spack location -i netcdf@4.7.0%intel@19.0.4.243)/include
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${NETCDF_LIBDIR}
```
We have a sample .bashrc after installing all the dependencies located here: 
```
https://github.com/rsignell-usgs/coawst-aws/blob/master/.bashrc
```

#### 5. Compiling and running COAWST model
We have installed intel fortran compiler with netcdf and mpi which completes all the dependencies to compile COAWST model. 
We can download COAWST from
```
git clone https://github.com/jcwarner-usgs/COAWST.git
```
Note that this version of COAWST is not the official USGS distributed copy and its only used for testing purposes. 
We have edited a sample coawst.bash for trench case that can be obtained from this link: 
```
https://github.com/rsignell-usgs/coawst-aws/blob/master/coawst/coawst.bash
```
and a sample job script here. 
```
https://github.com/rsignell-usgs/coawst-aws/blob/master/coawst/run_test
```
