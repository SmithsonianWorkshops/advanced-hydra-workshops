# Hands-on, Part I


## Create a location for the hands on portion


```
cd /pool/genomics/$USER
mkdir -p ahw/ja
cd ahw/ja
```


> for SAO ppl, use `/pool/sao` instead of `/pool/genomics`


---


## Trivial example


We'll create a job array that illustrates some of the concepts we've started talking about in the slides.


We're going to look at the variables `$JOB_ID` and `$SGE_TASK_ID` which contain the job and task IDs. We'll see in later examples how to differentiate what analysis each task in the job array should perform using the task ID.


### Make a subdirectory


``` 
mkdir ex01
cd ex01
```


### Trivial job


Let's look at a file `trivial.job` which was created with the [qsub generator tool](https://galaxy.si.edu/tools/QSubGen/):


```
# /bin/sh
# ----------------Parameters---------------------- #
#$ -S /bin/sh
#$ -q sThC.q
#$ -l mres=2G,h_data=2G,h_vmem=2G
#$ -cwd
#$ -j y
#$ -N trivial
#$ -o trivial.log
# ----------------Modules------------------------- #
#
# ----------------Your Commands------------------- #
#
echo + `date` job $JOB_NAME started in $QUEUE with jobID=$JOB_ID on $HOSTNAME
#
# $SGE_TASK_ID is the value of the task ID for the current task in the array
# write out the job and task ID to a file 
echo This is job $JOB_ID and task ID is $SGE_TASK_ID > trivial-$JOB_ID-$SGE_TASK_ID.out


# pause for 10 seconds
sleep 10
#
echo = `date` job $JOB_NAME done
```


You can copy that file with
```
cp /data/genomics/workshops/ahw/ja/ex01/trivial.job ./
```


This job echoes the values of the variables `$JOB_ID` and `$SGE_TASK_ID` to a file named with those variables, i.e., `trivial-$JOB_ID.$SGE_TASK_ID.out`


---


## First let's submit it as a 'regular' job (not as a job array):


```
$ qsub trivial.job
Your job 12496330 ("trivial") has been submitted
```


This creates an output file named with your job ID, i.e., `trivial-12496330-undefined.out`:


```
$ cat trivial-12496330-undefined.out
This is job 12496330 and task ID is undefined
```

| *NOTE* |     |
| ---    | --- |
|        | Your job will have a different job ID |
|        | $SGE_TASK_ID has the value "undefined" for non-array jobs |


---


## Now, let's submit it as a job array


* Adding `-t` followed by a range of task ids to `qsub` turns a job into a job array.


* Let's submit `trivial.job` as a job array with 10 tasks:


```
$ qsub -t 1-10 trivial.job
Your job-array 12496332-1-10:1 ("trivial") has been submitted
```


We now have an output file for each task:


```
$ ls trivial-12496332*
trivial-12496332-10.out  trivial-12496332-2.out  trivial-12496332-4.out  trivial-12496332-6.out  trivial-12496332-8.out
trivial-12496332-1.out   trivial-12496332-3.out  trivial-12496332-5.out  trivial-12496332-7.out  trivial-12496332-9.out
```


and the contents of one of these files:


```
$ cat trivial-12496332-1.out
This is job 12496332 and task ID is 1
```


Looking at our echo command from the job file, we see how `$SGE_TASK_ID` is used in both the content of the output file *and* the unique naming of that output file:


```
echo This is job $JOB_ID and task ID is $SGE_TASK_ID > trivial-$JOB_ID-$SGE_TASK_ID.out
```
---


## Create separate log files


Let's look at the `.log` file that our array job created. This is the file that contains the text that would have gone to the screen.


```
$ cat trivial.log
+ Tue Jun 13 10:58:18 EDT 2023 job trivial started in sThC.q with jobID=12496330 on compute-43-15
= Tue Jun 13 10:58:38 EDT 2023 job trivial done
+ Tue Jun 13 11:04:18 EDT 2023 job trivial started in sThC.q with jobID=12496332 on compute-43-15
= Tue Jun 13 11:04:38 EDT 2023 job trivial done
= Tue Jun 13 11:04:38 EDT 2023 job trivial done
= Tue Jun 13 11:04:38 EDT 2023 job trivial done
= Tue Jun 13 11:04:38 EDT 2023 job trivial done
= Tue Jun 13 11:04:38 EDT 2023 job trivial done
```


The first two lines are from the first submission where it was not submitted as an array and they contain what is expected, a `started` and `done` message.


After that things get messy. Our expectation is a separate `started` and `done` lines for each task, *but* we get one `started` line and five `done` lines (the number in your log file will vary).


What happened is that the 10 tasks started all at the same time, each attempting to append to the same log file at roughly the same time. The result is missing lines and overlapping output. In this example, the `.log` file isn't critical, but often you need to refer to the log to check on run problems etc.


The variable `$TASK_ID` can be used to create separate log files (`-o` option in `qusb`) for each task.


| *NOTE* |     |
| ---    | --- |
|        | `$TASK_ID` is used for log file names |
|        | `$SGE_TASK_ID` is used in your job script |

```
$ qsub -t 1-10 -o 'trivial-$JOB_ID-$TASK_ID.log' trivial.job
Your job-array 12496439.1-10:1 ("trivial") has been submitted
```


* Note that the argument to `-o` must be single-quoted to pass the "$" to the job scheduler


* Now we get separate `.log` files for each task:


```
$ ls trivial-12496439-*.log
trivial-12496439-10.log  trivial-12496439-2.log  trivial-12496439-4.log  trivial-12496439-6.log  trivial-12496439-8.log
trivial-12496439-1.log   trivial-12496439-3.log  trivial-12496439-5.log  trivial-12496439-7.log  trivial-12496439-9.log
```


* And each log file has the info for that task:


```
$ cat trivial-12496439-1.log
+ Tue Jun 13 11:21:30 EDT 2023 job trivial started in sThC.q with jobID=12496439 on compute-64-08
= Tue Jun 13 11:21:50 EDT 2023 job trivial done
```


## You can use embedded directives


* you can specify `-t 1-10 ` and `-o trivial-$JOB_ID-$TASK_ID.log` using embedded directives:


```
# /bin/sh
# 
#$ -S /bin/sh
#$ -q sThC.q
#$ -l mres=2G,h_data=2G,h_vmem=2G
#$ -cwd
#$ -j y
#$ -N trivial
#$ -t 1-10
#$ -o trivial-$JOB_ID-$TASK_ID.log
#
echo + `date` job $JOB_NAME started in $QUEUE with jobID=$JOB_ID on $HOSTNAME
#
# $SGE_TASK_ID is the value of the task ID for the current task in the array
# write out the job and task ID to a file 
echo This is job $JOB_ID and task ID is $SGE_TASK_ID > trivial-$JOB_ID-$SGE_TASK_ID.out
#
# pause for 10 seconds
sleep 10
#
echo = `date` job $JOB_NAME done
```
* so try it:
```
$ cd ..
$ mkdir ex01b
$ cd ex01b
$ cp /data/genomics/workshops/ahw/ja/ex01b/trivial.job ./
$ qsub trvial.job
Your job-array 12508283.1-10:1 ("trivial") has been submitted
$ qstat+ +a%
Total running (PEs/jobs) = 10/10, 0 queued (job) for user 'hpc'.
     jobID name                                                            stat     age nPEs      cpu% queue     node taskID
  12508283 trivial                                                            r   00:00    1           sThC.q   64-12      1
  12508283 trivial                                                            r   00:00    1           sThC.q   64-14      2
  12508283 trivial                                                            r   00:00    1           sThC.q   64-06      3
  12508283 trivial                                                            r   00:00    1           sThC.q   64-03      4
  12508283 trivial                                                            r   00:00    1           sThC.q   64-09      5
  12508283 trivial                                                            r   00:00    1           sThC.q   43-14      6
  12508283 trivial                                                            r   00:00    1           sThC.q   43-07      7
  12508283 trivial                                                            r   00:00    1           sThC.q   43-02      8
  12508283 trivial                                                            r   00:00    1           sThC.q   43-03      9
  12508283 trivial                                                            r   00:00    1           sThC.q   43-17     10
$ ls 
trivial-12508283-10.log  trivial-12508283-2.out  trivial-12508283-5.log  trivial-12508283-7.out  trivial.job
trivial-12508283-10.out  trivial-12508283-3.log  trivial-12508283-5.out  trivial-12508283-8.log
trivial-12508283-1.log   trivial-12508283-3.out  trivial-12508283-6.log  trivial-12508283-8.out
trivial-12508283-1.out   trivial-12508283-4.log  trivial-12508283-6.out  trivial-12508283-9.log
trivial-12508283-2.log   trivial-12508283-4.out  trivial-12508283-7.log  trivial-12508283-9.out


$ head -999 *.log
...


$head -999 *.out
...
```

----

# Back to the the presentation, Part II


---


# Hands-on, Part II

## Using tasks with analyses


In the first hands-on section we submitted an array job using the `-t` option using `qsub` and explored the use of the variables `$SGE_TASK_ID` and `$TASK_ID`. Now we're going to see a couple of ways to execute analyses that utilize the job array framework.


When you submit a job array, the *identical job script* is run multiple times. How do you run a different analysis with each task? 


 use the task ID.


Blast is an example of an analysis that can greatly benefit from the use of job arrays, since often we need to “blast” many sequences against the same database, and the results of each “blast” do not depend on each other.


## BLAST: input files have task ID


The directory `/data/genomics/workshops/ahw/ja/ex02/` has a BLAST example we'll use with job arrays. Copy it into your `/pool/genomics/$USER/ahw/ja/` directory with:

```
cp -r /data/genomics/workshops/ahw/ja/ex02 /pool/genomics/$USER/ahw/ja/
```


1. `blast.job`: a  regular job script that executes `blastn` to query a custom BLAST database located in the `blastdb/` directory. We're going to edit this file to be an array job.
1. `split_fasta.pl`: this script executes a perl command from LINK to split a fasta file into smaller files.
1. `blastdb/`: this contains a custom blast database of the genome of `Agaricus ...` (NCBI LINK) made with the `makeblastdb` command. We are using a small reference DB for this workshop to decrease runtime and memory needs compared to a query against the full `nt` NCBI database.
1. `cyphomyrmex-muelleri-1464.fasta`: this is the fasta file we're querying.



### Split the fasta


We'll use `split_fasta.pl` to create reduced sized input files we can run as an array:


```
$ ./split_fasta.pl  --length 50 cyphomyrmex-muelleri-1464.fasta

Splitting cyphomyrmex-muelleri-1464.fasta into files with 50 sequences per file


Split 931 FASTA records in 17395 lines, with total sequence length 959426
Created 19 files

$ ls *.fasta
10.fasta  14.fasta  18.fasta  3.fasta  7.fasta
11.fasta  15.fasta  19.fasta  4.fasta  8.fasta
12.fasta  16.fasta  1.fasta   5.fasta  9.fasta
13.fasta  17.fasta  2.fasta   6.fasta  cyphomyrmex-muelleri-1464.fasta
```


We can now  submit a job array with 19 tasks, each task will use the task ID in the fasta **filename**


Copy blast.job to blast-ja.job and edit  blast-ja.job using your favorite editor (`nano`, `vi`, `emacs`, etc):

```
$ cp blast.job blast-ja.job
```


Change the log file option from:
```
#$ -o blast.log
```


to


```
#$ -o blast_$TASK_ID.log
```


Change the blast command to include `$SGE_TASK_ID` 


From:
```
blastn -db blastdb/aculeata \
   -max_target_seqs 20 \
   -num_threads $NSLOTS \
   -query cyphomyrmex-muelleri-1464.fasta \
   -out cyphomyrmex-muelleri-1464.tsv \
   -outfmt 6
```


To:
```
blastn -db blastdb/aculeata \
  -max_target_seqs 20 \
  -num_threads $NSLOTS \
  -query $SGE_TASK_ID.fasta \
  -out $SGE_TASK_ID.tsv \
  -outfmt 6
```


And submit as a job array:


```
qsub -t 1-19 blast-ja.job
```


| *NOTE* |     |
| ---    | --- |
|        | job array options can also be included as embedded qsub directives in the job file with: |
|        |  `#$ -t 1-19`|


## UCE alignments: filename from file


Often your input files don't have a sequential numbering scheme that you can directly use with the task ID.


One method to get the input filename from the task ID is by using a  file with the list of these input filenames. The line of the file corresponding to task ID will be fetched to get the input filename. This method can also be used to get other parameters that  can be used as parameters for a command.

The next example in `/data/genomics/workshops/ahw/ja/ex03` is aligning DNA sequences with `mafft`.

Copy the `ex03` directory into `/pool/genomics/$USER/ahw/ja/`

```
cp -r /data/genomics/workshops/ahw/ja/ex03 /pool/genomics/$USER/ahw/ja/
```

1. `fastas/`: a directory of input fasta files that need to be aligned. Each file has sequences from a different UCE locus and needs to be aligned separately.
2. `mafft.job`: a job file to align one of the fasta files that we'll modify to work as a job array.
3. `uce-list`: a text file listing every uce locus in the `fastas`. It was created with `cd fastas; ls * | sed 's/-unaligned.fasta//' >../uce-list`


Let's look at the `uce-list` file and get a line count:


```
$ head uce-list
uce-200
uce-201
uce-204
uce-205
uce-206
uce-207
uce-208
uce-20
uce-211
uce-212

$ wc -l uce-list
95 uce-list
```

`uce-list` has the names of the loci, there are 95 lines, one for each file in `fasata`.

### Edit the job file

Make a copy of `mafft.job` to `mafft-ja.job`

```
$ cp mafft.job mafft-ja.job
```

Open `mafft-ja.job` in your favorite text editor (e.g. `nano`, `vi`, or `emacs`).


This time we're going to add the `-t` option to the job file as an embedded directive. We're also going to use the `-tc` option which will limit the number of tasks running concurrently. 


You want to use `-tc` when each task might stress the cluster and effectively reduce the efficiency of your job array. In most cases heavy I/O is the primary reason to limit the number of concurrent tasks. 


Also, before submitting a job array with a lots of task, test things on just a few tasks


In our exercise we'll run the 95 loci, but specify that no more than 20 can run at one time, so add
`#$ -t 1-95 -tc 20` to the `Parameters` section at the top with the other embedded qsub directives (exact position in this section doesn't matter).

```
#$ -t 1-95 -tc 20
```

* Question? How would you run only the first half of loci? The second half? A specific locus?


Change the output file to:

```
#$ -o log_files/mafft-$TASK_ID.log
```


Next, we need to add a command to get the UCE identifier from the `uce-list`. 


The utility `sed` has a command to print a specific line from a file. For example to print the 10th line of `uce-list` you would use: `sed -n "10p" uce-list`. We'll use the `${SGE_TASK_ID}` to put the current task number into the sed command. The returned text will be assigned to a new variable, `$UCE`


Add:

```
UCE=$(sed -n "${SGE_TASK_ID}p" uce-list)
```

Finally, we need to change the `mafft` command to use the new `$UCE` variable.


Change this line:

```
mafft --quiet \
  --thread $NSLOTS \
  --auto $INPUTDIR/uce-200-unaligned.fasta >$OUTPUTDIR/uce-200-aligned.fasta
```


To:
```
mafft --quiet \
  --thread $NSLOTS \
  --auto $INPUTDIR/$UCE-unaligned.fasta >$OUTPUTDIR/$UCE-aligned.fasta
```


*Optional* add a test to check that the input file exists. 


This is a good idea not only to catch where there is a missing input file, but also in case the `uce-list` file is missing or there are more tasks submitted than there are lines in `uce-list`. 


Add:
```
if [ ! -f $INPUTDIR/$UCE.fasta ]; then
  echo "ERROR: input file is missing: $INPUTDIR/$UCE.fasta"
  exit 1
fi
```


The job file should look like this:

```
# /bin/sh
# ----------------Parameters---------------------- #
#$ -S /bin/sh
#$ -q sThC.q
#$ -pe mthread 2
#$ -l mres=16G,h_data=8G,h_vmem=8G
#$ -cwd
#$ -j y
#$ -N mafft
#$ -o log_files/mafft-$TASK_ID.log
#$ -t 1-95 -tc 20
#
#
# ----------------Modules------------------------- #
module load bio/mafft
#
# ----------------Your Commands------------------- #
#
echo + `date` job $JOB_NAME started in $QUEUE with jobID=$JOB_ID on $HOSTNAME
echo + NSLOTS = $NSLOTS

#

OUTPUTDIR=aligned
INPUTDIR=fastas
mkdir -p $OUTPUTDIR

UCE=$(sed -n "${SGE_TASK_ID}p" uce-list)

if [ ! -f $INPUTDIR/$UCE-unaligned.fasta ]; then
  echo "ERROR: input file is missing: $INPUTDIR/$UCE-unaligned.fasta"
  exit 1
fi

mafft --quiet \
  --thread $NSLOTS \
  --auto $INPUTDIR/$UCE-unaligned.fasta >$OUTPUTDIR/$UCE-aligned.fasta

#
echo = `date` job $JOB_NAME done
```


Now, let's submit the job:
```
$ qsub mafft-ja.job
Your job-array 12603930.1-95:1 ("mafft") has been submitted
```

---


## Job status, accounting, etc


### Job status


* You can check the status of that job array with `qstat` or `qstat+`


```
$ qstat
```
will list in the last column the task id for the running tasks, and the range of tasks pending for the queued job, if any.


```
qstat+ +a%


```
gives you a more compact output. It also lists the job efficiency, a convenient way to see if you are not running too many concurrent tasks.


### No. of concurrent tasks


* Changing the number of concurrent tasks


You can change the number of concurrent task of an already submitted job array with `qalter`:


```
$qalter -tc 25 123456789
```
this will increase it from 20 to 25 (you need to use the right job id)


* You can decrease it too, but this does not affect the running tasks, only the number of tasks that will be started subsequently






### Accounting


* the commands `qacct` and `qacct+` will return accounting information for all the completed tasks, which can be (very) long
* they take a `-t` option to limit the output to a task or a range of tasks
* also `qstat+` allows you to pick a subset of the accounting info and get a tabular output:


```
$ qacct+ -j 12508150 -show %wallclock,hostname,start_time=@DATE
wallclock       hostname        start_time
--------------- --------------- ---------------
30.296          compute-43-03   Fri Jun 16 12:21:02.00 EDT 2023
30.249          compute-43-02   Fri Jun 16 12:21:02.00 EDT 2023
30.299          compute-43-17   Fri Jun 16 12:21:02.00 EDT 2023
30.315          compute-43-15   Fri Jun 16 12:21:02.00 EDT 2023
30.304          compute-64-12   Fri Jun 16 12:21:02.00 EDT 2023
30.342          compute-43-06   Fri Jun 16 12:21:02.00 EDT 2023
30.296          compute-43-07   Fri Jun 16 12:21:02.00 EDT 2023
30.288          compute-43-14   Fri Jun 16 12:21:02.00 EDT 2023
30.144          compute-65-24   Fri Jun 16 12:21:02.00 EDT 2023
30.183          compute-65-26   Fri Jun 16 12:21:02.00 EDT 2023
```
(try `man qacct+` or `qacct+ -help` and `qacct+ -show help`)
