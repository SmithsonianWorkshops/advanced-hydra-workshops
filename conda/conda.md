# `conda` Intro (slides)

In the intro portion of the workshop you will learn:

* What is conda?
* What is conda not?
* Why is conda useful on the HPC?

---

## What is conda?

Conda is an open source package management system and environment management system.

Conda was originally created by a company called Continuum Analytics.

---

## What is conda not?

**Python**

Python is an interpreted programming language, like R

**Pip**

Pip is the built-in package manager for Python packages. It handles versions and dependencies that a given Python package might rely upon.

**Anaconda**

The Anaconda "distribution" of Python is an installation of the Python "interpreter", along with a lot of popular data science packages that can be notoriously hard to install. These packages often rely on compiling external libraries, so the conda package manager was created as an alternative to Pip.

---

## Why is conda useful on Hydra?

**Pre-compiled binaries**

If possible, we recommend that Hydra users install software by compiling the source code using the built-in compilers on Hydra.

However, sometimes this can be tricky. 

**Environments**

If you are using or building a multi-step pipeline that depends on specific versions of different tools, it's useful to have a self-contained "environment" with those versions. So that way you can have multiple installations of the same tool, and they don't interfere with each other.

# `conda` hands-on

In the hands-on portion of the workshop you will learn how to use a version of conda pre-installed on Hydra. You'll learn:
- Where to get help with conda
- How to find software to install
- How to install software using best-practices
- How to run the software you installed in submitted jobs on Hydra
- How to configure your Hydra account to make conda available when you log on (optional)
- How to share your installations with others on Hydra and elsewhere

## Log in to Hydra

If you need a reminder about how to log into Hydra and how to change your password, check out our Intro to Hydra tutorial: https://github.com/SmithsonianWorkshops/Hydra-introduction/blob/master/hydra_intro.md

## Accessing conda on Hydra

We'll be using `conda` that is pre-installed on Hydra and accessible via the module `tools/conda`.
Loading this module and then running `start-conda` will configure your current environment to use conda.

### Cleaning up previous configuration

If you've previously setup conda on Hydra, we'll ask you to disable that previous install. This will **NOT** remove your previous conda installation and software you've installed, it will only disable it from loading when you log in to Hydra.

Do you have a conda enabled in your current Hydra session? If either of these are true, you probably do.

Does your command prompt have `(base)`?

```
(base) [user@hydra-login01 ~]$
```

Does entering the `conda` command give you a usage message?

```
$ conda
usage: conda [-h] [-V] command ...

conda is a tool for managing and deploying applications, environments and packages.
...
```

If either of these are true run these commands to disable you current install (for BASH users):

```
$ cp -vi ~/.bashrc ~/.bashrc.bak 
$ conda init --reverse
```
The first command backs up your current ~/.bashrc file in case you want to go back to it later and the second command removes the conda initialization code. 

(An alternative is to edit your ~/.bashrc or ~/.cshrc (for csh users) and remove the lines between `# >>> conda initialize >>>` and `# <<< conda initialize <<<` )

Now, log out and back into Hydra. Is `(base)` removed from your command prompt? Does entering type `conda` command give `conda: command not found`? If so, you're ready to continue with the workshop. If not, please ask for help.

### The `tools/conda` module

We're going to load the `tools/conda` module from the login node.

*Load module*

```
$ module load tools/conda
Miniconda3 v23.1.0 loaded, to start conda, type start-conda
$ conda
-bash: conda: command not found
```

Unlike many modules, loading doesn't change your environment, other than creating the alias `start-conda`.

Running the hydra-specific command `start-conda` modifies your current environment to use conda. It not only changes your `PATH`, but other settings.


`(base)` in your command prompt indicates it is configured.

```
$ start-conda
(base)$ which python
/share/apps/tools/conda/23.1.0/bin/python
(base)$ python --version
Python 3.10.9
```

:warning: **You must enter the Hydra-specific command `start-conda` for conda to work!**

Discussion:
- What does `(base)` mean?
- Advanced: use `echo $PATH` to see how the `PATH` variable changes as you peform the above steps.
- This is an admin installed conda, how can I use it to install my own software!

### Advanced: what `start-conda` does

What does `start-conda` do? It sources the code produced by `conda shell.bash hook` (bash users) or `conda shell.tcsh hook`. This replicates what happens when you've configured conda to modify your environment at started using `conda init`.

Advanced bash and csh users are welcome to run `conda shell.bash hook` and `conda shell.tcsh hook` to see the script that is sourced.

## Help with the conda command line

- 'Official' cheat sheet (USEFUL!): https://docs.conda.io/projects/conda/en/latest/_downloads/a35958a2a7fa1e927e7dfb61ebcd69a9/conda-4.14.pdf
- Web:
  - Command reference: https://docs.conda.io/projects/conda/en/stable/commands.html
  - Managing packages: https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html
  - Working with environments: https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
  - And of course, using a search engine. Try: `conda activate` or `conda find package` or `conda install blast` 
- Carprentries conda lesson (in development): https://carpentries-incubator.github.io/introduction-to-conda-for-data-scientists/
- From the terminal:
  - `conda --help` 
  - For a specific command: `conda create --help`
  - Info on the Hydra conda module: `conda help tools/conda`

## Using conda to install software

There are different approaches to using conda to install software:
- If a conda package already exists for the software package: 
  - Install package(s) and all dependencies with conda, often with a single command.
- If the software is does not have a conda package (yet):
  - Install dependencies with conda and then setup/compile program while your conda environment is activated.
  - If it's a Python program without a conda package, use `pip` to install.

We'll start with installing programs when there's already a conda package available.

### Finding packages

There are several ways to find available packages.
- Web-based: https://anaconda.org
- Using `conda`: `conda search <name>`
- Developer's documentation

We'll explore the site https://anaconda.org which has listings of all the packages available through conda.

Go to that site now.

Use the "SEARCH PACKAGES" box.

Search for: blobtools

Channel: Bioconda
Package: blobtools
Latest version: 1.1.1
Platforms: Linux and "noarch"

What other versions are available?
Check in https://anaconda.org/bioconda/blobtools

You can see all the packages for a channel: https://anaconda.org/bioconda or https://anaconda.org/conda-forge.
However, you can't search within a channel in this interface (at least on anaconda.org).
The popular community moderated channels conda-forge and bioconda have there own websites where you can search within the channel:
- conda-forge packages: https://conda-forge.org/feedstock-outputs/
- bioconda packages: https://bioconda.github.io/conda-package_index.html

### Create an environment

A conda environment is an **isolated** set of install directories that contain all the files needed for a set of programs.
By being isolated from other environments, the dependencies of the programs in one environment won't interfere with other environments.
You have one environment active at a time with those programs available for use.

- You'll have full write-access to the environemnts you create (unlike `base` on Hydra).
- Best-practice is to create a separate environment for each pipeline.
- There is no environment "too small": even if the software does not have dependencies, it is often a good idea to install it in a separate environment.
- Environments can be thought of as 'disposable.' Recreate them as needed.
- Environments allow users to have different versions of Python installed than what is installed in `base`.

```
(base) $ conda create --name blobtools
Collecting package metadata (current_repodata.json): done
Solving environment: done

Please update conda by running

    $ conda update -n base -c defaults conda

## Package Plan ##

  environment location: /home/user/.conda/envs/blobtools

Proceed ([y]/n)? y

Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate blobtools
#
# To deactivate an active environment, use
#
#     $ conda deactivate
```

The output:
- `environment location: /home/user/.conda/envs/blobtools`
  - Conda will create the environment in your home directory in a hidden directory named `.conda`
  - That's a great place for it on Hydra because it's not scrubbed.
  - You can specify a different location with `--prefix /full/path/to/environment`.
- `To activate this environment, use $ conda activate blobtools`: You'll need to activate your new environment to start installing programs.
- `To deactivate an active environment, use $ conda deactivate`: When you're done with the enviornment, you can deactivate it, or you can close the terminal session.
- Note, you may recieve an alert that a newer version of conda is available. You won't be able to update on your own because you don't have write access to the `base` environment. The Hydra admin team will occasionally install new versions of conda.

## Activate your new environment
- `conda activate blobtools`
  - Start using your new environment.
  - At this point the only additional program you have is `conda`! The programs installed in `base` are *not* accessible.

```
(blobtools)$ which python
/usr/bin/python
(blobtools)$ python --version
Python 2.7.5
```

### Activating your existing conda environments
If you have been using conda on Hydra prior to this workshop, you likely have existing environments you still want to use.
You can do this with the `tools/conda` module.

Specify the path (full or relative) to the conda environment in `conda activate`.

```
(base)$ conda activate ~/miniconda3/envs/twobit
(twobit)$ 
```

### Channels

- Defaults (controlled by the Anaconda company): `main` and `R`
- Community moderated channels: e.g. `conda-forge`, `bioconda`
- Privately controlled channels. These can be publicly available or hidden : `dunnlab`, `faircloth-lab`, ...
  - These are not community curated, so they are more likely to be orphaned (no longer updated) or configured specifically for the needs of an individual or lab group.

When you use conda to install a package, the configured channel(s) are checked for packages and dependencies.

You can specify multiple channels to search for the program you want to install and its dependencies.

If you are installing a package from:
- `main` or `R` (Defaults), these should be configured as the highest priority for searching for packages.
- `conda-forge` or `bioconda`, `conda-forge` should be the highest priority with `bioconda` next, followed by Defaults.
- Discussion: What about the privately maintained community repos? 

:warning: If you don't have the channel priority set correctly, you can be installing dependencies that are not compatible with the package you want.

### Our reccomendations for settings

- `conda config --set channel_priority strict` (lower priority channels are not searched to find a compatible version of a program; default is `flexible`).

Add channels in this order: `defaults` will be lowest priority and `conda-forge` highest priority. 
```
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

```
(blobtools)$ conda config --show channels
channels:
  - conda-forge
  - bioconda
  - defaults
```

And you can view of your settings in the file `~/.condarc` 

```
(blobtools)$ cat ~/.condarc
channel_priority: strict
channels:
  - conda-forge
  - bioconda
  - defaults
```

`~/.condarc` can be manually edited or if you want to reset to default settings, it can be removed. 

### Installing

```
(blobtools)$ conda install blobtools

Collecting package metadata (current_repodata.json): done
Solving environment: failed with initial frozen solve. Retrying with flexible solve.
Solving environment: failed with repodata from current_repodata.json, will retry with next repodata source.
Collecting package metadata (repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /home/user/.conda/envs/blobtools

  added / updated specs:
    - blobtools

...

Proceed ([y]/n)? y


Downloading and Extracting Packages

Preparing transaction: done
Verifying transaction: done
Executing transaction: done

```

:clock1: This will take about five minutes in the "Solving enviornment" stage. (Good time for a break or talk about `mamba` :smile:)


### Add additional package

We've decided we also need to run NCBI's blast with this pipeline. We can install blast in the blobtools environment if it's still activated.

```
(blobtools)$ conda install blast
```

### Create environment and install package(s) in one step

You can create an environment, as we did before, AND add the programs that should be installed in one line.

First, make sure you're back in `base`. If not, deactivate you current environment.

```
(blobtools)$ conda deactivate
(base)$
```

Now the one-liner to create an environment and install packages:

```
$ conda create --name blobtools_with_blast -c conda-forge -c bioconda -c defaults --override-channels blobtools blast
...
```

The second thing we've added here for reproducability in this command is specifying the channels that should be used.
- The order of the `-c` (for channel) options defines the priority, with the one listed first as highest priority.
- `--override-channels` tells conda to ignore the defaults you previously defined.

This is the version of the command that is best to send to colleagues or document.


## Configuring conda to be active when you log into Hydra (optional)

Add to your `~/.bashrc` (bash users) or `~/.cshrc` (csh users):

```
module load tools/conda
start-conda
```

This is an alternative to using the `conda init` command.

## Exporting and sharing your environment

- Others can load your conda env (default is all can read on Hydra)
- Export package list, they can import
  - Some pipelines use this method (qiime2, phyluce)

You can create an export file that has a listing of all the packages and chanels used in your environment.
This can be used with colleagues to create their own environment.
These exports are platform specific, so an environment created on Hydra will work on other Linux system, but might not work on Macs or Windows.

```
(blobtools)$ conda env export --name blobtools > blobtools.yml
(blobtools)$ head blobtools.yml

name: blobtools
channels:
  - conda-forge
  - bioconda
  - defaults
dependencies:
  - _libgcc_mutex=0.1=conda_forge
  - _openmp_mutex=4.5=2_gnu
  - alsa-lib=1.2.8=h166bdaf_0
  - attr=2.5.1=h166bdaf_1
```

:alert: The list of channels is the current list from your settings, NOT what was used to do the actual installation.

You can then send that file to a collegue and they would create the environment with:

```
$ conda env create -f blobtools.yml --name blobtools-imported
```

If you don't specify `--name`, the orginal name of the exported environment will be used.

## Other topics

### Q: What's the best place to store my conda environments?
The default location in your home directory, `~/.conda/envs`, is fine. The envirnoments don't use much space
(typically 100M - 1GB, depending on the packages). The home directory is not scrubbed, which is essential
for software install directories.

:warning: The path to a conda environment shouldn't change after the envionrment is created. Some files
in the environment will have the path hard-coded into them. You can export and then import an 
environment to move it.

### Q. Can others use my conda environment
Yes. With the standard Hydra permissions, all-users will have read-only access to your environment.
They can use `conda activate /path/to/env` to activate your environment and use the installed software.

If they have permission issues, make sure the files are readable by all and executables+directories are executable by all.

One way to set those permissions is:

```
$ chmod -R a+r /path/to/env
$ find /path/to/env -executable -exec chmod a+x {} \;
```

## Common issues with `conda`

- SLOW: mamba as an alternative
- Errors you get if there are conflicting dependencies and package can't be installed?
- You install multiple packages, but you end up with an old version of packge (because of conflicting dependencies).
- The version of an available package is not the most recent the developer has released.


# Conda glossary

*Package:* A program and its installation instructions that are downloaded and executed by the `conda install` command. Packages are typicially modular, containing the executables, list of dependencies, and installation commands for one program. Multiple packages can be installed to provide access to different programs. 

*Channel:* A set of conda packages managed by an individual or organization. The conda script uses the list of conda channels that you specify when compiling the list of packages to install. 

*Channel priority:* The order that channels are checked for packages. The higher priority channels are checked before lower priority channels. This order is essential in determining what versions of programs are installed. 

*Environment:* A conda environment is a distinct set of packages and their dependencies that can be activated and used by a set of commands. By being distinct from other environments, the packages and the required versions installed in one environment won’t interfere with another. 

*Recipe:* part of a package that has the instructions for installing the program. It can include a list of dependencies (other required programs), and special instructions for the installation of the software. 

*Dependency:* A conda package that is required by another package. When installing a package, a list of dependencies is included. It will be installed if it's not already in your environment. Dependencies can have other dependencies which can make the determination of all the required programs by `conda install` time consuming. 

*Mamba:* An open source, community generated, alternative to the conda script. It is known for being faster than conda in creating the list of packages to install (‘solving the environment’).  

*Solving the environment:* During the installation process, when the conda script determines all the packages, their versions and channels, to be installed to satisfy all the programs and dependencies in the current environment. This step can fail if there are incompatible requirements for a program or there can be a downgrade of an already installed program to meet a requirement. 

## Using your conda environment in a job

- Here is an example of a job file using your conda environment to run blast:
  - First check which version of blast was installed into your environment with `blastn -v`. If it is not BLAST 2.13.0+, you should upgrade it: `conda install blast=2.13`. We have noticed that sometimes, depending on how channel priority is set, that an earlier version is installed. Once you have 2.13, you can use the below file.

```
# /bin/sh
# ----------------Parameters---------------------- #
#$ -S /bin/sh
#$ -q sThC.q
#$ -l mres=8G,h_data=8G,h_vmem=8G
#$ -cwd
#$ -j y
#$ -N blast_bold
#$ -o blast_bold.log
#
# ----------------Modules------------------------- #
module load tools/conda
start-conda
conda activate blobtools
#
# ----------------Your Commands------------------- #
#
echo + `date` job $JOB_NAME started in $QUEUE with jobID=$JOB_ID on $HOSTNAME
#
blastn -db /scratch/dbs/blast/bold/bold_blast_2023_01_20 \
       -query /data/genomics/workshops/conda/random_barcode.fasta \
       -max_target_seqs 20 \
       -outfmt "6 qseqid sseqid pident length qcovs evalue" \
       -out blast_bold_results.tsv
#
echo = `date` job $JOB_NAME done
```
