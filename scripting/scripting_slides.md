# Using Shells and Scripting (slides)

In the intro portion of the workshop you will learn:

* What is scripting and its applications?
* What are shells?
* Which one(s) to use?
* How to write scripts.
* How to use tools in scripts.

---

## What is scripting?

**Scripting vs. Programming**

Scripting languages are translated and cannot be converted into an executable file. 

Programming languages are generally compiled and created to executable the file. 

Scripting languages can combine existing modules or components, while programming languages are used to build applications from scratch

---

## What are shells?

A shell is a program where users can type commands. See additional lessons [here](https://datacarpentry.org/shell-genomics/01-introduction/index.html). 

**Bash**

Bash is a command line language and unix shell, stands for "Bourne again shell."

**C shell**

C shell is a command line language and shell that used C programing language like syntax. 



---

## What some types of scripting tools?

**Loops**

Loops allow us to repeat a command or set of commands for each item in a list.

**Logical Operators**

Logical operators in Bash are used to test conditions and create complex expressions by combining two or more conditions. These operators allow you to evaluate the truthiness of a condition or multiple conditions, providing a way to control the flow of execution in your scripts (e.g. if ; then).

**Variables**
 
A variable is a character string to which we assign a value. The value assigned could be a number, text, filename, device, or any other type of data.

**Arguments**

Arguments are a wasy to supply parameters to bash scripts. Arguments are useful when a script has to perform different functions depending on the values of the input.

## What are some examples of tools we use?

**Tools**

  `sed` - the steam editor for filtering and transforming text
  
  `awk` - pattern scanning and processing language
  
  `tr` - translate or delete characters
  
  `cut` - remove sections from each line of files
  
  `bc` - An arbitrary precision calculator language
  
  `date` +<format> –date="specification"
  
  
**Languages**

  `PERL` - practical extraction and report language 
  
  `Python` - high level general purpose programming language


# `scripting` hands-on

In the hands-on portion of the workshop you will learn how to:

- Run a set of commands: Scripts
- Simplify and avoid errors
- Test assumptions
- Generalize a script to be used for multiple files or executions: Arguments 
- Ease hands-on time by repeating a command for every file: for loops
- Re-use arguments by manipulating the text
- Get parameters from another file 

## Log in to Hydra

If you need a reminder about how to log into Hydra and how to change your password, check out our Intro to Hydra tutorial: `https://github.com/SmithsonianWorkshops/Hydra-introduction/blob/master/hydra_intro.md`


