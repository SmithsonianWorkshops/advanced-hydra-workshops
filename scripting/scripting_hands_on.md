# Advanced Hydra, Scripting- Hands on
## Setup
### Log on to Hydra
Let us know if you have any problems logging in to Hydra.

### `nano` refresher
- We’ll be using nano. If you prefer `vi` or `emacs`, please feel free to use that.🙂
- Quick nano review: `ctrl+x` to save and exit.
- Using a text editor on Hydra is more convenient than editing on your workstation and transferring revisions.

Let's set a couple `nano` options that will help us today. We'll add a setting that will highlight syntax for bash scripts and another that will let us use the mouse to click the nano screen to move the cursor.

```
$ nano ~/.nanorc
```

Then enter these lines and save the file with `ctrl+x`

```
include /usr/share/nano/sh.nanorc
set mouse
```

### Working directory
We'll be working in `/scratch/{genomics|sao|...}/USER/`

```
$ cd /scratch/genomics/USER/
```

### Starting data
The sample files we'll be working with are in `/data/genomics/workshops/ahw_scripting`

Make a copy of this directory into your directory

```
$ cp -a /data/genomics/workshops/ahw_scripting .
```

> Why `cp -a` instead of `cp -r`? The `-a` arguments copies directories and preserves modification times, symbolic links, and other settings.

Let's see what it's in this directory with the `tree` command.

```
$ tree ahw_scripting
ahw_scripting/
├── blastdb
│   ├── difficile_genomes.fna
│   ├── difficile.ndb
│   ├── difficile.nhr
│   ├── difficile.nin
│   ├── difficile.not
│   ├── difficile.nsq
│   ├── difficile.ntf
│   └── difficile.nto
└── fastas
    ├── atpA_all.fasta
    ├── dapD_all.fasta
    └── rplB_all.fasta
```

Now let's change directory into the `ahw_scripting` directory:

```
$ cd ahw_scripting
```

Quick look at a fasta file:
```
$ head -n 2 fastas/atpA_all.fasta
>NZ_CM000441.1_cds_WP_003421367.1_3400_gene=atpA
ATGAACTTAAAACCTGAAGAAATAAGTTCTATAATTAAACAGCAAATAAAAAATTATGAGAATAAAGTTGAGTTGACAGATACAGGTAGTGTTTTAACAGTTGGGGATGGTATAGCGAGTGTATATGGATTAGAAAAAGCTATGTCTGGTGAGTTGCTAGAGTTCCCAGGTGAAATATATGGTATGGCAC…
```

Fasta format: Sequence identifier line that starts with ">" followed by any combination of text (including spaces)
The sequence in one or more lines.

## Scripting concepts 
### 0. Use a script to run a set of commands sequentially (`hello_world.sh`)

```
$ nano hello_world.sh
```

> Best practice: use `.sh` extension for bash scripts

```
# My first script
echo "Hello world! The date is:"
date
ls -l fastas
```

```
$ sh hello_world.sh
Hello world! The date is:
Tue May  9 09:15:10 EDT 2023
total 500
-rw-rw-r-- 1 user user 240680 May  6 22:05 atpA_all.fasta
-rw-rw-r-- 1 user user 118081 May  6 22:06 dapD_all.fasta
-rw-rw-r-- 1 user user 137176 May  6 22:06 rplB_all.fasta
```

> Question: What working directory is the script using when it starts? What happens if you run the script from a different directory?

### 1. Interacting with files/directories (`1.sh`)

We'll be iteratively developing a script that works with the fasta files that we saw earlier. We will be adding to the script to learn new concepts. At the core of what we'll be doing is working with files and directories. As you saw in the `hello_world.sh` script, when you start a script it uses your current working directory when it starts. We'll be referring to the files in the `fasta/` directory in this example.

```
$ nano 1.sh
```

```
#!/bin/sh

# 1. count the number of sequences in a fasta file

echo "The number of sequences in fasta/dapD_all.fasta"
grep -c ">" fastas/dapD_all.fasta
```

Useful tool: grep: returns lines that contain certain text (`">"`) in one or more files (`fasta/dapD_all.fasta`). It returns the found lines or, with the option `-c` (short for `--count`) a count of the lines that match the query.

The first line, `#!/bin/sh`, has a special meaning and formatting. The symbols `#!` in combination is called a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) and to function properly it must be the first line of the script **without any space after the `#!` and the `/`.** 

The `/bin/sh` following the shebang (`#!`) is the path to the `sh` executable.

We're now going to mark the program as executable which is a special file attribute on Unix systems that tells the system the file (be it a text script or a compiled program) can be read by the shell and executed.

The command `chmod +x file` marks a file as executable. 

The combination of making your script executable and using the shebang line allow you to call the script from the command line without `sh FILE`. One thing about calling the script is that you need to specify the path (relative or absolute) to the script. By using `./1.sh`, we are telling the shell to look in the current direction `./` for the file named 1.sh and execute it.

```
$ chmod +x 1.sh
$ ./1.sh
The number of sequences in fastas/dapD_all.fasta
154
```

### 2. Simplify and avoid errors when using the same value repeatedly: Variables (`2.sh`)
Let's make a copy and add on to the script from above: 
```
$ cp 1.sh 2.sh
$ ls -l
$ nano 2.sh
```

The executable mode is copied too 🙂

We're taking the script form above and making a variable name `FILE` that contains the string `fastas/dapD_all.fasta`. 

We set the variable with `FILE=fastas/dapD_all.fasta` 

⚠️NO SPACES on either side of the `=`

⚠️Variable names are case sensitive `FILE` is different than `file`


To get the value of the variable, we use `$FILE` or `${FILE}`.

Both versions work, but it's best practice to use `${FILE}` notation.

One reason for the `${}` notation is because it clearly defines where the variable name ends.

> What if the variable include white space? 
> Use quotes around it: like in  `MULTIWORD="two words"` 

```
#!/bin/sh

# 1. count the number of sequences in a fasta file
# 2. Add a variable

# The file to be examined
FILE=fastas/dapD_all.fasta

echo "The number of sequences in ${FILE}"
grep -c ">" ${FILE}
```

```
$ ./2.sh
The number of sequences in fastas/dapD_all.fasta
154
```

### 3. Generalize a script to be used for multiple files or executions: Arguments (`3.sh`)

In our previous script we add the name of the file to examine as part of the script file. One of our goals in scripting is to make reusable code. 

We wouldn't want to edit the script and change the `FILE` variable each time we use it which would be a time consuming, error prone, manual task. 

Most programs take arguments that change the way the program runs. Some are optional, like the `-l` in `ls -l`, and others are required, like the file names you are going to copy from/to with the `cp` command.

We're going to add an argument to our script, it's the name of the file that we're going to count the sequences of.

Make a copy of 2.sh and open it in nano

```
$ cp 2.sh 3.sh
$ nano 3.sh
```

```
#!/bin/sh

# 1. count the number of sequences in a fasta file
# 2. Add a variable
# 3. Add argument for file name

# The file to be examined is given as an argument
FILE=${1}

echo "The number of sequences in ${FILE}"
grep -c ">" ${FILE}

```

`${1}` is a special variable that contains the first argument provided to the script.

Try it:

```
$ ./3.sh fastas/atpA_all.fasta
The number of sequences in fastas/atpA_all.fasta
155
```

> Anyone run it without any arguments? If not try it:

```
$ ./3.sh
The number of sequences in
```

Uh-oh, it's hung. What's happening? (⚠️Use control-c to get back to the prompt)

> Challenge:

> Give more than one file as arguments, what happens and why?

> What if you give a file that doesn't exist?

> What if you give the directory `fastas` instead of a file?

### 4. Test assumptions and flow control: if statements (`4.sh`)

We can add some simple tests to our script to catch some of the common errors. It can be difficult to account for all possible errors, but checking for common ones (required argument not given, needed file doesn't exist) is worth your effort.

Examples of types of tests you could use include checking whether: 
- A file or directory exists.
- A variable contains certain text.
- A previous command was successful.

There are many ways to add tests, we'll be starting with the `if` statement.

Bash `if` statements:

```
if [ condition ]; then
   commands_if_true
else
   commands_if_false
fi
```

⚠️ at least one space on either side of `[` and `]`

> Best practice: add indentation (often two spaces) to make the structure clear, although it is not required.

What do conditions/logical expressions look like in Bash? Let's look at examples by modifying our program.

```
$ cp 3.sh 4.sh
$ nano 4.sh
```

```
#!/bin/sh

# 1. count the number of sequences in a fasta file
# 2. Add a variable
# 3. Add argument for file name
# 4. Add sanity checks

if [ -z ${1} ]; then
  echo "ERROR: Give the file name as an argument"
  exit 1
fi

FILE=${1}
if [ ! -f ${FILE} ]; then
  echo "ERROR: The file you entered was not found: ${FILE}"
  exit 1
fi

echo "The number of sequences in ${FILE}"
grep -c ">" ${FILE}
```

```
$ ./4.sh fastas/atpA_all.fasta
The number of sequences in fastas/atpA_all.fasta
155
```

conditionals | meaning | example
---|---|---
`-z` | Text string is zero length | `if [ -z ${1} ]; then`…
`-n`  | Test string is non-zero length | ` if [ -n ${1}]; then`…
`-d` | The directory given exists | `if [ -d /fastas ]; then`…
`-f` | The file exists | `if [ -f /fastas/rplB_all.fasta ]; then`…
`!`  | negates the condition | `if [ ! -f /fasta/rplB_all.fasta ]; then`…
`-eq -ne -lt -le -gt -ge` | =, ≠, <, ≤, >, ≥ | `if [ ${COUNT} -gt 0 ]; then`…

https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html

### 5. Ease hands-on time by repeating a command for every file: for loops (`5.sh`)

For loop format:
```
for VAR in string1 string2; do
  command
done
```

```
$ cp 4.sh 5.sh
$ nano 5.sh
```

⚠️ We're switching to checking directories instead of files in this version

```
#!/bin/sh

# 1. count the number of sequences in a fasta file
# 2. Add a variable
# 3. Add argument for file name
# 4. Add sanity checks
# 5. Change to calculating number of sequences for every file in a directory

# The directory to examine is given as an argument
if [ -z ${1} ]; then
  echo "ERROR: Give the directory name as an argument"
  exit 1
fi

DIR=${1}
if [ ! -d ${DIR} ]; then
  echo "ERROR: The directory you entered was not found: ${DIR}"
  exit 1
fi

echo "The number of sequences in each file in ${DIR}"
for FILE in ${DIR}/*.fasta; do
  echo ${FILE}
  grep -c ">" ${FILE}
done
```

```
$ ./5.sh fastas
The number of sequences in each file in fastas
fastas/atpA_all.fasta
155
fastas/dapD_all.fasta
154
fastas/rplB_all.fasta
156
```

(If you want to include multiple extensions use more advanced Bash globbing e.g. `*.{fasta,fa}` for files that end in .fasta or .fa)

### 6. Getting portions of path and file name (basename, dirname, sed) (`6.sh`)

Notice how the file name is actually the directory and filename above? We can get the filename portion of a path and remove extensions.

```
$ cp 5.sh 6.sh
$ nano 6.sh
```

```
#!/bin/sh

# 1. count the number of sequences in a fasta file
# 2. Add a variable
# 3. Add argument for file name
# 4. Add sanity checks
# 5. Change to calculating number of sequences for every file in a directory
# 6. Get portions of the filename to improve output

# The directory to examine is given as an argument
if [ -z ${1} ]; then
  echo "ERROR: Give the directory name as an argument"
  exit 1
fi

DIR=${1}
if [ ! -d ${DIR} ]; then
  echo "ERROR: The directory you entered was not found: ${DIR}"
  exit 1
fi

echo "The number of sequences in each file in ${DIR}"
for FILE in ${DIR}/*.fasta; do
  FILENAME=$(basename ${FILE})
  GENENAME=$(echo ${FILENAME} | sed 's/.fasta//')
  echo "${FILENAME} (gene: ${GENENAME}):"
  grep -c ">" ${FILE}
done
```

Why `$(basename ${FILE})`? The `$()` executes the command and then returns the text output from that command. We use this to assign the variable `FILENAME` to what basename ${FILE} outputs.

```
$ ./6.sh fastas
The number of sequences in each file in fastas
atpA_all.fasta (gene: atpA_all):
155
dapD_all.fasta (gene: dapD_all):
154
rplB_all.fasta (gene: rplB_all):
156
```

## Using scripting in a job file: for loop within the job (blast_all.job)

Let's do a blastn search of these genes to a custom database…

Blast command format…
blastn -db DBPATH/DBNAME -query GENE.fasta -outfmt 10 -max_target_seqs 25 -out GENE.csv

```
# /bin/sh
# ----------------Parameters---------------------- #
#$ -S /bin/sh
#$ -q sThC.q
#$ -l mres=8G,h_data=8G,h_vmem=8G
#$ -cwd
#$ -j y
#$ -N blast_all
#$ -o blast_all.log
#
# ----------------Modules------------------------- #
module load bioinformatics/blast
#
# ----------------Your Commands------------------- #
#
echo + `date` job $JOB_NAME started in $QUEUE with jobID=$JOB_ID on $HOSTNAME
#

# Directory with the fasta files
DIR=fastas
if [ ! -d ${DIR} ]; then
  echo "ERROR: The directory you entered was not found: ${DIR}"
  exit 1
fi

# Blast DB (path/DB_name)
DB=blastdb/difficile

# Output directory for blast results
OUTDIR=blast_results
if [ ! -d ${OUTDIR} ]; then
  mkdir ${OUTDIR}
fi

echo "BLAST of fasta files in ${DIR} against ${DB}"
for FILE in ${DIR}/*.fasta; do
  FILENAME=$(basename ${FILE})
  GENENAME=$(echo ${FILENAME} | sed 's/.fasta//')
  echo "${FILENAME}, gene: ${GENENAME}, output: ${OUTDIR}/${GENENAME}.csv"
  blastn -db ${DB} -query ${FILE} -outfmt 10 -max_target_seqs 25 -out ${OUTDIR}/${GENENAME}.csv
done

#
echo = `date` job $JOB_NAME done

```

## Using scripting in a job file: for loop to submit a job repeatedly (blast_one.job)

Preview: In the job array lesson we'll show an alternative way to submit multiple computations to run in parallel. The job array method adds flexibility in controlling the execution.

⚠️ This method can be used to submit MANY jobs very quickly

Considerations:
- Turn off email alerts! (`-m` and `-M` options in `qsub`)
- Test with a small set of jobs
- Many very short jobs (<1 minute) adds admin load to the server

```
# /bin/sh
# ----------------Parameters---------------------- #
#$ -S /bin/sh
#$ -q sThC.q
#$ -l mres=8G,h_data=8G,h_vmem=8G
#$ -cwd
#$ -j y
#$ -N blast_one
#$ -o blast_one.log
#
# ----------------Modules------------------------- #
module load bioinformatics/blast
#
# ----------------Your Commands------------------- #
#
echo + `date` job $JOB_NAME started in $QUEUE with jobID=$JOB_ID on $HOSTNAME
#

if [ -z ${1} ]; then
  echo "ERROR: Give the file name as an argument"
  exit 1
fi

# File to blast is the first argument
FILE=${1}
if [ ! -f ${FILE} ]; then
  echo "ERROR: The file you entered was not found: ${1}"
  exit 1
fi

# Blast DB (path/DB_name)
DB=blastdb/difficile

# Output directory for blast results
OUTDIR=blast_results
if [ ! -d ${OUTDIR} ]; then
  mkdir ${OUTDIR}
fi

echo "BLAST of fasta file ${FILE} against ${DB}"
FILENAME=$(basename ${FILE})
GENENAME=$(echo ${FILENAME} | sed 's/.fasta//')
echo "${FILENAME}, gene: ${GENENAME}, output: ${OUTDIR}/${GENENAME}.csv"
blastn -db ${DB} -query ${FILE} -outfmt 10 -max_target_seqs 25 -out ${OUTDIR}/${GENENAME}.csv

#
echo = `date` job $JOB_NAME done
```

Submitting:



```
$ for FASTA in fastas/*fasta; do qsub blast_one.job $FASTA; done
```

This works, but the log file is a mess!

Give the log file name `-o` in the `for` loop.

```
$ for FASTA in fastas/*fasta; do qsub -o ${FASTA}.log blast_one.job ${FASTA}; done
```

> Where did the log files go? What are they called?

We can use some of the scripting tricks we learned to improve the name and location of the log file.

```
$ for FASTA in fastas/*fasta; do
  FILENAME=$(basename $FASTA)
  GENENAME=$(echo ${FILENAME} | sed 's/.fasta//');
  qsub -o ${GENENAME}.log blast_one.job $FASTA
done
```
