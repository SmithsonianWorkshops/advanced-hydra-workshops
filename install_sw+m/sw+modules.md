# Installing Software and Writing Modules 

## Introduction

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

- Downloading an executable is easier but is likely not to work.

### Downloading Executables

There are instances when available executables will run flawlessly on Hydra, but make sure that:

 1. you can trust the origin,
 1. you get a version compatible with Hydra, 
    * _i.e._, CentOS 7.x for Intel/AMD CPUs (`x86_64`)

### Remember 

 * Hydra configuration is specific: 
    * pre-built may code need _stuff_ (dependencies) not on Hydra.

---

## Notes on Downloading Executables

### Risks

- Since users on Hydra do not have elevated privileges (root access) you are very unlikely to damage the cluster, but malicious software can still damage your files.

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

> This will be illustrated in the hands on section.

---

## Building from Source

### Configure

- Most packages come with a configuration script, a list of prerequisites (dependencies) and instructions,

- Some packages allow you to build the code without some features in case you cannot satisfy some of the prerequisites,

- You most likely need to load the right module(s) to use the appropriate compiler.

### Build

- make sure you have loaded the right modules,

- run `make` to compile and link (aka build) the code.

### Install

- copy the executable(s) to the right place(s),
      
  - usually defined by the configuration,

- best practice is to separate build from install locations.

---

## Setting up Your Environment to Run Your Code

### Likely Needed

You likely will need to adjust your _environment_ to run some code:

  1. the location of the code: `path` or `PATH`,
  1. the location of the libraries:  `LD_LIBRARY_PATH`,
  1. you may also need to set some environment variables, etc.

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

&nbsp;

> You want the `Arch: x86_64` to be listed as "Installed" not _just_ "Available".

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
./configure --prefix=/home/username/big-package/3.5
```
  - and use
```
make install
```
---

## Final Notes

### Remember

  - there is a way to use `yum` as a non privileged user 
    - not recommended, unless you're an **expert**!
  - you can always ask about a missing prerequisite,
  - most of those can be build from source since Linux is an open source OS.
  
---

## Module and Module Files

### The Command `module`

- convenient mechanism to configure your _environment_,

- reads a file, the _module file_, that holds instructions,

 - a shell independent way to configure your environment:

   - _same_ module file whether `sh/bash` or `csh/tcsh`.
 
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
setenv HEASOFT /home/username/heasoft/6.3.1
```


## Example of More Elaborate and Complex Module Files

> Will be illustrated in the hands on section.

---

## Module Files Organization


### Recommended Approach

  - use a central location under you home directory `~/modulefiles`,

  - use a tree structure 
 
  - use version numbers if/when applicable,

  - let `module` know where to find the module files.

---

## Customization/Examples

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

---

## More to come ...
