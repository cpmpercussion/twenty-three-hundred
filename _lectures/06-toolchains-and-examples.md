---
title: Toolchains and your microbit
summary: But how does the code get to the CPU?
permalink: /lectures/week-6/
image: assets/lectures/week-6/running-with-scissors.jpg
hidden: false
---

{% include slides/title.html %}

{:.center}
# Week 6: Assemblers, Compilers, and Toolchains

{% include slides/background-image.html
           image="lectures/all/all-todos.jpg"
           heading="Admin Time"  %}

Course Survey

Assessment results so far

Assignment 1

## Course Survey 1

![]({% link assets/lectures/week-6/survey_1.png %})

## What do you like about the course?

- Tutors/Charles (🥰)
- lectures and labs: engaging, clear, easy to understand,
- micro:bit: seeing the LED turn on, how computers work at a lower level 
- learning to code in assembly
- labs useful for the assignment / lectures and labs support each other
- quiz: helps learning without being stressful

> This course is keeping me at uni, loving it so much.

## What have you found **hard** so far?

- memory, overflow flag, carry flag, IT blocks, stack, memory
- reference manual (needs a reference manual)
- **constraints** of assembly
- **distance** between labs and lectures (takes time to absorb lectures)
- change from **"standard programming"** learned before. 
- **creativity** needed for the assignment
- assignment seems hard given **deadline** (want more time)
- "limited information online"

{:.fragment}
_e v e r y t h i n g_ 😰😰😰

## What would you **change**?

- some time discussing how the lights work
- more engagement with classmates (group work)
- more details (lectures/labs/assignments)
- more quizzes
- lab solutions 
- easier labs / more extensions
- posting demo code
- more live coding
- drop in sessions
- in-person lectures

## Topics: Where are we at?

- ✅ Digital Logic
- ✅ ALU Operations
- ✅ Memory Operations
- ✅ Control Flow
- ✅ Functions
- Data Structures
- Interrupts and Asynchronism
- Networks
- Operating Systems
- Architectures

{% include slides/background-image.html
           image="lectures/all/all-todos.jpg"
           heading="Assignment 1: What do you need to know?"  %}

"Your program must use the LEDs to create a light show that changes over time"

Need: how to blink any LED on the microbit (lab 4)

Need: how to scan across columns/rows quickly to display an image on the LEDs (lab 5)

Want: excellent knowledge about memory, control flow, and functions (all labs and lectures)

## Scanning on the LED screen

- The LED is a matrix, so you **can't** display a static image.

- You **can** activate any combination of LEDs in an individual row or column

- To display an image, divide it into rows or columns and display each one individually (and quickly) so that it appears to be a single image.

No sample code for this---you have to work on it for yourself. We do have an example though!

{% include slides/background-video.html
           video="lectures/week-6/microbit-scanning.mp4"
           heading="Scanning an Arrow, column-by-column"  %}

## Row and Column Cheatsheet

```
  @ ROW 1: P0.21
  @ ROW 2: P0.22
  @ ROW 3: P0.15
  @ ROW 4: P0.24
  @ ROW 5: P0.19

  @ COL 1: P0.28
  @ COL 2: P0.11
  @ COL 3: P0.31
  @ COL 4: P1.05
  @ COL 5: P0.30
```

To light an LED, ROW should be high and COL should be low.

{:.center}
# A bit of revision: control flow and functions

## xPSR table {#cpsr-table}

{: style="font-size:0.6em;"}

| `<c>` | meaning                 | flags     |
|-------|-------------------------|-----------|
| eq    | equal                   | Z=1       |
| ne    | not equal               | Z=0       |
| cs    | carry set               | C=1       |
| cc    | carry clear             | C=0       |
| mi    | minus/negative          | N=1       |
| pl    | plus/positive           | N=0       |
| vs    | overflow set            | V=1       |
| vc    | overflow clear          | V=0       |
| hi    | unsigned higher         | C=1 ∧ Z=0 |
| ls    | unsigned lower or same  | C=0 ∨ Z=1 |
| ge    | signed greater or equal | N=V       |
| lt    | signed less             | N≠V       |
| gt    | signed greater          | Z=0 ∧ N=V |
| le    | signed less or equal    | Z=1 ∨ N≠V |

## The *best* if statement {#the-best-if-statement}

``` arm
if:
  @ set flags here
  b<c> then

@ else label isn't necessary
else:
  @ instruction(s) here
  b rest_of_program

then:
  @ instruction(s) here
  
rest_of_program:
  @ continue on...
```

## A better while statement?

``` arm
begin_while:
  cmp r0, 5

  @ "invert" the conditional check
  beq rest_of_program

  asr r0, r0, 1
  b begin_while

rest_of_program:
  @ continue on...
```

## for loop with labels, but no code (yet)

``` arm
begin_for:
  @ init "index" register (e.g. i)
loop:
  @ set flags here
  b<c> rest_of_program

  @ loop body

  @ update "index" register (e.g. i++)
  b loop

rest_of_program:
  @ continue on...
```

## Function template

``` arm
@ use the type directive to tell the assembler
@ that fn_name is a function (optional)
  .type fn_name, %function

fn_name: @ just a normal label
  push {lr} @ maybe other things too
  @
  @ the body of the function
  @
  pop {lr} @ maybe other things
  bx lr  @ to go back
.size fn_name, .-fn_name
```

## Stack Frames and the Frame Pointer

One extra detail: 

- the frame pointer (`fp` or `r11`) points to the start of the _current stack frame_.
- this means you can access local variables by loading/storing relative to `fp`
- doesn't work to do this relative to `sp` (why?)
- `fp` needs to be pushed at the start of a function and restored at the end.

At the start of a function, you push `fp`, then make space on stack for all local variables.

At the end of a function, you "delete" local vars from stack, and restore `fp`.

{:.center}
# Toolchains and Compilers

## What is a toolchain?

- a collection of programming tools (programs) that are used one-after-another to create a program

- the [GNU compiler toolchain](https://en.wikipedia.org/wiki/GNU_toolchain) is widely used

- When you "build" your assembly code in VSCode there's actually four GNU tools being used:

	- `make`, `gcc`, `ld`, `objcopy`

- and one extra tool: `openocd`

## Where is it on my computer?

When you installed the course VSCode extension, it automatically installed the GCC ARMv7 toolchain and `openocd`

You can find it in `~/.comp2300/`

(BTW, after the course, you can safely delete `~/.comp2300` from your computer)

If you have a MacOS or Linux computer, `make` was already installed. On Windows you installed `make` in the first lab in your "git bash" folder.

## How does it work?

`make`: build automation---runs each part of the build process in sequence

`gcc`: GNU compiler collection---turns assembly commands into CPU instructions (why not use `as`? because `gcc` is smarter)

`ld`: linker---creates a binary data from the CPU instructions and allocates memory locations for variables (knows about the memory layout of the microbit

`objcopy`: "object copy"---copies binary data out of the ELF file produced by `ld` in the exact layout that the microbit can use (removing debug and extra info)

`openocd`: "open on-chip debugger"---helps upload `.bin` file to microbit and allows step-by-step debugging

## So how does a compiler work?

How a compiler works (in detail) is out of scope for this course.

But think about the "best if statement", the "best function template", the "best while loop"

High level programming constructs can be represented as "templates" in assembly. Compilers can build assembly by using good templates for each high level construct.

(and then they do a lot more stuff as well... but this is good enough for today)

To be a good assembly programmer: need a **very clear understanding** of high-level programming constructs. Then you can optimise from there.

{% include slides/background-image.html
           image="lectures/week-6/running-with-scissors.jpg"
           heading="Compiling/Assembling starts with copy-pasting templates"
           id="copy-pasting-kid"  %}

Let's do some experiments to see how this works...

## Godbolt compiler explorer {#godbolt-compiler-explorer}

<https://godbolt.org/>: a super-cool interactive resource for exploring stack
frames (and code generation in general)

A few tips:
- in the compiler select dropdown, select one of the `ARM gcc` options
- in the *Compiler options...* box, try `-O0` (unoptimised) vs `-O3` (optimised)
- try modifying the C code on the left; see how the asm output on the right changes
- remember the [stack frames]({% link _lectures/05-functions.md
  %}#function-prologue-epilogue)!

## Good Godbolt experiments

Try this C++ funnction:

```C++
int boringfunction() {
    int i = 0;
    int a = 1;
    while (i < 10) {
        a = a + i;
        i = i + 1;
    }
    return a;
}
```
What is the difference between the `-O0` (unoptimised) and `-O3` (optimised) versions?


{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Demo: Table Branch"  %}

How to use the `tbb` and `tbh` instructions - tricky but powerful and efficient way to do a `case`-style construct.

From the reference:

> These instructions cause a PC-relative forward branch using a table of single byte offsets (TBB) or halfword offsets (TBH). Rn provides a pointer to the table, and Rm supplies an index into the table. The branch length is twice the value of the byte (TBB) or the halfword (TBH) returned from the table. The target of the branch table must be in the same execution state.

## Table Branch (byte)

{: style="font-size:0.6em;"}
```arm
.type case_example, %function
case_example:
  tbb [pc, r0] @ tbb gets an byte stored r0 bytes away from pc and branches to pc + 2*byte
branchtable: @ this will be `pc`
  .byte (case0 - branchtable)/2 @ offset from pc to case0 (stored in halfwords)
  .byte (case1 - branchtable)/2 @ offset from pc to case1 (stored in halfwords)
  .byte (case2 - branchtable)/2 @ offset from pc to case2 (stored in halfwords)
  .byte (case3 - branchtable)/2 @ offset from pc to case3 (stored in halfwords)
  .align
case0:
  mov r0, 0x0A
  b exit_case_example
case1:
  mov r0, 0x0B
  b exit_case_example
case2:
  mov r0, 0x0C
  b exit_case_example
case3:
  mov r0, 0x0D
  b exit_case_example
exit_case_example:
  bx lr
.size case_example, .-case_example
```

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Demo: Function with Stack Parameters"  %}

We saw parameters stored on the stack with _godbolt_, but how can we do that ourselves?

## Stack parameter and return value function

```arm
.type stack_function, %function
stack_function:
  @ take one argument (last place on the stack)
  @ argument is at sp + 0
  ldr r0, [sp] @ load in our argument
  push {r4-r11, lr} @ just pushing stuff to the stack for no reason
  lsl r0, r0, #1 @ r0 = r0 * 2
  @ str r0, [sp, 36]
  @ do some other stuff.
  pop {r4-r11, lr} @ return registers and stack state
  str r0, [sp]  @ return one value (same place on the stack)
  bx lr
.size stack_function, .-stack_function
```

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Demo: Recursive Fibonacci"  %}

Why is this tricky?

Need to calculate `fib(n-1) + fib(n-2)`

That's two recursive function calls, need to look after local registers in between (use the stack, make sure to balance pushes and pops).

(BTW -- this is definitely not the most **efficient** implementation...)

## Recursive Fibonacci

{: style="font-size:0.6em;"}
```arm
.type fibonacci, %function
fibonacci:
  @ 1 1 2 3 5 8 13....
  @ argument from r0
  @ if r0 is 0 or 1, return 1
  @ else return fibonacci(r0-1) + fibonacci(r0-2)
  push {lr}
  cmp r0, 0 @ check for base case
  beq fib_base_case
  cmp r0, 1 @ check for base case
  beq fib_base_case

fib_recursive_case: @ recursive case: return fibonacci(r0-1) + fibonacci(r0-2)
  push {r0} @ save r0
  sub r0, r0, 1 @ r0 = r0 - 1
  bl fibonacci 
  mov r1, r0 @ store output in r1
  pop {r0} @ restore r0
  push {r1} @ store r1 safely
  sub r0, r0, 2 @ r0 = r0 - 2
  bl fibonacci
  pop {r1} @ restore r1
  add r0, r0, r1 @ fibonacci(r0-1) + fibonacci(r0-2)
  b exit_fib

fib_base_case:
  mov r0, 1
  @ b exit_fib
exit_fib:
  pop {lr} 
  bx lr
.size fibonacci, .-fibonacci
```

{% include slides/background-image.html image="lectures/all/all-reading.jpg"
heading="Further reading"  %}

[From Zero to `main()`: Demystifying firmware linker scripts](https://interrupt.memfault.com/blog/how-to-write-linker-scripts-for-firmware)

[`.macro` **as** directive docs](https://sourceware.org/binutils/docs-2.24/as/Macro.html)

[Useful assembler directives and macros for the GNU
assembler](https://community.arm.com/processors/b/blog/posts/useful-assembler-directives-and-macros-for-the-gnu-assembler)
on community.arm.com

[ARM Stack Frames](https://lloydrochester.com/post/c/stack-of-frames-arm/)

[Azeria Labs: Functions and the stack](https://azeria-labs.com/functions-and-the-stack-part-7/)

## VSCode Function Snippet (thx Benjamin Gray) {#function-snippet}

**Want to make functions quickly?** Use a snippet!

> Put this in the file opened by Command Palette > Preferences: Configure User Snippets > arm  (ARM). You can replace the whole file contents with the above. After doing this, in your assembly files you can start typing `function`, and a popup will appear letting you expand it to the function template.

{: style="font-size:0.5em;"}
```json
{
    "function": {
        "prefix": "function",
        "body": [
            ".type ${1:name}, %function",
            "${1:name}:",
            "\t${0:nop}",
            "\tbx lr",
            ".size ${1:name}, . - ${1:name}"
        ],
        "description": "Function template"
    },
    "global_function": {
        "prefix": "gfunction",
        "body": [
            ".global ${1:name}",
            ".type ${1:name}, %function",
            "${1:name}:",
            "\t${0:nop}",
            "\tbx lr",
            ".size ${1:name}, . - ${1:name}"
        ],
        "description": "Global function template"
    }
}
```

{% include slides/background-image.html
           image="lectures/all/all-questions.jpg"
           heading="Questions?"  %}









{% comment %}

{% include slides/impact.html %}

a bit about macros...

{% include slides/background-image.html
           image="lectures/all/all-bigpicture.jpg"
           heading="Macros are for automatically copy-pasting code"
           id="what-are-macros-for"  %}

{% include slides/background-image.html
           image="lectures/week-6/running-with-scissors.jpg"
           heading="Like this..."  %}


## `as` macro language

The macro language is defined by the [assembler]({% link
_lectures/02-alu-operations.md %}#assembler) (`as`)

Two steps:
- define a macro (with `.macro`/`.endm`)
- call/use a macro (using the name of the macro)

The assembler copy-pastes the macro code (replacing parameters where present)
into your program *before generating the machine code*

## General macro syntax

```ARM
.macro macro_name arg_a arg_b ...
  @ to use the argument, prefix with "\"
  @ e.g. adds r0, \arg_a, \arg_b
  @ ...
.endm
```

## Example: `swap`

```arm
@ swap the values in two registers
@ assumes r12 is free to use as a "scratch" register
.macro swap reg_a reg_b
  mov r12, \reg_a
  mov \reg_a, \reg_b
  mov \reg_b, r12
.endm
```

## Calling the `swap` macro

If you use `swap` in your assembly code

```arm
swap r0, r3
```

the assembler sees it and "expands" it to

```arm
mov r12, r0
mov r0, r3
mov r3, r12
```

it's **exactly** like you had used this code in your `main.S` file in the first place

{% include slides/impact.html %}

the CPU doesn't know **anything** about your macros

## Recap: if statement

Remember the [best if statement]({% link _lectures/04-control-flow.md %}#the-best-if-statement)

``` arm
if:
  @ set flags here
  b<c> then

  @ else
  b rest_of_program

then:
  @ instruction(s) here
  
rest_of_program:
  @ continue on...
```

## An `if` macro

```arm
.macro if condition_code condition then_code else_code
  \condition_code
  b\condition then

  \else_code
  b end_if

then:
  \then_code

end_if:
.endm

@ usage
if "cmp r1, r2", eq, "mov r3, 1", "mov r3, 0"
```

## Things to note

Macros can "splice" parameters into the middle of instructions, e.g.
`b\condition` becomes e.g. `beq` or `blt`

Whole instructions can be treated as a single macro parameter (e.g. `"cmp r1,
r2"` as the `condition_code` parameter) as long as they're surrounded by double
quotes (`"`)

This is a blessing and a curse!

## The `\@` macro "counter" variable

The `\@` variable contains a counter of how many macros executed so far which
you can use in your macro output

```arm
.macro if condition_code condition then_code else_code
  \condition_code
  b\condition then\@

  \else_code
  b end_if\@

then\@:
  \then_code

end_if\@:
.endm
```

## A basic `for` macro

```arm
.macro for register from to body
  mov \register, \from
for\@:
  cmp \register, \to
  bgt end_for\@
  \body
  add \register, 1
  b for\@
end_for\@:
.endm

@ usage
for r1, 1, 100 "add r3, r1"
```

## Advanced macro syntax

- optional parameters (`arg1=500`)
- variable length parameters (`varargs`)
- check if parameters are present (`.ifb`)
- conditionals (`.if`) and loops (`.loops`)
- macros can be recursive

Read the [docs](https://sourceware.org/binutils/docs-2.24/as/Macro.html)

## Macro gotchas

- hard to debug (can't step through)
- need to be careful with names (e.g., clashing labels)
- for [labels]({% link _lectures/03-memory-operations.md
  %}#labels-and-branching) as parameters, use `\()` as a separator, e.g.
  `\labelname\():` (it gets removed, but stops the assembler thinking the `:` is
  part of `labelname`)
- they might generate a lot of instructions
- the documentation kindof sucks

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Debugging with the disassembler"  %}

If you really need to see what instructions your macro is generating, **use the
disassembler**

Don't forget the `.type <func_name>, %function` and `.size <func_name>,
.-<func_name>` directives

{% include slides/impact.html %}

they look like functions in a higher-level language---**don't be fooled**

excessive macro use is dangerous territory... are you programming your microbit
or `as`?

{% include slides/background-image.html image="lectures/all/all-demo.jpg"
heading="Demo Time"  %}

- multiply a list of numbers together
- recursive factorial function with macros

{% endcomment %}

