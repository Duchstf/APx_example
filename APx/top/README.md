# Correlator Layer-1 Demo Project

# Before you clone the GIT repository

1) Create a github account:
> https://github.com/

2) On the Linux machine that you will clone the github from, generate a SSH key (if not already done)
> https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/

3) Add a new SSH key to your GitHub account
> https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/

4) Setup for large filesystems on github

```
$ git lfs install
```

5) Verify that you have git version 2.13.0 (or later) installed 

```
$ git version
git version 2.13.0
```

6) Verify that you have git-lfs version 2.1.1 (or later) installed 

```
$ git-lfs version
git-lfs/2.1.1
```

# Clone the GIT repository

```
$ git clone --recursive ssh://git@gitlab.cern.ch:7999/asvetek/correlator-layer1-demo.git 
```

# How to build the firmware 

1) Setup Xilinx environment

>  
```
$ source /opt/Xilinx/Vivado/2019.1/settings64.sh
```

2) Create a build directory (temporary Vivado project files)

```
$ cd correlator-layer1-demo
$ mkdir build
```
3) Make the firmware:

```
$ make
```

4) Optional: Review the results in GUI mode
```
$ make gui
```


