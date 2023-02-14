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
- `environment location: /home/user/.conda/envs/workblobtoolsshop`
  - Conda will create the environment in your home directory in a hidden directory named `.conda`
  - That's a great place for it on Hydra because it's not scrubbed
  - You can specify a different location with `--prefix /full/path/to/environment`
- `To activate this environment, use $ conda activate blobtools`: You'll next activate our new environment to start installing programs.
- `To deactivate an active environment, use $ conda deactivate`: When You're done with the enviornment, you can deactivate it, or you can close the terminal session.
- Note, you may recieve an alert that a newer version of conda is available. You won't be able to update on your own because you don't have write access to the `base` environment. The Hydra admins will occasionally install new versions of conda.

## Activate your new environment
- `conda activate blobtools`
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

And you can view of your settings in the file `~/.condarc` 

```
$ cat ~/.condara
channel_priority: strict
channels:
  - conda-forge
  - bioconda
  - defaults
```

### Installing

```
$ conda install blobtools

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

🕒 This will take about five minutes in the "Solving enviornment" stage.


### Add additional package

We've decided we also need to run NCBI's blast with this pipeline. We can install blast in the blobtools environment.

```
$ conda install blast
```

### Create environment and install package(s) in one step

Make sure you're back in `base`, if not deactivate you current environment

```
(blobtools)$ conda deactivate
(base)$
```

```
$ conda create --name blobtools_with_blast blobtools blast
...
```

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