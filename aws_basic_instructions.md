(from https://github.com/tarankalra1/useful_funcs/blob/master/aws_basic_instructions.md )

These are the basic instructions for using AWS services that are equivalent to using a HPC system for scientific computing applications. They require no prior knowledge other than some basic familiarity with command line environments. A HPC type AWS cloud environment contains two resources that users would use and they include:
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
Now we are all set to use the AWS commandsfrom local machine and can check that this works by logging into AWS console (Section 1.1). 
We can try to send a simple textfile from local machine to AWS S3 storage.
```
aws s3 textfile_check.txt cp s3://coawst/textfile_check.txt  
```
Transfers a sample textfile_check.txt to S3/coawst directory. One can check that it is copied by accessing the S3 services in AWS console and navigating to the coawst folder. 

#### 3. Accessing the HPC resources on AWS cloud
Assuming that our scientific code is already setup on the cloud environment, the user needs to login into the master node of EC2 and then would use the compute nodes to run our jobs. These jobs are submitted through a batch job scheduler (Slurm or PBS). This is similar to a HPC environment.  
To do this, first the master node needs to be started. It can be thought of as turning the computer on. The master node can be started through the AWS console in the web interface or alternatively use the instance ID with the following command line option: 
```
aws ec2 start-instances instance-ids i-1235550000sample 
```
https://docs.aws.amazon.com/cli/latest/reference/ec2/start-instances.html

Now that the master node is running, we can login into that by using this command. At this point, the user should have a key pair (it could be a .pem file) to connect to the master node that is provided by the admin. The instructions for connecting to the instanceid can be found by clicking connect on the AWS console. From command line using the Public DNS and having the keypair, we can connect to the master node using:
```
ssh -i "keypairname.pem" root@ec2-xx-xx-xxxx--xxx.us-west-2.compute.amazon.com
```

After this, we are logged in the master node. From here on it is a regular HPC environment to run our jobs. Exiting the master node off first requires to just use "exit" command equivalent to getting out of our HPC computer but we also don't want to leave our master node running (i.e. our machine running). So we have to stop the instance. Exiting and turning the master node off. 
```
aws ec2 stop-instances instance-ids i-1235550000sample 
```
The admin can also create an alarm to automatically stop master node if it is left unused for a certain amount of hours or days.

Note- Do not terminate the instance from AWS console. Termination deletes all the data i.e. all the installed software in our case. 

An important part here is that unlike using the HPC facility, we have now created a cloud HPC environment and saving resources is more in our control than a 3rd party. 

