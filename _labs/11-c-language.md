---
title: "Week 11: the C programming language"
summary: "Coding a step above assembly using C."
template_repo: https://gitlab.cecs.anu.edu.au/comp2300/2022/comp2300-2022-lab-pack-4
show_toc: true
image: assets/labs/lab-11/example-w11.png
---

## Introduction

In this week's lab we're going to look at writing programs for your microbit in
a different programming language: C! C appeared in 1972 but is still popular
today. Its style has been emulated in many modern programming languages such as
C++, C# and Java, so if you have worked in any of those languages before, some
parts of the syntax will seem quite familiar.

The reason we look at C is that is important as a "systems" programming
language, and it is intertwined with the development of the Unix operating
system (and later, the Linux kernel). C gives you some of the features of
high-level programming (like functions, loops and control structures), but also
some of the control of assembly such as direct manipulation of memory. In fact,
many people say that C is "just one step above assembly".

In this lab you'll learn about a few of C's language features and see how you
can use it to accomplish some of the tasks that you already do in assembly
(e.g., accessing a memory mapped register to turn on an LED). You might find
that some parts of this are "easy", it's definitely easier to write a for loop
in C than assembly! And other parts are a bit tricky since you're used to
manipulating registers and memory very directly in assembly.

Note that this lab is not a _complete_ primer in C, there's lots of details
that are skipped, we're just looking at a few features of the language that
reflect the kind of programming we have done in assembly. If you want more
info, we suggest reading the definitive book ["The C Programming
Language"](https://en.wikipedia.org/wiki/The_C_Programming_Language), written
by Brian Kernighan and Dennis Ritchie who designed C and were also involved in
creating Unix. This book is so famous that it's just called "K and R", any
computer scientist will know what that means.

While you're doing the lab you might find some of these links to be helpful:

- [Data types in C](https://en.wikipedia.org/wiki/C_data_types)
- [C syntax](https://en.wikipedia.org/wiki/C_syntax)
- [Operators in C](https://en.wikipedia.org/wiki/Operators_in_C_and_C%2B%2B)


<div class="warn-box" markdown="1">

We had to change the lab pack a bit to get C working in this lab, make sure you
use the following git command in VSCode's terminal to update your lab pack to
the latest template before starting the lab:  
```bash
git remote add upstream https://gitlab.cecs.anu.edu.au/comp2300/2022/comp2300-2022-lab-pack-4.git
git fetch upstream
git merge upstream/main
```
If there are any conflicts then you can go ahead and 'accept incoming' for them. 
If you get stuck you can ask a tutor for help. Once you've done that, your week-11 
folder should look like:  

![example-week-11]({% link assets/labs/lab-11/example-w11.png %}){:style="width:auto; height:auto;"}
</div>

## Task 1: Functions variables, and disassembly

Open up your `main.c` file for this lab, you'll see that intead of `main.S`, it's
called `main.c`! All through the course, our code has actually been assembled
by `gcc`, the GNU compiler, if the compiler sees a `.S` file, it just assembles
it, but if it sees a `.c` file, it compiles the C into machine instructions.

The file contains a simple `main` function:

```C
int main(void)
{
  return 0;
}
```

You can see that the function syntax looks similar to Java, this function
doesn't take an argument (`void`) but it does have a single return value of
type `int`.

Your task here is going to be to **create a second function** that **adds three
numbers together**, and **call it from the main function**.

To do this, you'll want to learn a bit about the types of variables available in C, so read the following sections.

### Variable Types

The C language needs you to declare the "type" of a variable before you can use
it, this information lets the compiler use an appropriate amount of memory for
storing your variable, you can also use _qualifiers_ to let the compiler know
if you want a variable to be _signed_ or _unsigned_ (finally!)

You're probably familiar with declaring a type for a variable as follows: 

```C
int x = 5;        // Declare variable x with value 5
int x;            // Declare variable x without initialization - bad practice!

```

There are four basic types that you can use in C:

- `char` (1 byte, often used to store a single ASCII character---hence the name---but it can also store numbers)
- `int` (4 bytes)
- `float` (a 4-byte IEEE-754 representation floating point number)
- `double` (an 8-byte IEEE-754 representation floating point number)

The four basic type qualifiers are `unsigned`, `signed`, `short`, and `long`. 

You can combine these as follows:
```
short unsigned int = 23;
```
which creates a 2-byte variable (not 4), and specifies that it can contain unsigned numbers only (i.e., 0--65535).

Create a few variables in your `main` function and try compiling your program to see how it works.

### Operators and Control Structures in C

C supports most of the normal operators you would have experienced in other programming languages, a formal [list is here](https://en.wikipedia.org/wiki/Operators_in_C_and_C%2B%2B). E.g.:

```C
int a = 12;
a = a + 34;
a--;
++a;
```

(N.B.: what's the difference between `a++` and `++a`?)

C also has typical control structures, e.g.:
```C
if (a == 13) {
    b = 26000;
    a++;
}
```

You can read about C's control structures [here](https://en.wikipedia.org/wiki/C_syntax#Control_structures)

### Writing functions

Functions in C have the following form:

```C
<return-type> functionName( <parameter-list> )
{
    <statements>
    return <expression of type return-type>;
}
```
See [C Syntax](https://en.wikipedia.org/wiki/C_syntax#Functions) for more information.

### Back to the task...

So returning to you task, you have to:

- create a second function
- that adds three numbers
- and call it from your `main` function

Probably not so hard, but here's the twist: you also have to use the
`disassemble function` command in VSCode to see the actual instructions that
the C compiler has used to implement your function! Use the debugger to step
through your program and notice that it automatically shifts to the disassembly
to step through each actual instruction.

With a partner or a small group, answer the following questions:

- how are local variables stored in your program?
- how are parameters passed from one function to another?
- how are return values handled?
- is C call-by-value or call-by-reference?

{:.push-box}

Add your code to the `task-1.c` file and push to gitlab. If you have any
questions about your function, discuss with your group and ask your tutor!

## Task 2: Memory, pointers and the reference operators

With assembly programming you have gotten used to the idea of moving memory
addresses around to represent different variables in memory. You've had to just
_know_ whether a value in a register refers to a variable, or a _memory address
pointing to a variable_.

Happily, C helps us to make this distinction precise by allowing to define
pointers as a kind of type and to easily get anny variable's memory address and
to later retrieve the actual value at that address.

To declare a pointer you need to specify the type the pointer is supposed to
point to and then a star (`*`), e.g.: `int *p` declares a pointer called `p` to
an int (but we haven't connected it anywhere yet). 

To use pointers we have two operators that help us get memory addresses and the
values behind those addresses: `&` (reference) and `*` (dereference): 

- If you have a variable `x`, then `&x` is the address of `x`.
- If you have a pointer `p`, then `*p` is the value pointed to by `p`.

Let's look at an example in code:

```C
int x = 102; // declare an int x with value 102
int *p = &x; // declare an int pointer (pointer to an int) and set to the address of x
*p = 99; // change the value of x to 99 (changing the memory that p points to!)
```

You could write this in pseudo-assembly as follows (assuming that `x` and `p`
are labels to somewhere in memory):

```arm
@ x = 102
ldr r0, =x @ get a memory address labelled x
mov r1, 102
str r1, [r0] @ set value at x to be 102

@ int *p = &x
ldr r0, =p @ get a memory address labelled p
ldr r1, =x @ get memory address labelled x
str r1, [r0] @ set value at p to be address of x (&x)

@ *p = 99
ldr r0, =p @ get the address of the pointer
ldr r1, [r0] @ get the value of the pointer
mov r2, 99
str r2, [r1] @ set value of memory pointed to by p to be 99
```

(PS: no guarantee that any compiler will produce anything like the above, this
is just to help understand what's going on!)

{:.warning-box}

The `*` symbol causes confusion with pointers. `*` is used for three purposes
in C: to declare pointer types, dereferencing pointers, and regular old
multiplication. Confusing! 

Now, a cool way to use pointers is to create functions with parameters
passed-by-reference. For example you might have a function that takes two
`int`s by value: `int func(int a, int b`) but you could change the types of the
parameters to be `int *` instead.

So here's your task:

- Create a function called `square` that takes one argument (by reference) and
  updates that value to be its square. Your function should have `void` as the
  return type (that is, it doesn't return the new value, it just changes it in
  memory!)

Look at the dissassembly of your function, with a small group answer the
following questions:

- how are the pointer operators implemented in assembly? (is it like the
  example above or completely different?)
- are there any advantages you can see to using pointers?
- what might go wrong if you used a lot of pointers in your code?
- do you think your experience with assembly helps you to understand pointers? why?

{:.push-box}
Add your pointer function to `task-2.c` and push to gitlab.


## Task 3: Arrays and Structs

In this task we're going to create a few data structures in C. C doesn't
support many kinds of data structures, really it just has the two that we
discussed in assembly: arrays and records (called a `struct`). Let's learn
about them, create some in the main function and then look at the disassembly
to see how they work!

### Arrays

Creating an array in C might feel familar:

```c
int a[10]; // create an array of 10 int-sized variables (not initialised)
a[3] = 23; // set the fourth element of a (a[3]) to 23.
```

Now we get to the fun bit. If `a[0]` is the first element of the array, then what is `a`? It's actually the _pointer to the first element!_ That is you can write:

```c
int *p = &a[0]; // create a pointer to the first element of the array
int *q = a; // create a pointer to the first element of the array
```

and `p` and `q` will then have the same value.

The second fun bit is that you can use arithmetic with a pointer to access elements in the array. For example:

- `a` is a pointer to the first array element (`a[0]`)
- `a + 1` is a pointer to the 2nd element (`a[1]`)
- `a + 8` is a pointer to the 9th element (`a[8]`)

In fact, in C `a[i]` is literally the same thing as `*(a + i)`. (Even K&R say that this is "surprising", so expect it to take a second to sink in).

This is similar to doing offset loads and stores in assembly, but somewhat more convenient because C is keeping track of how much space in memory each array element is taking up (1 int, so 4 bytes) and adding that amount to the pointer each time. No more having to remember the size of elements! (What efficiency!)

{:.info-box}

Although you can use `a + i` to refer to the ith element of an array, you can't _set_ `a`. It's not a variable.

### Structures

A `struct` in C is a lot like a record as we defined it earlier in the
semester, e.g., the following code defines the template of a structure called "student":

```C
struct student {
  int uid;
  float score;
  char firstname[20];
  char lastname[20];
};
```

Declaring structures works as follows:

```C
struct student empty;
struct student full = {1234567, 77.6, "first", "last"};
```

In the case of the "empty" structure, the component variables will contain
undefined data.

So how do you access the variables within structures? For a structure variable, you can use `.` to address different components, e.g., `full.score = 90;`. If you happen to have a pointer to a structure, you use a `->` which will dereferennce the component in place, so for example:

```C
struct student *stu_ptr = &full;
stu_ptr->score = 43;
```

{:.info-box}

Remember that `->` gets the actual value of a pointer-to-a-structure's component, not a pointer to that component. That is: `stu_ptr->score` is the same as `(*stu_ptr).score`.

### Make some arrays and structs

Your task here is to:

- Create a "cheating" function that takes a reference to a `student` structure, and changes its score to 110, but also changes the first character of `lastname` to "X".

Use the disassembler to figure out how the structures and and arrays are stored in memory.
Try out some different ways of declaring structures and arrays. Discuss with your group:

- Are they stored differently if they are a local variable (of a funtion) vs a global variable?
- How similar are structures and arrays to your implementations in assembly?


{:.push-box}
Add your structure experiments to `task-3.c` and push to gitlab.

## Task 4: Blink an LED in C

Your final task is to repeat the "blinky" lab, but this time in C!

All throughout this course, we have been preoccupied with adjusting values in
memory-mapped hardware registers. For instance, to turn on an LED, we had to
set the direction of the column and row registers to OUT, then set the output
of the row to HIGH.

Now that we know about pointers in C, we can actually do these kinds of
operations quickly and easily. For example, to set row 1 (`P0.21`) to OUT, we
can do the following:

```C
volatile int *GPIO_P0_DIR = (int*) 0x50000514;
*GPIO_P0_DIR = *GPIO_P0_DIR | (0x1 << 21);
```

If you remember lab 4, this two line solution took us _6 assembly_ instructions
to load the prevoius value of the direction register, adjust it, and store it
back.

Before running off to translate all of your 2300 code to C, consider a few details:

- The pointer is declared as a `volatile int`. The volatile keyword tells the
  compiler that the value being pointed to may change without being modified by
  our program. It is usually a good idea to use the volatile keyword when
  operating on peripherals.
- We have used C's bitwise or `|` and left shift `<<` operators to construct
  the updated value for the register.

Now you have all the tools you need to turn on an LED with C! Go do it! It
should only take a few more lines.

If you have forgotten the memory addresses needed, go back to the [blinky
lab.]({% link _labs/04-blinky.md%}).

When your code is working, look at the dissassembly again and discuss with
your group:

- How do you feel about setting hardware registeres in "high level" C?
- Do you miss the _raw power_ of assembly? Or does this make you yearn for the
  relative safety of C syntax? 
- How would you implement an LED library in C? Is there anything you could do
  easily here that would be hard in assembly?
- How would you go about implementing a `SysTickHandler` and making a timed
  blinking LED in C? Have we taught you enough that it is possible?
- How would you implement a one-byte-offset load in C? As in the assembly
  instruction `ldr r1, [r0, 1]`? Is it possible? Is it _wrong_?

{:.push-box}
Add your blinky code to `task-4.c` and push to gitlab.

{:.warn-box}

Check the CI for each task you have pushed to make sure everything is compiling and working correctly!

{:.info-box}

We know that the assignment is due this week and that you probably have
previous lab tasks to catch up with, so when you're done with your C tasks,
feel free to work on other 2300 work and ask the tutors for help!

## Extra Tasks

There's a lot of extra tasks this time, remember that these are just for your
learning, not for marks. Most of these were written by members of the ENGN2219
tutor team so thank them if you see them!

### Extra Functions

This task is to discover how to call functions that have lots of arguments, or
complex arguments. Write something that you think will work, then check what
the compiler has done with the disassembler. If you follow the calling
convention, this exercise should be fairly easy. Do the following:

1. In assembly, write a function `five_fun` that takes 5 integers as arguments,
   and sums them. Call this function from `main`.
2. In C, write a similar function with many integer arguments. Call this
   function from `main` in your main.S file.
3. Write a C function that increments every number in an array by 1. Define an
   array in main.S, and call it from `main`. Don't forget to `.global` your
   assembly file's array.
4. Write an assembly function that decrements every number in an array by 1.
   Define an array in `main.c`, and call your function from `c_main`.

{:.think-box}

Don't forget about the length of your arrays for task 3 and 4! These tasks are
more challenging than the first two.

### Pass by Reference / Pass by Copy

Passing by Reference or Copy are two distinct methods of providing arguments to
functions. Pass by copy is the default behaviour in C - When calling a
function, a copy of the value of each argument is made. These copies are stored
as a local variable in the function's stack frame. Changing these local
variables within the function does not modify the value of the original
variable passed as an argument.

Pass by reference, on the other hand, does imply that the original function
arguments are modified. The reference, or pointer, to the argument can be used
to directly operate on the argument in memory. Such functions can modify
variables without returning anything - the function is said to have "side
effects".

Using either the student data structure or your own, your task is to write two
functions:

- a function that modifies a struct using pass by copy, and returns the
  modified struct
- a function that modifies a struct using pass by reference, with no return
  value

Your function signatures should look something like this:
```
struct somestruct pass_by_copy(struct somestruct x);
void pass_by_ref(struct somestruct *x_ptr);
```

Don't worry about doing anything too fancy - just increment an item or add two
items together. Once you have written your function, look in the disassembler
and answer these questions:

- Your struct is probably a bit larger than what can fit in 4 registers. Where
  is the rest of the struct going for the pass by copy function?
- For completeness, identify how the arguments are passed in the pass by
  reference function.
- Consider the number of instructions used in each function. Which method do
  you think is more efficient? 
- Can you think of a situation where you would have to use pass by copy?

### Deep vs Shallow copy

While on the subject of passing by copy and reference, we will touch on another
subject - Copy depth. Essentially, shallow copy is when the *reference* to some
item is copied, whilst deep copy is when the *contents* of the item are copied.
Inadvertent shallow copy can be a big problem in other languages; it's also
possible in C when working with pointers. Consider the following code snippets:

```C
int array1[] = {1,2,3,4,5};
int array2[] = {6,7,8,9,0};
int *a1_ptr = &array1;
int *a2_ptr = &array2;
a2_ptr = a1_ptr;
```
```C
int array1[] = {1,2,3,4,5};
int array2[] = {6,7,8,9,0};
for (int i=0;i<sizeof(array1)/sizeof(int);i++){
  array2[i] = array1[i];
}
```

Note that a2_ptr now points to the same array in memory as a1_ptr - this
situation is called *pointer aliasing*, as multiple symbolic names are refering
to the same location in memory.

{:.think-box}

In the examples above, there is another potential aliasing situation. What do
you think **might** happen if you tried to access array1[5]? This is out of the
bounds of array1! C doesn't have any kind of bounds checking, so what value
will you get?


### Linked Lists (and other such data structures)

You may be familiar with list and string types from other programming
languages. These types often allow you to append more data to the end, unlike
C's fixed size arrays. These data types work by having a *link* from each
element to the next. Appending to a linked list is as simple as creating a new
element, and updating the last element of the list with a link to the new
element. A linked list can be implemented in C like so:

```C
struct ll{
  int value;
  struct ll *next;
};

struct ll third = {3,0};
struct ll second = {2,&third};
struct ll first = {1,&second};

int sum_ll(struct ll list);
```

**complete the sum_ll function** which sums all of the elements of a linked
list. Note that the pointer for the last element of the list is 0. Once your
function is done, add a fourth element to the linked list and make sure your
function still behaves properly.

### FizzBuzz with a Twist

The standard FizzBuzz function generally takes an `int` input `m` and, for each
`int` `n` from `0` to `m`, prints `n` followed by one of the following:

- `"Fizz"` if `n` is divisible by 3
- `"Buzz"` if `n` is divisible by 5
- `"FizzBuzz"` if `n` is divisible by both 3 and 5

Your output should look something like this:
```
0
1
2
3 Fizz
4
5 Buzz
6 Fizz
7
8
9 Fizz
10 Buzz

...

14
15 FizzBuzz
16

...
```
up to the given value of `m`. 

Unfortunately, we don't have the luxury of a big standard library and a console
to which we can print output. **Your task** is to write a C function
`NextFizzBuzz` that takes an `int` as input and finds the next FizzBuzz
number---the next number divisible by 3 and 5. Call this function from your
main.S file to test for the correct output.

