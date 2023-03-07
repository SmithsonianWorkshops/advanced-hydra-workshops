[//]: # use https://markdownlivepreview.com/ to preview

# Installing software and writing modules Intro (slides)

In the intro portion of the workshop you will learn:

* How to download code
* How to compile code
  - simple example(s)
* How to install a package
 - configure
 - build
 - install
* How to writing modules
 - simple examples
 - `.version` file
 - complex examples: `tcl` (_tickle_)
* What are `yum`, `rpm`, `get-apt`, etc
 - how to use `yum` and `rpm`
 - what about `sudo`?

---

## Downloading Code

In most cases you are better off downloading the source and building the code
(hereafter executable) yourself

### Executables
There are instances when available executables will run flawlessly on Hydra,
but

 1. make sure you trust the origin of the code
 1. make sure you get a version compatible with Hydra, _i.e._, that will run
  on CentOS 7.x for Intel/AMD CPUs
 1. Hydra configuration is specific, hence pre-built code may need other
  stuff (dependencies) that are not installed on Hydra

### Notes 

Since user do not have elevated privileges (root access) you are very unlikely
to damage the cluster, but malicious software can still damage your files.

In rare cases it may try to install a _trojan horse_ that would try to exploit
a know vulnerability. So be vigilent and responsible.

In case of doubt, never hesitate to contact us.

---

## Building from Source Code

If you download source code you will need to build the code. This is
usually done in 3 steps

1. **Configure**
 - Most packages come with a configuration script, a list of pre-requisites
   (aka dependencies) and instructions.
 - Some packages allow to build the code without some features in case you
   cannot satisfy some of the pre-requisites.
 - You most likely need to load the right module to use the
   appropriate compiler
1. **Build**
 - need to make sure you have loaded the right modules to use the
   right compiler
 - run `make` to compile and link (aka build) the code
1. **Install**
 - copy the executable to the right place (usually defined by the
   configuration)
 - best practice is to separate build from install locations
               
This will be illustrated in the hands on section.
---

## Module and module files

### The `module` command and module files

- The command `module` is a convenient mechanism to configure your Unix/Linux
  environment.

- The command `module` reads a file, aka the "module file", that holds a set
  of simple or complex instructions.

 - This is a shell syntax independent way to configure your environment:
 - you use the _same_ module file whether you use the `[ba]sh` or `[t]csh` shell.
 - We provide a slew of module files, but users can augment this by writing their own.
 - You are welcome to look at all the module files we wrote, most of them are
   under `/share/apps/modulefiles/`.

---

### Module file syntax and concepts

- Module files can be complex, written following the `tcl` scripting language,
  _although_ you **do not** need to know that language to write simple module
  files.  
- The `tcl` syntax is augmented by commands specific to help configure your
  environment.
- For example a simple module file can just hold a list of modules that must
  be loaded to to run a given tool.
- You can write complex module files and leverage the `tcl` syntax.

---

## Example of `module` commands

- Informational
```
module avail
module whatis
module whatis <name>
```

- Configure your environment
```
module load   <name>
module unload <name>
module swap   <name>
```

- Specific info
```
module list
module help <name>
module show <name>
```

- More help
```
man module
```

---
## Example of a simple module file

```
#%Module1.0
#
# load two modules and set the HEASOFT env variable
module load gcc/10.1.10
module load python/3.8
setenv HEASOFT /home/sylvain/heasoft/6.3.1
```

---

## Example of a more elaborate module file: `tools/rclone`


```
#%Module1.0
#
# set some internal variables
set ver     1.53.1
set base    /share/apps/bioinformatics
#
# easy way to set up help
proc ModulesHelp { } {
    global helpmsg
    puts stderr "\t$helpmsg\n"
}
#
# what to show for module whatis
module-whatis "System paths to run rclone $ver"
#
# configure the PATH and the MANPATH
prepend-path PATH $base/rclone/$ver
prepend-path MANPATH $base/rclone/$ver/man
#
# define the text shown with module help
set helpmsg "
Purpose
-------
This module file defines the system paths for rclone $ver

Documentation
-------------
https://rclone.org/
```

---

## Examples of a complex module files

```
cd /share/apps/modulefiles
more intel/2022.2
more idl/8.8
more bio/blast2go/1.5.1
more bio/trinity/2.9.1
```

---
## Organization and Customization

- You can keep your module files in a central location (recommmended), using a
  tree stucture, or if you prefer where you need them.

- You can load a module file using the module file full path, or tell `module`
  where to look for your central location (recommended).

- The recommended approach:
  - use a central location under you home directory `~/modulefiles`
  - use a tree structure and use version numbers if/when applicable
```
~/modulefiles/crunch/
~/modulefiles/crunch/1.0
~/modulefiles/crunch/1.2
~/modulefiles/crunch/2.1
~/modulefiles/viewit
```

  - tell `module` where to find your module file with
```
module use --append /home/sylvain/modulefiles
```
  - that instruction can be either
  1. in your initialization file `~/.bashrc` or `~/.cshrc`
  1. better yet in a `~/.modulerc` file (shell independant), but you need it
  to look like this:
```
#%Module1.0#
# adding my private module files
module use --append /home/sylvain/modulefiles
```

---

## The yum, rpm, get-apt and sudo soup

---

# Hands-on Section

In the hands-on portion of the workshop you will 

- How to find software to install
- How to install software using best-practices
- How to run the software you installed in submitted jobs on Hydra

## Log in to Hydra

If you need a reminder about how to log into Hydra and how to change your
password, check out our Intro to Hydra tutorial:
https://github.com/SmithsonianWorkshops/Hydra-introduction/blob/master/hydra_intro.md

---
