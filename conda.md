# Conda jargon

conda jargon:
- package
- channel
- environment
- recipe
- dependency

# `conda` hands-on

## Accessing conda on Hydra
 Conda is pre-installed on Hydra. You can access it with this module `tools/conda/23.1.0`.

*Before*
```
$ which python
/usr/bin/python
$ python --version
Python 2.7.5
````

*Load module and prepare enviornment*
```
$ module load tools/conda/23.1.0
Miniconda3 v23.1.0 loaded, to start conda, type start-conda
$ start-conda
(base) $
```
:warning: **You must enter the Hydra-specific command `start-conda` for conda to work!**

*After:*
```
$ which python
/share/apps/tools/conda/23.1.0/bin/python
$ python --version
Python 3.10.9
```

Discussion:
- What does `(base)` mean?
- Advanced: use `echo $PATH` to see how the `PATH` variable changes as you peform the above steps.

## Help with the conda command line

- Web:
  - Command reference: https://docs.conda.io/projects/conda/en/stable/commands.html
  - Managing packages: https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html
  - Working with environments: https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
  - And of course, using a search enging. Try: `conda activate` or `conda find package` or `conda install blast` 
- 'Official' cheat sheet: https://docs.conda.io/projects/conda/en/latest/user-guide/cheatsheet.html
- From the terminal:
  - `conda --help` 
  - For a specific command: `conda create --help`
  - Info on the Hydra conda module: `conda help tools/conda/23.1.0`


## Using conda to install software

Different approaches:
- Conda package already exists: install package(s) and all dependencies with conda
- Packge not available
  - Install dependencies and then setup/compile program
  - If it's a Python program, use `pip` to install

We'll start with installing programs when there's already a conda package available.

### Finding packages
- anaconda.org
  - What channel?
  - What version?
- Searching using the conda program

### Create an environment

- You'll have full write-access to the environemnts you create (unlike `base` on Hydra)
- Best-practice is to create a separate environment for each pipeline
  - This will be a set of programs that need to run in your analysis steps
  - Sometimes pipeline componenets can have conflicting dependencies, you might have to create separate dependencies for these components.
- By having separate environments, dependency conflicts will be less likely
- You can also create environments for specific programs.
- Environments can be 'disposable,'... [re-create when needed]
- Environments allow users to have a different version of Python installed than what is installed in `base`

```
(base) $ conda create --name workshop
Collecting package metadata (current_repodata.json): done
Solving environment: done

Please update conda by running

    $ conda update -n base -c defaults conda

## Package Plan ##

  environment location: /home/user/.conda/envs/workshop

Proceed ([y]/n)? y

Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate workshop
#
# To deactivate an active environment, use
#
#     $ conda deactivate
```

The output:
- `environment location: /home/user/.conda/envs/workshop`
  - Conda will create the environment in your home directory in a hidden directory named `.conda`
  - That's a great place for it on Hydra because it's not scrubbed
  - You can specify a different location with `--prefix /full/path/to/environment`
- `To activate this environment, use $ conda activate workshop`: You'll next activate our new environment to start installing programs.
- `To deactivate an active environment, use $ conda deactivate`: When You're done with the enviornment, you can deactivate it, or you can close the terminal session.
- Note, you may recieve an alert that a newer version of conda is available. You won't be able to update on your own because you don't have write access to the `base` environment. The Hydra admins will occasionally install new versions of conda.

## Activate your new environment
- `conda activate workshop`
  - Start using your new environment
  - At this point the only additional program you have is `conda`! The programs installed in `base` are *not* accessible.

```
$ which python
/usr/bin/python
$ python --version
Python 2.7.5
```

### Channels

- Defaults (controlled by the Anaconda company): `main` and `R`
- Community moderated channels: e.g. `conda-forge`, `bioconda`
- Privately controlled channels. These can be publicly available or hidden : `dunnlab`, `faircloth-lab`, ...
  - These are not community curated, so they are more likely to be orphaned (no no longer updated) or configured specifically for the needs of an individual or lab group.

When you use conda to install a package, the configured channel(s) are checked for packages and dependencies.

You can specify multiple channels to search for the program you want to install and its dependencies.

If you are installing a package from:
- `main` or `R` (Defaults), these should be configured as the highest priority for searching for packages.
- `conda-forge` or `bioconda`, `conda-forge` should be the highest priority with `bioconda` next, followed by Defaults.
- Discussion: What about the privately maintained community repos? 

:warning::warning::warning:
If you don't have the channel priority set correctly, you can be installing dependencies that are not compatible with the package you want.

- ?? Maybe hands-on showing different verisons/sources that will be installed depending on channel list?
- Best practice?: specify the channels during install and `--overide-channels` (others?)


### Our reccomendations for settings

`conda config --set channel_priority strict` Lower priority channels are not searched to find a compatible version of a program.
[Note: this really slows down conda install]

Add channels in this order. `defaults` will be lowest and `conda-forge` highest. 
```
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

```
$ conda config --show channels
channels:
  - conda-forge
  - bioconda
  - defaults
```

### Installing

```
$ conda install blobtools
```


[Maybe demo with something that has many dependencies? blobtoools? That one is interesting because https://github.com/DRL/blobtools gives instructions for installing the dependencies via conda, but there's also a bioconda package`]

- `conda create -n <name>`
  - Where is it created?
- `conda activate <name>`
- `conda install -c ... -c ...`
  - Channels are really important...
- combine in one step: `conda create -n <name> -c ... -c ... <package> <package>`

### Installing with `pip`

[Probably best to find a different example, this one doesn't install correctly with pip and it's actually available via bioconda. Maybe use Mike's tool that calculates assembly stats?]

AMAS "Alignment manipulation and summary statistics": https://github.com/marekborowiec/AMAS
`Borowiec, M.L. 2016. AMAS: a fast tool for alignment manipulation and computing of summary statistics. PeerJ 4:e1660.` http://dx.doi.org/10.7717/peerj.1660

- Not available on anacaonda.org [actually it is, whoops]
- Instructions say:
  - `sudo apt-get install python3` and `pip install amas`
  - `sudo` on Hydra is a red flag, you don't have sudo rights!
  - `apt-get` assumes you are running the Ubuntu flavor of Linux, which Hydra is not!

Our strategy: create a conda env with python3 and install amas into that env

```
$ conda create -n amas python=3
```

```
$ conda activate amas
```

```
$ pip install amas
```

Where did the executable go? /home/user/.conda/envs/amas-try2/lib/python3.11/site-packages/amas/AMAS.py
Well, maybe this isn't the best example :(

## Using your conda environment in a job

```
module load tools/conda
start-conda
conda activate <name>
```

## Sharing your environment

- Others can load your conda env (default is all can read on Hydra)
- Export package list, they can import
  - Some pipelines use this method (qiime2, phyluce)

## Common issues with `conda`

- SLOW: mamba as an alternative
- Errors you get if there are conflicting dependencies and package can't be installed?
- You install multiple packages, but you end up with an old version of packge (because of conflicting dependencies)
- The version of an available package is not the most recent the developer has released.


1. Packages
A conda package is the precompiled program and a link to all of the required packages that will also be downloaded and needed.
A whole pipeline can be defined in a package: all the scripts and dependent software (e.g. qiime2 or phyluce)
Packages are created by people in the community and shared publicly. Sometimes they’re created by the software developer, but they’re often by users of the software.
You can create your own packages which a great method for reproducible science and collaboration. We’re not covering that, but we can direct you to resources.
conda command
We'll be using the conda command for managing packages and controlling conda
Help with conda
conda help
conda install --help
You can consults the 'conda' command reference documentation, or
the conda "cheat sheet."
Listing installed packages
Some packages come pre-installed with either Anaconda or Miniconda (a lot more if you're using Anaconda), for Minconda:
(base)$ conda list
# packages in environment at /home/user/miniconda3:
#
# Name                    Version                   Build  Channel
_libgcc_mutex             0.1                        main
asn1crypto                1.2.0                    py37_0
ca-certificates           2019.10.16                    0
certifi                   2019.9.11                py37_0
cffi                      1.13.0           py37h2e261b9_0
chardet                   3.0.4                 py37_1003
conda                     4.7.12                   py37_0
conda-package-handling    1.6.0            py37h7b6447c_0
cryptography              2.8              py37h1ba5d50_0
...
How to find conda packages
You can search the public package repositories at https://anaconda.org/ (star) What we suggest using
Use the anaconda.org search feature.
Copy the install command from the package's page
Or do a web search: "conda r" or "bioconda mafft"
Or use conda search "blast" (finds packages with blast anywhere in their name in your current channels)

Search for admixtools on anaconda.org
Only available on bioconda
conda install -c bioconda admixtools
Search for mafft on anaconda.org
Available on multiple channels
bioconda, conda-forge, anaconda, r are reliable channels. You can try other popular ones.
Installing a package
conda install ... installs a packages and its dependencies
It doesn’t matter what your current directory is, it will install in your "conda" directory!
(warning) if you use the pre-installed version of Anaconda, you won't be able to install (or update) anything in the base environment,
(lightbulb) you will need to create and active your own conda environment(s) first (see below) and you will see that name in lieu of (base) in the following examples.
(base)$ conda install -c bioconda mafft
 
The following packages will be downloaded:
...
The following NEW packages will be INSTALLED:
...
Proceed ([y]/n)? y
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
Test it:
(base)$ mafft --help
------------------------------------------------------------------------------
  MAFFT v7.471 (2020/Jul/3)
  https://mafft.cbrc.jp/alignment/software/
  MBE 30:772-780 (2013), NAR 30:3059-3066 (2002)
------------------------------------------------------------------------------
Adding bioconda and conda-forge to your channels
(base)$ conda config --add channels defaults
(base)$ conda config --add channels bioconda
(base)$ conda config --add channels conda-forge
conda config --get channels shows your current channels
Which channel is the highest and which is the lowest?
$ conda config --get channels
--add channels 'defaults'   # lowest priority
--add channels 'bioconda'
--add channels 'conda-forge'   # highest priority
conda-forge is the highest, defaults is the lowest.
Note: the more channels you have, the increased time to "solve" installation.
(base)$ conda install iqtree
 
...
The following packages will be downloaded:
 
    package                    |            build
    ---------------------------|-----------------
    ca-certificates-2020.6.20  |       hecda079_0         145 KB  conda-forge
    certifi-2020.6.20          |   py37hc8dfbb8_0         151 KB  conda-forge
    conda-4.8.3                |   py37hc8dfbb8_1         3.0 MB  conda-forge
    iqtree-2.0.3               |       h176a8bc_0         2.8 MB  bioconda
    openssl-1.1.1g             |       h516909a_0         2.1 MB  conda-forge
    python_abi-3.7             |          1_cp37m           4 KB  conda-forge
    ------------------------------------------------------------
                                           Total:         8.2 MB
...
conda install tricks
Installing multiple items
conda install mafft gblocks
(star)“It is best to install all packages at once, so that all of the dependencies are installed at the same time.” https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html
Specifying program versions
Show available versions with: conda search python
conda install python=3
=3 matches the most recent version starting with 3
==3.7.5 matches exactly the version specified
">3.7" matches most recent version greather than 3.7 (in quotes because of the > which will interfere with the shell's redirection features)
"<3.8" matches most recent version less than 3.8 (in quotes because of the < which will interfere with the shell's redirection features)
See the conda documentation for more information
2. Using conda in submitted jobs
There are a couple steps needed to utilize conda in your submitted jobs.
(warning) By default the installed programs won't be found.
If you want to use your Miniconda installation:
Create a module file
There is Hydra documentation about creating module files here.
We'll set one up for your miniconda install. Module files are text files with instructions on how the current environment should be modified.
We suggest creating a directory in your home folder called modulefiles and creating a module called miniconda in that directory.
(base)$ mkdir ~/modulefiles
(base)$ cd ~/modulefiles
(base)$ nano miniconda
and then enter into the new text file:
#%Module1.0
prepend-path PATH /home/your_username/miniconda3/bin
(warning) Make sure to change your_username to your Hydra username!
Job file using your module file
Use the module load command followed by the path and name of your module file to load your module: module load ~/modulefiles/miniconda
Example job file using:
# /bin/sh
# ----------------Parameters---------------------- #
#$ -S /bin/sh
#$ -q sThC.q
#$ -l mres=2G,h_data=2G,h_vmem=2G
#$ -cwd
#$ -j y
#$ -N minicondatest
#$ -o minicondatest.out
#
# ----------------Modules------------------------- #
module load ~/modulefiles/miniconda
#
# ----------------Your Commands------------------- #
#
echo + `date` job $JOB_NAME started in $QUEUE with jobID=$JOB_ID on $HOSTNAME
echo + NSLOTS = $NSLOTS
#
echo "Conda location:"
which conda
 
echo
echo "Installed packages:"
conda list
 
#
echo = `date` job $JOB_NAME done
Excerpt of minicondatest.out:
...
Conda location:
/home/user/miniconda3/bin/conda
 
Installed packages:
# packages in environment at /home/user/miniconda3:
#
# Name                    Version                   Build  Channel
...
If you use the pre-installed Anaconda
No need to create a module
but you need to load the tools/conda module and run start-conda
Simply replace, in the examples above, the line
module load ~/modulefiles/miniconda
by the following two lines
module load tools/conda
start-conda
Even if you have these two lines in your ~/.bashrc  file. (lightbulb) You can save typing the first line in your job file if you insert it in a file called ~/.profile 
To enable conda  for your jobs that use the C shell (-S /bin/csh  or no -S  option passed):
either  add these two lines in your ~/.cshrc, or
add these two lines in you job file, or
the first one in your ~/.cshrc and the second in the job file.
(warning) If you need access to packages installed in an environment (see below) you will need to add the corresponding conda activate  command, like in
conda activate iqtree-v1
3. Wait, there's one more concept to keep things clean... environments
So far all installs we've done have done into one set of packages called (base).
What if programs have conflicting dependencies or you need different versions of the same program?
A conda Environment is a compartmentalized set of packages, and if you use the pre-installed Anaconda, it allows you to modify it (since you can't modify the pre-installed Anaconda base environment)
Also, the more packages you have, the longer it will take for conda on the "Solving Environment" step.

What if you wanted to have both iqtree1 and iqtree2 installed? Above we showed how to installed iqtree.
It installed the latest version: 2.0.3. If you also need iqtree 1.x installed, the conda command: conda install iqtree=1  will downgrade your current iqtree from 2.x to 1.x, it won't allow you to have more than one version installed. You can have environments to have access to the two versions. (Using iqtree=1 will install the latest version of iqtree that starts with a 1).
Creating an environment
(base)$ conda create -n iqtree-v1
Collecting package metadata (current_repodata.json): done
Solving environment: done
## Package Plan ##
  environment location: /home/user/miniconda3/envs/iqtree-v1
Proceed ([y]/n)? y
 
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate iqtree-v1
#
# To deactivate an active environment, use
#
#     $ conda deactivate
Adding packages to the environment
Although the output says to use conda activate..., we recommend using source activate... because it is compatible with job files submitted through qsub
(base)$ source activate iqtree-v1
(iqtree-v1)$ conda install iqtree=1
Note: you can create an environment and add packages do it in one step with: conda create -n iqtree-v1 iqtree=1 
Using an environment in your job file
When submitting a job that uses a specific conda environment, you need to use source activate ... after you load your miniconda module.
Example script:
...
# ----------------Modules------------------------- #
module load ~/modulefiles/miniconda
source activate iqtree-v1
#
# ----------------Your Commands------------------- #
...
Removing an environment
To remove an environment and all of its packages:
(warning) You have to deactivate the environment before removing it
(iqtree-v1)$ conda deactivate
(base)$ conda remove -n iqtree-v1 --all
 
Remove all packages in environment /home/user/miniconda3/envs/iqtree-v1:
 
## Package Plan ##
 
  environment location: /home/user/miniconda3/envs/iqtree-v1
 
The following packages will be REMOVED:
...
Proceed ([y]/n)? y
Useful environments: python2 and R
If you need to a use a program written in python2, you can create an environment with that version of Python
(base)$ conda create -n python2 python=2
(base)$ source activate python2
You can use conda to install R and R packages
(base)$ conda create -n tidyverse r r-tidyverse
(base)$ source activate tidyverse
When there isn't a conda package for a pipeline
Some pipelines don't have a conda package with all the requirements. You can use the program's documentation to install dependencies. 
For example the Hybpiper pipeline doesn't have a conda package (you could create one and contribute it to bioconda...), but The install instructions list these requirements:
Python 2.7 or later [We suggest python3 when possible -Hydra team]
BIOPYTHON 1.59 or later
EXONERATE
BLAST command line tools
SPAdes
GNU Parallel
BWA
samtools
Use conda to install the dependencies for HybPiper in your hybpiper environment. You may need to look up package names at anaconda.org or your favorite search engine. (Hint: pay special attention to GNU Parallel)
(base)$ conda create -n hybpiper install python=3 "biopython>1.59" exonerate blast spades parallel bwa samtools
 
Collecting package metadata (current_repodata.json): done
Solving environment: done
 
## Package Plan ##
 
  environment location: /home/user/miniconda3/envs/hybpiper
 
  added / updated specs:
  - biopython[version='>1.59']
  - blast
  - bwa
  - exonerate
  - parallel
  - python=3
  - samtools
  - spades
 
The following packages will be downloaded:
...
The following NEW packages will be INSTALLED:
...
Proceed ([y]/n)? y
...
Downloading and Extracting Packages
...
Now that the dependencies are installed, you can download the scripts for HybPiper:
cd ~
git clone https://github.com/mossmatters/HybPiper.git
(star) When you're done using an environment, you can go back to (base) with: conda deactivate
4.Troubleshooting
Finding online help:
Official conda website (it’s good): https://docs.conda.io
Specifically this page called Conda Package Manager
Web search with “conda” in it, e.g.: conda remove environment (this usually brings me to docs.conda.io)
si-hpc@si.edu email
Thursdays Brown Bags (12-1pm, W107 conference room)
Reinstalling
mv ~/miniconda3 ~/miniconda3-old (if you want to keep the old install) or rm -rf ~/miniconda3 (to delete the old install)
rm -rf .condarc .conda
Edit ~/.bashrc
delete lines from # >>> conda initialize >>> to # <<< conda initialize <<<
logout/back in
5. Advanced
Installing packages using pip if not available on conda
Exporting environment as environment.yml, and creating a simplified version for working on local computer
export: conda env export > environment.yml
import: conda env create -f environment.yml
This is how qiime2 install works
6. Appendix
Definitions
conda: open source package management tool
Anaconda®: commercial company that develops conda
Anaconda: distribution of conda with many data science tools pre-bundled
Miniconda: minimal distribution of conda, other packages can be added
Channel: grouping of packages managed by one group (e.g. bioconda, conda-forge)
Channels
Major conda channels:
Main: built and maintained by anaconda (setup by default)
R: R and packages for it (setup by default)
Conda-Forge: community contributions
Bioconda: contributions from biological community, find packages on https://bioconda.github.io
7. Additional commands
Remove packages
To remove a package from the current environment use conda remove [package] 
Update packages
To update a specific package use conda update [package]. To update all packages in the current environment use: conda update --all 
You can prevent conda update --all from updating some packages using these instructions
