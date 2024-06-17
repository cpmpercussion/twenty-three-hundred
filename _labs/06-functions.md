---
title: "Week 6: functions"
summary: "Write functions with parameters, return values, and keep track of where you are going so you can find the way back!"
template_repo: https://gitlab.cecs.anu.edu.au/comp2300/2022/comp2300-2022-lab-pack-2
show_toc: true
image: assets/lectures/week-5/jeremy-cai-1169-unsplash.jpg
image_alt: By Jemremy Cai on Unsplash
---

## Outline

Before you attend this week's lab, make sure:

1. you can read and write basic assembly code: programs with registers,
   instructions, labels and branching

2. you've completed the [week 3 "pokemon" lab]({% link
   _labs/03-maths-to-machine-code.md %})

3. you're familiar with the basics of functions ([in the lectures]({% link
   _lectures/index.md %}#chapter-3-functions))

In this week's lab you will:

1. write **functions** (subroutines) to break your program into reusable
   components

2. pass data in (parameters) and out (return values) of these functions

3. keep the different parts of your code from interfering with each other
   (especially the registers) using the stack

{:.info-box}
We will be using the `week-6` folder of the lab repo you forked 
and cloned [in week 4]({% link _labs/04-blinky.md %}). If not, 
[here's a link]({{ page.template_repo }}).

## Introduction

Imagine you have a friend who's a teacher (or a university lecturer!) and is
stressed out at the end of semester. They've finished marking all of their
student's assignments and exams, but the marks for these individual pieces of
assessment are just scribbled around your friend's apartment on whatever piece
of paper (or wall) was closest at the time.

![What a mess!]({% link assets/labs/lab-7/scribbles-on-wall.jpg %})

There's only so much you can do to help your friend out, but one thing you can
do is to help them add up the marks for each student's assignments and exam to
calculate their final mark for the semester.

### Functions

Functions are (usually resuable) blocks of code that have been designed to
perform a specific task. Using functions allows us to break a big task (e.g.
calculating the mark of a set of students) into smaller ones, which in turn can
often be broken down into even smaller ones (e.g. setting and clearing a bit,
potentially). How fine-grained you should break things down is a design choice
that you get to make when you design your program.

The general pattern for functions look like this:

``` ARM
main:
  @ put arguments in registers
  @ mov r0, ...
  bl foo  @ call function foo
  @ continue here after function returns
  @ ...

.type foo, %function  @ optional, telling compiler foo is a function
@ args:
@   r0: ...
@ result: ...
foo:
  @ does something
  bx lr   @ return to "caller"
.size foo, .-foo      @ optional, telling compiler the size of foo
```

You will notice that this looks very much like the label stuff we did in the
[pokemon lab]({% link _labs/03-maths-to-machine-code.md %})---and you'd be
right. Since functions are just blocks of instructions, labels are used to mark
the start of functions.

The only difference between a function and the "branch to label" code you've
written already in this course (with `b` or perhaps a conditional
branch) is that with a function we want to return *back* to the
**caller** (e.g. the `main` function) code; we branch with `bl` but we want to
"come back" when we're done with the function instructions.

That's why `bl foo` and `bx lr` are used in the code template above instead of
just `b foo`.

The `bl foo` instruction:
1. records the address of the next instruction (i.e. the next value of `pc`) in
   the **link register**, and
2. branches to the label (`foo`)

The `bx lr` instruction
- branches to the memory address stored in the `lr` register

So, together these two instructions enable branching *to* a function (`bl foo`)
and branching *back* (`bx lr`) afterwards.

{:.info-box}

The `.type` and `.size` directive are optional---together they tell the compiler
that the label is a function, and what the size of the function is (`.-foo`
means current position minus the position of the label `foo`). They are
essential for the disassembly view to work correctly for the function. They
also slightly change what value the label has in instructions like `ldr r0, =main`.

## Task 1: a basic calculator

The assessment for your friend's class had 3 items:

1. 2 assignments, marked out of 100 but worth 25% of the total mark each
2. 1 final exam, marked out of 100 but worth 50% of the total mark

As an example, here's the marks for one student which your friend found written
on a banana on the floor of his lounge room:

{: #student-1-mark-table}

| student id | assignment 1 | assignment 2 | final exam |
|------------|--------------|--------------|------------|
| s1         |           66 |           73 |         71 |

Your job in this exercise is to write a `calculate_total_mark` function which
takes **three parameters** (assignment 1 score, assignment 2 score and exam
score) and calculates the total mark. Be careful to take account of the "number
of marks vs percentage of total mark" for each item (the maths here really isn't
tricky, but you still have to take it into account)

In this lab we'll talk a lot about "calling functions" because that's something
you're familiar with from higher-level programming languages. However, it's
important to remember that functions aren't some new magical thing, they're just
a matter of using the instructions you already know in a clever way.

Plug in your microbit, fork & clone the [lab 5
template]({{page.template_repo}}) to your machine, and open the `src/main.S`
file as usual. Your first job is to write a function to calculate the total mark
for the student s1 provided above.

To complete this exercise, your program should:

1. store the individual marks somewhere
2. calculate the total mark
3. put the result somewhere
4. continue executing from where it left off before the `calculate_total_mark`
   function was called

As we discussed in [lectures on functions]({% link _lectures/index.md %}#chapter-3-functions), the key to packaging up a bunch of assembly
instructions into a callable function is using the link register (`lr`) to
remember where you branched **from**, and the `bx lr` instruction to jump
**back** (or return) when you're done.

Here's a partial template (although you'll have to replace the `??`s with actual
assembly code for it to run:

``` ARM
main:
  @ set up the arguments
  mov r0, ?? @ ass1 mark
  mov r1, ?? @ ass2 mark
  mov r2, ?? @ final exam mark

  @ call the function
  bl calculate_total_mark

  @ go to the end loop
  b end

end:
  b end

calculate_total_mark:
  @ do stuff with the arguments
  @ ...

  @ put the result in r0
  mov r0, ??

  @ go back to where the function was called from
  bx ??
```

{:.push-box}

Starting with the code above, commit your a program which calculates the mark
for student `s1` (see their marks in the [table above](#student-1-mark-table)),
then moves into an infinite loop. Copy the code into `tasks/task-1.S`. Commit 
and push your changes with the message "completed task 1".

{:.think-box}
Look over your code from [lab 3]({% link _labs/03-maths-to-machine-code.md %}),
how would you rewrite it to use functions? **it's strongly recommended, but
optional for you to give this a go**... right now!

## Task 2: turning marks into grades

Your teacher friend is stoked with your solution but needs more help. They need
to give a letter (**A** to **F**) grade to each student based on the following
formula:

| 90--100 | 80--89 | 70--79 | 60--69 | 50--59 | 0--49 |
|---------|--------|--------|--------|--------|-------|
|       A |      B |      C |      D |      E |     F |

You tell your friend to relax---you can write another function which can do
this.

In this exercise you need to write a second function called `grade_from_mark`
which

- *takes* a numerical mark (0--100) as input parameter
- *returns* a value represending a letter grade (you can encode the "grade"
  however you like, but the hex values `0xA` to `0xF` might be a nice choice)

{:.talk-box}

There are a few ways to do this---you could generate results by doing a series
of comparison tests against the different score cut-offs, but also remember that
our input is a number and our output is really just a number as well. Discuss
with your partner: is there a numerical transformation (a simple formula) that
turns an overall mark into a grade? What are the edge cases of this formula? Are
there downsides to using a "closed form solution" rather than a series of
checks?

{:.push-box}

Add a `grade_from_mark` function to your program as described above. In your
program, demonstrate that it returns the correct grade for the following inputs:
(`15`, `99`, `70`, `3`). Copy the code into `tasks/task-2.S`. Commit and push 
your changes with the message "completed task 2".

{:.think-box}

Are there any other input values which are important to check? How does your
function handle "invalid" input?

{:.extension-box}

If you're feeling adventurous, modify your program to call `grade_from_mark`,
then store the result to memory in the `.data` section using the ASCII encoding.

## Task 3: putting it together {#exercise-3}

In this exercise, you need to write a function called `calculate_grade` which
combines these two steps: it takes the raw marks on the individual assessment
items and returns a grade.

Write a `calculate_grade` function which calls (i.e. `bl`s) the
`calculate_total_mark` function and use it to calculate the grades of the
following students:

| student id | assignment 1 | assignment 2 | final exam |
|------------|--------------|--------------|------------|
| s2         | 58           | 51           | 41         |
| s3         | 68           | 81           | 71         |
| s4         | 88           | 91           | 91         |

Combining these two functions is not too complicated, but remember to save your 
link register!

{:.push-box}

Submit a program which uses `calculate_grade` to calculate the mark of student
`s4`. Copy the code into `tasks/task-3.S`. Commit and push your changes with the 
message "completed task 3".

## Task 4: recursive functions

Another way to implement the `grade_from_mark` function is using
recursion---where a function calls *itself* over and over. Each time the
function calls itself it (usually) passes itself different arguments to the time
before. Still confused? [Let this jolly englishman walk you through
it](https://www.youtube.com/watch?v=Mv9NEXX1VHc").

The basic logic for a `grade_from_mark_recursive` function is this:

1. if the total mark is less than 50, the grade is a fail so the function should
   return (i.e. place in `r0`) the failing grade value

2. otherwise, decrement the mark and recursively call the function passing in
   the new mark.

This recursive pattern will ultimately round the mark down until it hits the 
base case (1). After this it will then move up through the grades as the function
works its way back out of the recursive calls.

Again, you need to use the stack pointer to not only keep track of your link
register but also the parameters you are passing into functions so the registers
don't interfere with each other.

Your code should be something like this:

```ARM
grade_from_mark_recursive:
@ ...
  bl grade_from_mark_recursive  @ recursive call
@ ...
  bx lr
```

{:.push-box}

Re-write your program from [Task 3](#exercise-3) so that it calculates the
grade using a recursive function. Copy the code into `tasks/task-4.S`. Commit 
and push your changes with the message "completed task 4".

{:.talk-box}

Discuss with your lab neighbor---what are the pros and cons between this and the
original `grade_from_mark` function?

## Task 5: time to cheat

In a new initiative, the students get to self-assess their work in the course
(give themselves a final mark for the course). The only catch here is that the
student's mark is compared with the teacher's mark. If the student mark is no 
more than 10 marks better than the teacher's mark, they get the average of the 
two marks (i.e. theirs, and the teacher's). If the discrepancy is more than
that, they get the teacher's mark **minus** the difference. This should stop any
cheating---if the student's mark is too high, they'll actually be *worse* off 
than before.

Write a `self_assessment` function and incorporate it into the overall
`calculate_grade_sa` function.  
The `self_assessment` function should return the students self-assessed mark in `r0`.

Try it with a few different versions of `self_assessment`---some which pass 
the "no more than 10 marks better than the teacher's mark" criteria, and some that 
don't. Does your program handle all the cases properly?

Now imagine that *you're* the student---so you provide your own
`self_assessment` function. Can you think of a way to cheat? Can you craft the
assembly instructions inside the `self_assessment` function in such a way that
you can get a better mark than you deserve (without touching the rest of the
program)?

Use the following rough structure (still need to fill it out yourself!) of the
`calculate_grade_sa` function to write the "cheating" version of `self_assessment`.

```ARM
calculate_grade_sa:
  @ TODO: prep for call
  bl calculate_total_mark

  @ store teacher's mark on top of stack
  str r0, [sp, -4]!
  @ delete the teacher's mark from r0
  mov r0, 0

  @ TODO: prep for call
  bl self_assessment  @ cheat in here
  ldr r1, [sp], 4

  @ TODO: calculate final grade from: 
  @ - student mark (r0) 
  @ - teacher mark (r1)
  @ ...
  bx lr

self_assessment:
  @ TODO: return self assessed mark in r0
  @ ...
  bx lr
```

{:.think-box}

Think about the values on the stack---can you break "outside" and mess with
things outside of the `self_assessment` function? How could this allow you to
cheat? *hint*: when we are using the stack pointer `sp` to store things in
memory, can you figure out an offset for reading/writing values "outside" that
function's part of the stack?  

{:.do-box}

There are a couple ways you can do this, can you you give yourself any arbitrary mark?
How about the maximum possible mark based on the teachers final mark?

{:.push-box}

Copy your "cheating" version of the marking program into `tasks/task-3.S`. Commit and 
push your changes with the message "completed task 5".

{:.extension-box}

This stuff is all really important for gaining a deep understanding of
cybersecurity. If you are interested, you can see how the very techniques you
have just learned are being applied to reverse engineering things like the
[Nintendo Wii U](https://www.youtube.com/watch?v=QMiubC6LdTA)!

## Task 6: arrays as arguments

One of the tutors has heard about the good work you've been doing for your
teacher friend and they have asked you to help them. Fortunately, they are
more organized than the teacher and have provided you with a collection of the
students results in an array--but what does an array look like in assembly?
(prepare yourself for a brief tangent!)

### Sections in memory {#sections}

Sections in your program are *directives* (so they
start with a `.`) to the assembler that the different parts of our program
should go in different parts of the microbit's memory space. Some parts of
this address space are for instructions which the microbit will execute, but
other parts contain *data* that your program can use.

Your program can have as many sections as you like (with whatever names you
like) but there are a couple of sections which the IDE & toolchain will do
useful things with by default:

- if you use a `.text` section in your program, then anything after that (until
  the next section) will appear as program code for your microbit to execute

- if you use a `.data` section, then anything after that (until the next
  section) will be put in RAM as memory that your program can use to read/write
  data your program needs to do useful things

When you create a new `main.s` file, any instructions you put are put in the
`.text` section until the assembler sees a new section directive.

Here's an example:

``` ARM
main:
  ldr r0, =main
  ldr r1, =storage

.data
storage:
  .word 2, 3, 0, 0
  .asciz "Computer Organisation & Program Execution"
```

{:.think-box}

Looking at the microbit's address space map and running the program above,
where do you think the `main` and `storage` parts of your program are ending up?
Can you find the string "Computer Organisation & Program Execution" in memory?
Try and find it in the [memory view]({% link
_labs/02-first-machine-code.md %}#reverse-engineering).

![Discoboard address space]({% link assets/labs/lab-5/address-space.jpg %})

You can interleave the sections in your program if it makes sense:

``` ARM
.text
program:
  @ ...

.data
storage:
  @ ...

.text
more_program:
  @ ...

.data
more_storage:
  @ ...
```

When you hit build (or debug, which triggers a build) the toolchain will figure
out how to put all the various bits in the right places, and you can use the
labels as values in your program to make sure you're reading and writing to the
right locations.

<div class="extension-box" markdown="1">

If you're interested in seeing how it's done, you can look at your project's
linker script, located in your project folder at

``` text
lib/link.ld
```
</div>

```ARM
main:
  ldr r0, =results
  bl calculate_lab_grades
  nop
  b main

@ ...

@ input:
@ r0: address of start of mark array with format,
@ .word size of array
@ .word a1, a2, final, 0
@ output:
@ .word a1, a2, final, grade
@ ...
calculate_lab_grades:
  @ ...
  bx lr
  
@ ...

.data
results:
  @ Length of array: 6
  .word 6
  @S1
  .word 50, 50, 40, 0
  @S2
  .word 77, 80, 63, 0
  @S3
  .word 40, 50, 60, 0
  @S4
  .word 80, 82, 89, 0
  @S5
  .word 80, 85, 77, 0
  @S6
  .word 91, 90, 95, 0
```

Write the `calculate_lab_grades` function to iterate over the students `results` array
1. load the students results in to the registers
2. calculate their final grade using your `calculate_grade` function (the original one, 
not the self assessment version)
3. store the final grade in the empty word at the end of each entry, eg.  
```ARM
@SX
.word 20, 40, 58, 0 @ <--- here
```
4. repeat for the length of the array
5. return using `bx lr`

If you've implemented it correctly, your memory at the results array should 
look like this afterwards:  

![final grades in memory]({% link assets/labs/lab-7/array-in-memory.png %})

*note: the final grades are stored in the 00 offset 
column, starting from 20000010*

{:.push-box}

Copy your program to add the grades to the array into `tasks/task-6.S`. Commit and push 
your changes with the message "completed task 6".

{:.extension-box}

The values in this code are stored in memory using `.word`s which are 32 bits 
*(4 bytes)* in size, yet no entry needs more than a byte, can you rework your code and 
the array to reduce its size in memory?

## Extra Tasks

### LED Library {#led-library-extension}
Combine what you've learned over this and the previous lab to create some LED utility functions. How could you parameterize the functions to make them the most useful and reduce similar code?
