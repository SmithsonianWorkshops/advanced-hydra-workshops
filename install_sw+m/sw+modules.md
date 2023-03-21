
<!-- <- Last updated: Tue Mar 21 10:36:45 2023 -> SGK -->

# Installing Software and Writing Modules 

## Introduction

### Model, CoC and URLs

 - Carpentries model: hands-on portion, aka _live coding_

   - [Carpentries Code of Conduct](https://docs.carpentries.org/topic_folders/policies/code-of-conduct.html)

 - [`https://github.com/SmithsonianWorkshops/`](https://github.com/SmithsonianWorkshops/advanced-hydra-workshops/)

   - view [_slides_](https://github.com/SmithsonianWorkshops/advanced-hydra-workshops/blob/main/install_sw+m/sw+modules-all.pdf)
     or the [_markdown_](https://github.com/SmithsonianWorkshops/advanced-hydra-workshops/blob/main/install_sw+m/sw+modules.md) version


### In the intro portion of the workshop you will learn:

* About downloading code
* About compiling code
* How to build a package from source code
  - configure
  - build
  - install
* What are `yum`, `rpm`, `get-apt`, & `sudo`
* How to write modules


---

## Downloading Code

### Source vs Executable

- In most cases you are better off downloading the source and building the code (aka the executable) yourself.

- Downloading an executable is easier but likely will not work.

### Downloading Executables

Some developers provide pre-built executables of their software.

There are instances when available executables will run flawlessly on Hydra, but make sure that:

 1. you can trust the origin,
 1. you get a version compatible with Hydra, 
    * _i.e._, CentOS 7.x for Intel/AMD CPUs (`x86_64`)

### Remember 

 * Hydra configuration is specific: 
    * pre-built code may need _stuff_ (dependencies) not on Hydra.

---

## Notes on Downloading Executables

### Risks

- Since users on Hydra do not have elevated privileges (root access) you are very unlikely to damage the cluster, but malicious software can still damage your files.

&nbsp;

- In rare cases it may install a _Trojan horse_ that could exploit a known vulnerability.

  - Be vigilant and responsible.

  - In case of doubt, never hesitate to contact us.

---

## Compiling code

### Steps

 Creating executable from source code is typically done as follows:

  1. compile the source file(s) to produce object file(s),
  1. link the object file(s) and libraries into an executable. 
  
### In Practice

  - Often aided by a `makefile`,
  - _Configuring_ is creating such `makefile` or equivalent.

&nbsp;

&nbsp;

> This will be illustrated in the hands-on section.

---

## Building from Source

### 1. Configure

- Most packages come with a configuration script, a list of prerequisites (dependencies/libraries) and instructions,

- Some packages allow you to build the code without some features in case you cannot satisfy some of the prerequisites,

- You most likely need to load the right module(s) to use the appropriate
  tools (compilers).

- The configuration step will test if the code can be built:
  - check dependencies, versions, etc.
  - if this fails, the code cannot be built as is.

### 1.b Makefile only

- Other (simpler) packages come with a `makefile` that needs to be edited,
  - check the instructions.

---

## Building from Source (cont'd)


### 2. Build

- make sure you have loaded the right modules,

- run `make` to compile and link (aka build) the code.

### 2.b Test

- some packages come with the optional step of testing the built before installing it,
  using something like `make test`.

### 3. Install

- copy the executable(s) to the right place(s),
      
  - usually defined by the configuration,

- best practice is to separate build from install locations.


---

## Basics about `make` and `makefile`

### The command `make`

 - `make` is a utility to maintain groups of programs.

 - Uses instructions in a `makefile` to build targets from sources by following rules.

 - written to help build & maintain code, can be used
   for a lot more (full Carpentries module).

### Examples:

 - build the first target listed in the `makefile`:

```
make
```

  - build the target "`this`" listed in the "`makefile`" file:

```
make this
```

  - build "`that`" using "`makefile.special`" and set "`VAR`" to "`val`":

```
make -f makefile.special VAR=val that
```

---

## Basics about `make` and `makefile` (cont'd)

### The `Makefile` or `makefile` files

 - a file that defines targets and codifies rules and dependencies to build targets;

   - dependency: has a source needed to build something changed?

 - it can be very simple, but can also be quite complex.


&nbsp;

### Also

 - `make` has implicit rules:

   - can build targets w/out a `makefile` or w/out rules.

&nbsp;

> This will be illustrated in the hands-on part

---

## Setting up Your Environment to Run Your Code

### Likely Needed

You likely will need to adjust your _environment_ to run some code:

  1. the location of the code: `path` or `PATH`,
  1. the location of the libraries:  `LD_LIBRARY_PATH`,
  1. you may also need to set some environment variables, etc.

&nbsp;

### Easier Way: modules

This is where using a module makes things easy: 

- compact, and

- works with any shell.

---

## The `yum`, `rpm`, `get-apt` and `sudo` Soup

### Definitions

- `yum`: is a package-management utility for CentOS

- `rpm`: pre-built software package
  - _both_ are for sys-admin, 
  - help handle dependencies,
  - _yet_ ...
- `get-apt`: Debian's version of `yum`, _does not work_ on CentOS.

### Also 

- `sudo`: allows to run a command as 'root': **you can't!**

### BTW

- Instructions that mention `yum`, `rpm`, `apt-get` or `sudo` 

  - **will not work** on Hydra,

  - **yet** in most cases there is another way.

---

## How about Hydra

### Using `yum`

  - While you **cannot** install packages with `yum`,
  - you can check if we've installed a prerequisite package

&nbsp;

### In practice

  - if the instructions say
```
sudo yum -y install <package>
```
  - you can run 
  ```
yum info <package>
  ``` 

---

## Using `yum info`

### Example

```
yum info libXt-devel
... stuff and may be slow the first time ...
Installed Packages
Name        : libXt-devel
Arch        : x86_64
Version     : 1.1.5
...
Description : X.Org X11 libXt development package
...
```

###

 You want the `Arch: x86_64` to be listed as "Installed" not _just_ "Available".

---

## How to avoid `sudo`

### `sudo make install`

  - if the instructions says
```
sudo make install
```
  - instead, set the installation directory to be under your control,
  - in most cases at the configuration step
```
./configure -prefix=/home/<username>/big-package/3.5
```

  - and use
```
make install
```

### 

 Replace `<username>` by your username.

---

## Final Notes

### Remember

  - there is a way to use `yum` as a non privileged user 
    - not recommended, unless you're an **expert**!
  - you can always ask about a missing prerequisite,
  - most of those can be built from source since Linux is an open source OS.
  
---

## Module and Module Files

### The Command `module`

- convenient mechanism to configure your _environment_,

- reads a file, the _module file_, that holds instructions,

 - a shell independent way to configure your environment:

   - _same_ module file whether `sh/bash` or `csh/tcsh`.
 
&nbsp;

### Examples

 - We provide module files, users can write their own.
   - look at all the module files we wrote,
   - they can be found in `/share/apps/modulefiles/`

---

## Module File Syntax and Concepts

### Special Instructions

- Instructions to configure your environment:
```
prepend-path PATH /location/of/the/code
setenv       BASE /scratch/demo
set-alias    crunch "crunch --with-that-option \*"
```

### Syntax

- Module files can be complex, using `tcl` language
  - you **do not** need to know `tcl` to write module files.  

### Simple or Complex

- A simple module file can just list the modules that must
  be loaded to run some analysis.
- Can write complex module files and leverage `tcl`.

---

## Example of `module` Commands

### Basic

|          | Info            | Config   | Details       |
|----------|-----------------|----------|---------------|
| `module` | `avail`         | `load`   | `list`        |
| `module` | `whatis`        | `unload` | `help <name>` |
| `module` | `whatis <name>` | `swap`   | `show <name>` |

&nbsp;


### More help

```
  man module
```

---

## A Simple Module File

### Example 

```
#%Module1.0
#
# load two modules and set the HEASOFT env variable
module load gcc/10.1.10
module load python/3.8
setenv HEASOFT /home/<username>/heasoft/6.3.1
```

###

 Replace `<username>` by your username.

## Example of More Elaborate and Complex Module Files

> Will be illustrated in the hands-on section.

---

## Module Files Organization


### Recommended Approach

  - use a central location under you home directory `~/modulefiles`,

  - use a tree structure 
 
  - use version numbers if/when applicable,

  - let `module` know where to find the module files.

---

## Customization/Examples

<!-- use ASCII art for the tree? -->

### Tree structure
```
   ~/modulefiles/crunch/
   ~/modulefiles/crunch/1.0
   ~/modulefiles/crunch/1.2
   ~/modulefiles/crunch/2.1
   ~/modulefiles/crunch/.version
   ~/modulefiles/viewit
```
### Define a Default Version  

An optional file `.version` can be used to set the default version:

```
  #%Module1.0
  set ModulesVersion "1.2"
```

### Hence
```
  module load crunch
  module swap crunch/2.1
```

----

## Customization (cont'd)


### Let `module` Know Where to Find the Module Files

&nbsp;

  ```
module use --append ~/modulefiles
```
### Either

  1. in your initialization file `~/.bashrc` or `~/.cshrc`
  1. or better yet in a `~/.modulerc` file

&nbsp;

```
  #%Module1.0
  # adding my own module files
  module use --append /home/username/modulefiles
```

---

# Hands-on Section

## Hands-On

### In the hands-on portion of the workshop you will 

- Build and install software using best-practices,
  - trivial case,
  - simple/didactic example,
  - somewhat complex examples.

- Write simple and more elaborate module files.

- Run the software you installed in jobs.

### But first, log in to Hydra

- If you need a reminder about how to log into Hydra and how to change your
password, check the [_Intro to Hydra_](https://github.com/SmithsonianWorkshops/Hydra-introduction/blob/master/hydra_intro.md)
tutorial.

  - If the link does not work:

```
https://github.com/SmithsonianWorkshops
  > Hydra-introduction
    > hydra_intro.md
```

:tea: Let's pause here for 5-10 minutes :coffee:

---

## <a name="here"></a>Switch to `github` for the Hands-on

### Go to
 [https://github.com/SmithsonianWorkshops/advanced-hydra-workshops/](https://github.com/SmithsonianWorkshops/advanced-hydra-workshops/blob/main/install_sw+m/sw+modules.md#here)

### Convention

- I use `% ` as prompt
  - your prompt might be different, like `$ `
  - you type what is **after** the prompt
  - no prompt: result from previous command.

- I where you see `<genomics|sao>`, you need to use either `genomics` or `sao`,

- I where you see `<username>`, you need to substitute your username.

<!-- <- Last updated: Fri Mar 17 11:58:51 2023 -> SGK -->


## First

### Create a location where to run things

- For biologists (non SAO)
```
$ cd /pool/genomics/$USER
```
- For SAO (CfA)
```
% cd /pool/sao/$USER
```
- For all

```
% mkdir -p ahw/sw+m
% cd ahw/sw+m
```

- `$USER` will be replaced for you by your username,
  - feel free to put this elsewhere.

:question: `-p`

---

## Exercise 1

### Install a simple prebuilt executable: `rclone`

1. Create a directory
```
% mkdir ex01
% cd ex01
```
2. Get `rclone`
- Google "download rclone linux" --> https://rclone.org/install/
- look under "[Linux Installation](https://rclone.org/install/#linux)"
```
% wget https://downloads.rclone.org/rclone-current-linux-amd64.zip
--2023-03-14 14:20:17--  https://downloads.rclone.org/rclone-current-linux-amd64.zip
Resolving downloads.rclone.org (downloads.rclone.org)... 95.217.6.16
Connecting to downloads.rclone.org (downloads.rclone.org)|95.217.6.16|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 17790831 (17M) [application/zip]
Saving to: 'rclone-current-linux-amd64.zip'
100%[================================================>] 17,790,831  5.54MB/s   in 3.1s
2023-03-14 14:20:21 (5.54 MB/s) - 'rclone-current-linux-amd64.zip' saved [17790831/17790831]

% unzip rclone-current-linux-amd64.zip
Archive:  rclone-current-linux-amd64.zip
   creating: rclone-v1.62.2-linux-amd64/
  inflating: rclone-v1.62.2-linux-amd64/README.txt
  inflating: rclone-v1.62.2-linux-amd64/rclone
  inflating: rclone-v1.62.2-linux-amd64/git-log.txt
  inflating: rclone-v1.62.2-linux-amd64/README.html
  inflating: rclone-v1.62.2-linux-amd64/rclone.1
```
  - If the `wget` fails, you can copy that `zip` file as follows:
```
% cp -pi /data/sao/hpc/ahw/sw+m/ex01/rclone-current-linux-amd64.zip ./
```
3. Install `rclone`
```
% mkdir -p bin man/man1
% cp -pi rclone-v1.62.2-linux-amd64/rclone bin/
% cp -pi rclone-v1.62.2-linux-amd64/rclone.1 man/man1/
```

:question: `-pi`

:question: `man/man1`

4. Use it
```
% $PWD/bin/rclone version
rclone v1.62.2
- os/version: centos 7.9.2009 (64 bit)
- os/kernel: 3.10.0-1160.81.1.el7.x86_64 (x86_64)
- os/type: linux
- os/arch: amd64
- go/version: go1.20.2
- go/linking: static
- go/tags: none

% man -M $PWD/man rclone
                                            rclone(1)

Rclone syncs your files to cloud storage
       o About rclone
...
press 'q' to quit
```

:question: `-M`

- we will later write a module to use that version.

### Note how these steps are different from the instructions

- :warning: did not follow _verbatim_ the instructions on the web page (or `README.txt`):
  - nothing copied under `/usr/bin/`,
  - no `chown root`, and
  - no `sudo`

> Yet you have installed `rclone`.

---

## Exercise 2

### Compiling a trivial program

- Let's build from source a _very very very_ simple code:

1. create a directory and copy the source file
```
% cd ..
% mkdir ex02
% cd ex02
% cp -pi /data/sao/hpc/ahw/sw+m/ex02/hello.c ./
```
2. look at the code
```
% cat hello.c
#include <stdio.h>
#include <stdlib.h>
/* simple hello world demo code in C */
int main () {
  printf ("hello world!\nEasy peasy ;-P\n");
  exit(0);
}
```
3. compile it: source to object file
```
% make hello.o
cc    -c -o hello.o hello.c
% file hello.o
hello.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
```
4. link it: object to executable
```
% make hello
cc   hello.o   -o hello
% file hello
hello: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs) ...
```
5. run it
```
% ./hello
hello world!
Easy peasy ;-P
```

> Congrats, you've built a code from source.

---

## Excercise 3

- Similar simple code but let's use
  - a `makefile` file, and 
  - a different compiler by loading a `module`

1. create a directory and copy the source and makefile files
```
% cd ..
% mkdir ex03
% cd ex03
% cp -pi /data/sao/hpc/ahw/sw+m/ex03/hello.c ./
% cp -pi /data/sao/hpc/ahw/sw+m/ex03/makefile ./
```
2. look at the files
```
% more hello.c makefile
.... 
```
3. load the Intel compiler, build and run it
```
% module load intel
Loading compiler version 2021.4.0
Loading tbb version 2021.4.0
Loading compiler-rt version 2021.4.0
Loading debugger version 10.2.4
Loading dpl version 2021.5.0
Loading oclfpga version 2021.4.0
Loading init_opencl version 2021.4.0
Loading mkl version 2021.4.0
Note: use $MKL_ROOT not $MKLROOT to access Intel's MKL location

Loading intel/2021
  Loading requirement: tbb/latest compiler-rt/latest debugger/latest dpl/latest init_opencl/latest oclfpga/latest compiler/latest
    mkl/latest

% make hello
icc    -c -o hello.o hello.c
icc -o hello hello.o

% ./hello
hello world!
```

:exclamation: `icc` not `cc`

4. Dependency explained

```
% make
make: `hello' is up to date.
% touch hello.o
% ls -ltr
....

% make
icc -o hello hello.o
% ls -ltr
....

% touch hello.c
% ls -ltr
....

% make
icc    -c -o hello.o hello.c
icc -o hello hello.o

% make
make: `hello' is up to date.
```

> :bulb: `make` only builds what is needed.

5. Build `hello` to behave differently

   - remove what was built 

   - re-compile with a special flag

```
% make clean
rm hello hello.o

% make CFLAGS=-DEASY hello
icc -DEASY   -c -o hello.o hello.c
icc -o hello hello.o

% ./hello
hello world!
Easy peasy ;-P
```

> :bulb: Simplistic illustration how "configuration" affects code building.


5. Cleanup

```
% module list
% module unload intel
```

---

## Build some "Bio" Packages

### Intro

  - We will build two popular biology packages, 
    [RAxML](https://github.com/stamatak/standard-RAxML) and 
    [samtools](https://www.htslib.org).

### Building `RAxML`

  1. Create a directory and download the RAxML source files.

```
$ cd ..
$ mkdir raxml
$ cd raxml
$ git clone https://github.com/stamatak/standard-RAxML.git

```

  2. You can choose to build a sequential version (no multithreading), a
     multithreaded version (PTHREADS) or a MPI version. A different makefile
     is supplied for each version. Look at the different versions.

```
$ ls
standard-RAxML
$ ls standard-RAxML
ancestralStates.c                gpl-3.0.txt                 Makefile.AVX.MPI.gcc       Makefile.SSE3.MPI.gcc         rapidBootstrap.c
avxLikelihood.c                  leaveDropping.c             Makefile.AVX.PTHREADS.gcc  Makefile.SSE3.PTHREADS.gcc    README
axml.c                           legacyCode.c                Makefile.AVX.PTHREADS.mac  Makefile.SSE3.PTHREADS.mac    rmq.h
axml.h                           Makefile.AVX2.gcc           Makefile.gcc               Makefile.SSE3.QuartetMPI.gcc  rmqs.c
bipartitionList.c                Makefile.AVX2.HYBRID.gcc    Makefile.HYBRID.gcc        makenewzGenericSpecial.c      rmqs.h
classify.c                       Makefile.AVX2.mac           Makefile.MPI.gcc           manual                        rogueEPA.c
eigen.c                          Makefile.AVX2.MPI.gcc       Makefile.PTHREADS.gcc      mem_alloc.c                   searchAlgo.c
evaluateGenericSpecial.c         Makefile.AVX2.PTHREADS.gcc  Makefile.PTHREADS.mac      models.c                      topologies.c
evaluatePartialGenericSpecial.c  Makefile.AVX2.PTHREADS.mac  Makefile.QuartetMPI.gcc    multiple.c                    treeIO.c
fastDNAparsimony.c               Makefile.AVX.gcc            Makefile.SSE3.gcc          newviewGenericSpecial.c       usefulScripts
fastSearch.c                     Makefile.AVX.HYBRID.gcc     Makefile.SSE3.HYBRID.gcc   optimizeModel.c               WindowsExecutables_v8.2.10
globalVariables.h                Makefile.AVX.mac            Makefile.SSE3.mac          parsePartitions.c             WindowsExecutables_v8.2.4
```

  3. Unload the intel compiler, load the `gcc` compiler, and build different versions of RAxML. 

     - :warning: loading the right version of `gcc` is important

```
$ module unload intel
$ module load gcc/7.3.0
$ cd standard-RAxML
$ make -f Makefile.SSE3.gcc
rm -f *.o raxmlHPC-SSE3
gcc  -D__SIM_SSE3  -msse3 -D_GNU_SOURCE -O2 -fomit-frame-pointer -funroll-loops     -c -o axml.o axml.c
gcc  -D__SIM_SSE3  -msse3 -D_GNU_SOURCE -O2 -fomit-frame-pointer -funroll-loops     -c -o optimizeModel.o optimizeModel.c
gcc  -D__SIM_SSE3  -msse3 -D_GNU_SOURCE -O2 -fomit-frame-pointer -funroll-loops     -c -o multiple.o multiple.c...

$ make -f Makefile.SSE3.PTHREADS.gcc
rm -f *.o raxmlHPC-PTHREADS-SSE3
gcc  -D_USE_PTHREADS -D__SIM_SSE3 -D_GNU_SOURCE -msse3 -O2 -fomit-frame-pointer -funroll-loops     -c -o axml.o axml.c
gcc  -D_USE_PTHREADS -D__SIM_SSE3 -D_GNU_SOURCE -msse3 -O2 -fomit-frame-pointer -funroll-loops     -c -o optimizeModel.o optimizeModel.c
gcc  -D_USE_PTHREADS -D__SIM_SSE3 -D_GNU_SOURCE -msse3 -O2 -fomit-frame-pointer -funroll-loops     -c -o multiple.o multiple.c...

```

  - to build the MPI version, you also need to load the gcc `openmpi` for that
    version

```
$ module load gcc/7.3/openmpi
$ make -f Makefile.SSE3.MPI.gcc
rm -f *.o raxmlHPC-MPI-SSE3
mpicc  -D_WAYNE_MPI -D__SIM_SSE3 -O2 -D_GNU_SOURCE -msse3 -fomit-frame-pointer -funroll-loops     -c -o axml.o axml.c
mpicc  -D_WAYNE_MPI -D__SIM_SSE3 -O2 -D_GNU_SOURCE -msse3 -fomit-frame-pointer -funroll-loops     -c -o optimizeModel.o optimizeModel.c
mpicc  -D_WAYNE_MPI -D__SIM_SSE3 -O2 -D_GNU_SOURCE -msse3 -fomit-frame-pointer -funroll-loops     -c -o multiple.o multiple.c...
```

 4. Copy the executables into a `bin/` directory and run RAxML.

```
$ mkdir bin
$ cp raxmlHPC-SSE3 raxmlHPC-PTHREADS-SSE3 raxmlHPC-MPI-SSE3 bin/

$ cd bin
$ ls
raxmlHPC-MPI-SSE3  raxmlHPC-PTHREADS-SSE3  raxmlHPC-SSE3
$ ./raxmlHPC-PTHREADS-SSE3

WARNING: The number of threads is currently set to 0
You can specify the number of threads to run via -T numberOfThreads
NumberOfThreads must be set to an integer value greater than 1

RAxML, will now set the number of threads automatically to 2 !


 Error, you must specify a model of substitution with the "-m" option

$ ./raxmlHPC-PTHREADS-SSE3 -help
This is RAxML version 8.2.12 released by Alexandros Stamatakis on May 2018.

With greatly appreciated code contributions by:
...
```

---

### Building `samtools`

1. Create a directory and download the `samtools` and `ncurses` source
   files. `ncurses` is a library that samtools needs to be compiled
   successfully.

 - First, cd back into your workshop directory.

```
$ pwd
/pool/<genomics|sao>/<usename>/ahw/sw+m/raxml/standard-RAxML/bin

$ cd ../../..
$ pwd
/pool/<genomics|sao>/<usename>/ahw/sw+m
```

 - Create a directory and download the source files

```
$ mkdir samtools
$ cd samtools
$ wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2
$ wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.4.tar.gz
$ tar xvf samtools-1.17.tar.bz2
$ tar xvf ncurses-6.4.tar.gz
$ mv samtools-1.17 1.17
```

2. Load the `gcc/7.3.0` module, build ncurses and samtools.

 - load the  `gcc/7.3.0` module

```
$ module list
$ module load gcc/7.3.0
$ module list
```
 - build `ncurses`

```
$ cd ncurses-6.4
$ ./configure --prefix=/pool/<genomics|sao>/$USER/samtools/1.17 |& tee do-configure.log

$ make |& tee make.log

$ make install |& tee install.log
```

 - Build `samtools`

:warning: using `bash`
```
$ cd ../1.17
$ PFX=/pool/<genomics|sao>/$USER/samtools/1.17
$ CPPFLAGS="-I${PFX}/include"
$ LDFLAGS="-L${PFX}/lib"
$ export CPPFLAGS LDFLAGS

$ echo $CPPFLAGS $LDFLAGS
$ ./configure --with-ncurses --prefix=$PFX |& tee do-configure.log
```
:warning: using `csh`
```
% cd ../1.17
% set PFX = /pool/<genomics|sao>/$USER/samtools/1.17
% setenv CPPFLAGS "-I${PFX}/include"
% setenv LDFLAGS  "-L${PFX}/lib"

% echo $CPPFLAGS $LDFLAGS
% ./configure --with-ncurses --prefix=$PFX |& tee do-configure.log
```

> use `genomics` or `sao` for `PFX`

  - build and install 

```
$ make && make install
```

or

```
$ make |& tee make.log
$ make install |& install.log
```

  - test it

```
$ cd $PFX
$ mv bin bin-ncurses
$ mkdir bin && cd bin
$ cp ../ bin-ncurses/samtools .
$ ./samtools
....
```

 - cleanup

using `bash`
```
$ module list
$ module unload gcc
$ unset PFX CPPFLAGS LDFLAGS
```
using `csh`
```
% module list
% module unload gcc
% unset PFX
% unsetenv CPPFLAGS LDFLAGS  
```

---

## Examples of Building a Large "Astro" Package

### `HEASoft`

 - building the following package would take too long, so I will just
   illustrate how I did it.

 - `HEASoft` at [https://heasarc.gsfc.nasa.gov/docs/software/heasoft/](https://heasarc.gsfc.nasa.gov/docs/software/heasoft/)

   - Hydra is running CentOS 7.x, or a 'RPM-based' Linux (like RHEL, Fedora :tophat:).

   - Instructions at [https://heasarc.gsfc.nasa.gov/docs/software/heasoft/fedora.html](https://heasarc.gsfc.nasa.gov/docs/software/heasoft/fedora.html).

   - :warning: lots of `sudo` and `yum`, **cannot** follow these instructions
     _verbatim_ on Hydra :confused:


 - I wrote 3 _simple_ "source" files:

 1. Configuration

```
==> do-configure.sou <==
module load gcc/10.1.0
module load tools/python/3.8
module list
#
setenv PYTHON python3
setenv PERL   perl
setenv CC     gcc
setenv CXX    g++
setenv FC     gfortran
#
./configure --prefix=/scratch/sao/hpc/tests/xspec/6.31.1-no-openmp \
  --without-lynx --disable-x \
  --disable-openmp --enable-readline
```

  2. Build (make)
```
==> do-make.sou <==
module load gcc/10.1.0
module load tools/python/3.8
module list
#
setenv PYTHON python3
setenv PERL   perl
setenv CC     gcc
setenv CXX    g++
setenv FC     gfortran
#
# 
make -j 8 >& make.log &
```

:question: `-j 8`

  3. Install
```
==> do-install.sou <==
module load gcc/10.1.0
module load tools/python/3.8
module list
#
setenv PYTHON python3
setenv PERL   perl
setenv CC     gcc
setenv CXX    g++
setenv FC     gfortran
#
make install >& install.log &
```

---

## How to use them

### Configure

```
% cd BUILD_DIR
% source ../do-configure.sou |& tee do-configure.log
.... lots of text ...
```
:question: `|& tee`

### Build (make)

```
% source ../do-make.sou |& tee do-make.log
[1] 5962
```

 - you have to wait a while and monitor the `make.log` file, like:

```
% tail make.log
```

 or

``` 
% tail -f make.log
```

 - if all works well, you'll see:

```
make[1]: Leaving directory `/scratch/sao/hpc/tests/xspec/heasoft-6.31.1/BUILD_DIR'
Finished make all
```

### Install

  - If the build/make completed sucessfully, you can install it with:

```
% source ../do-install.sou |& tee do-install.log
[1] 8964
```

 - monitor the file `install.log`. This will take a little time, but not as
long as the `make` and you should see:

```
make[1]: Leaving directory `/scratch/sao/hpc/tests/xspec/heasoft-6.31.1/BUILD_DIR'
Finished make install
```

 - these `do-*.sou` files are in `/data/sao/hpc/ahw/sw+m/heasoft` on Hydra.

---

## What we can do

### Test the configuration step

 - Check the  configuration options

```
% cd ..
% mkdir heasoft
% cp -pi /data/sao/hpc/ahw/sw+m/heasoft/BUILD_DIR/configure ./
% ./configure --help
.... lots of stuff ....
```

 - a better way

```
% ./configure --help > config-help.txt
% more config-help.txt
`configure' configures this package to adapt to many kinds of systems.

Usage: ./configure [OPTION]... [VAR=VALUE]...

To assign environment variables (e.g., CC, CFLAGS...), specify them as
VAR=VALUE.  See below for descriptions of some of the useful variables.

Defaults for the options are specified in brackets.

Configuration:
  -h, --help              display this help and exit
      --help=short        display options specific to this package
      --help=recursive    display the short help of all the included packages
  -V, --version           display version information and exit
  -q, --quiet, --silent   do not print `checking ...' messages
      --cache-file=FILE   cache test results in FILE [disabled]
  -C, --config-cache      alias for `--cache-file=config.cache'
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources in DIR [configure dir or `..']

Installation directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [/usr/local]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [PREFIX]

By default, `make install' will install all the files in
`/usr/local/bin', `/usr/local/lib' etc.  You can specify
an installation prefix other than `/usr/local' using `--prefix',
for instance `--prefix=$HOME'.

For better control, use the options below.
...
```

  - _Still_ need to consult the instructions (optinal packages).

  - Some failures can be helpfull and suggest options to disable.

  - What the output of `source ../do-configure.sou` looks like:

```
% more /data/sao/hpc/ahws/sw+m/heasoft/do-configure.log
Currently Loaded Modulefiles:
 1) uge/8.6.18   2) tools/local-user   3) tools/local-admin   4) idl/8.8(default)   5) gcc/10.1.0   6) tools/python/3.8(default)  
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking target system type... x86_64-pc-linux-gnu
modified Linux system type is x86_64-pc-linux-gnu-libc2.17
Found component heacore
... a lot more ...
```

```
```
---

## Write a Module File

### An `rclone` Module File for your Private Version

- Where? under the `ex01/` directory

```
% cd /pool/<genomics|sao>/$USER/ahw/sw+m/ex01
% mkdir -p modulefiles/rclone
% cd modulefiles/rclone
```
- With your favorite editor (`nano`, `vi`, `emacs`, etc) create the file `1.62.2` with the following content:
```
#%Module1.0
#
# set some internal variables
set ver     1.62.2
set base    /pool/<genomics|sao>/<username>/ahw/sw+m/ex01
#
# what to show for 'module whatis'
module-whatis "System paths to run rclone $ver"
#
# configure the PATH and the MANPATH
prepend-path PATH    $base/bin
prepend-path MANPATH $base/man
#
```
- or (cheat)
```
% cp -pi /pool/sao/hpc/aw/ex01/modulefiles/rclone/1.62.2 ./
% emacs 1.62.2
$ nano 1.62.2
```
and fix `<genomics|sao>/<username>` to be what you need.

## How to use it?

### Load it using the full path

```
% module load /pool/<genomics|sao>/$USER/ahw/sw+m/ex01/modulefiles/rclone/1.62.2
% which rclone
/pool/<genomics|sao>/<username>/ahw/sw+m/ex01/bin/rclone
```

### Unload it and use the one we've installed

```
% module unload /pool/<genomics|sao>/$USER/ahw/sw+m/ex01/modulefiles/rclone/1.62.2
% module load tools/rclone
% which rclone
/share/apps/bioinformatics/rclone/1.53.1/rclone

% module unload tools/rclone
```

## Using Instead a Central Location

### Create the `~/modulefiles` hierarchy
```
% cd ~
% mkdir modulefiles
% mkdir modulefiles/rclone
% cp -pi /data/sao/hpc/ahw/sw+m/ex01/modulefiles/rclone/1.62.2 modulefiles/rclone/
% cd -
```

### Tell `module` to use it

```
% module use --append ~/modulefiles
% module load rclone/1.62.2
% module list
% which rclone
[guess]
% module unload rclone
% module list

% which rclone
[guess]

% module load tools/rclone
% module list
% which rclone
[guess]

% module unload tools/rclone
% module list
```

### To make it permanent

```
% cat <<EOF > ~/.modulerc
#%Module1.0
# adding my own module files
module use --append /home/$USER/modulefiles
EOF

% cat  ~/.modulerc
....

```
:question: the `<<EOF` construct

- the shell will substitute `$USER` by your username.

## Check this out

```
% module whatis rclone
% module whatis tools/rclone
```

:question: `cd jnk && pwd` vs `cd jnk ; pwd`

---

## Examples of Complex Module Files

### Plenty of Examples

```
% cd /share/apps/modulefiles

% more intel/2022.2
% more idl/8.8
% more bio/blast2go/1.5.1
% more bio/trinity/2.9.1
```

---

## Questions? 

## Survey

 - Please fill the workshop survey for
   feedback at [`https://forms.gle/hA1iHcKpYfrg5Q96A`](https://forms.gle/hA1iHcKpYfrg5Q96A)

---

