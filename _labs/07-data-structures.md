---
title: "Week 7: data structures"
summary: "Creating arrays in assembly to communicate using morse code."
template_repo: https://gitlab.cecs.anu.edu.au/comp2300/2022/comp2300-2022-lab-pack-3
show_toc: true
image: assets/labs/lab-7/array-in-memory.png
---

{:.info-box} 
You've made it to the second half of the course! Hooray! Now that
you're here you should be prepared for a few more "gaps" in the lab where you
should figure things out yourself or with your colleagues. The tutors are
always here to help out with hints! 

## Outline

Before you attend this week's lab, make sure you remember how to load and store data to/from memory using `ldr` & `str` with different
   [addressing modes]({% link _lectures/05-functions.md %}#offset-load-and-store-with-write-back)

In this week's lab you will:

1. use a simple data structure for storing dot-dash "morse code" codepoints

2. store multiple morse codepoints in an array-like structure in memory

3. write a program to read an [ASCII](https://en.wikipedia.org/wiki/ASCII)
   string and "output" it as morse code blinks

## Introduction {#introduction}

[Morse code](https://en.wikipedia.org/wiki/Morse_code) is a simple communication
protocol which uses "dots" and "dashes" to represent the letters of the
alphabet.

{% include youtube.html id="wL2ED9-pACs" %}

The dots and dashes can be represented in different ways---as dots or lines on a
page, as short or long beeps coming out of a speaker, or [hidden in a song on
the radio to reach kidnap
victims](https://hackaday.com/2018/04/13/another-reason-to-learn-morse-code-kidnapping/),
or as short or long "blinks" of an LED on your microbit.

In this lab content the morse code will be represented visually using a sequence of `.`
(dot) and `_` (dash) characters, but by the end of the lab you'll be sending
morse code signals by blinking a red LED on your microbit in short (dot) and
long (dash) bursts. Here's the full morse alphabet (courtesy of
[Wikipedia](https://en.wikipedia.org/wiki/Morse_code)).

![Morse code alphabet]({% link assets/labs/lab-8/morse-code.svg %})

{:.talk-box}

Discuss with your neighbour---have you ever seen (or even used!) morse code
before? Where/when?

## Task 1: a LED utility library

Remember the setup code you wrote in the blinky lab? Now that you've got some more skills with
[functions]({% link _labs/06-functions.md %}) under your belt,
you can probably imagine how you might package up a lot of that
load-twiddle-store stuff into functions to make the code a bit more readable
(this was actually proposed as an extension exercise at the end of the [last
lab]({% link _labs/06-functions.md %}#led-library-extension)).

In fact, we have already written this library for you! You can find it in the `lib/led.S` file after you fork & clone the
[lab template]({{page.template_repo}}) from GitLab.

<div class="info-box" markdown="1">
Keen eyed students may have noticed that we have other new additions to the `lib` 
folder. 
- `lib/util.S`: A library containing some functions for basic bit-ops and other similar functionality that we don't want to have to write out each time we need them.
- `lib/symbols.S`: A library containing a bunch of definitions of commonly used memory locations and offsets for the microbit.

`lib/led.S` relies on both of these libraries, and you can use them too!
</div>

Have a read through the code in `led.S`---you should now be at the stage where
you can look at assembly code like this and at least get a *general* sense of
what it does and how it works. Here are a couple of things to pay particular
attention to as you look over it.

- The code uses `push` (to store the value in a register onto the stack, and
  *decrement* the stack pointer `sp`) and `pop` (to load the top value on the
  stack into a register and *increment* the stack pointer `sp`). You can do this
  in other ways (e.g. `stmdb pc!, {lr}`) but `push` and `pop` are convenient
  when you want to want to use `sp` to keep track of the stack. You can see the
  `push`/`pop` instructions in *Section A7.7* of your
  your
  [ARMv7 reference manual]({{site.armv7_architecture_ref_url}})

- Some (but not all) of the functions take arguments (described in the
  comments), so before you call these functions make sure you've got the right
  values in these registers to pass arguments to the functions.

- The `.global init_leds, ...` line is necessary
  because you're putting the code above into a separate file to the one where
  the rest of your program will be (`src/main.S`). By default, when you hit
  build/run the assembler will only look for labels in the current file, so if
  you try and branch `bl` to one of these functions from `main.S` it'll complain
  that the label doesn't exist. By marking these functions as `.global`, it
  means that the assembler will look everywhere for them, even if they're in a
  different source file to the one they're being called from. Finally, the
  `.global` labels in a file are good clue about which functions are useful to
  call from your own code. Take a moment to have a look over what the various `lib` 
  files offer for you.
- You may notice things like `ldr r0, =ADR_P0` and wonder why it's not a number after `=`.
  `ADR_P0` is a symbol declared in `lib/symbols.S` using `.set` directive.
  This is just a convenient way for naming some constant values.

{:.talk-box}

Discuss with your neighbour---what are the advantages of using the functions in
the LED library? Are there any disadvantages?

Your task in exercise 1 is to use the functions from the `led.S` library to
write three new **functions** in your `main.S` file:

1. `blink_dot`, which blinks an led (or leds) for a short period of time (say `0x400000`
   cycles---we'll call this the "dot length") and then pauses (delays) for one
   dot length before returning

2. `blink_dash`, which blinks the led for *three* times the dot and then pauses
   (delays) for one dot length before returning

3. `blink_space`, which doesn't blink an LED, but pauses (delays) for *seven*
   dot lengths before returning

Each of these function calls will contain nested function calls (i.e. calls to
`delay` or other functions) so make sure you use the stack to preserve the link
and argument registers (e.g. with `push` and `pop`) when necessary.

{:.push-box}

Once you've written those functions, write a `main` loop which blinks out the
sequence `... _ _ _ ` on an endless repeat. 
Copy the code into `tasks/task-1.S` then commit and push your changes to GitLab.

## Task 2: a morse data structure

Now it's time for the actual morse code part. In morse code, each letter (also
called a **codepoint**) is encoded using *up to* five dots/dashes. For example,
the codepoint for the letter B has 4 dots/dashes: `_...` while the codepoint for
the letter E is just a single dot `.`. You could store this in memory in several
different ways, but one way to do it is to use a data structure which looks like
this:

![Morse data structure]({% link assets/labs/lab-8/morse-data-structure.png %}){:style="width:65%;"}

Each "slot" in the data structure is one full word (32 bits/4 bytes), so the
total size of the codepoint data structure is 4*6=24 bytes. The first word is an
integer which gives the total number of dots/dashes in the codepoint, while the
remaining 5 boxes contain either a 0 (for a dot) or a 1 (for a dash).

{:.think-box}

What will the address offsets for the different slots be? Remember that each box
is one 32-bit word in size, but that memory addresses go up in **bytes** (8 bits
= 1 byte).

Here are a couple of examples... codepoint B (`_...`):

![Morse data B]({% link assets/labs/lab-8/morse-data-structure-B.png %}){:style="width:65%;"}

and codepoint E (`.`)

![Morse data E]({% link assets/labs/lab-8/morse-data-structure-E.png %}){:style="width:65%;"}

In each case, the "end" slots in the data structure might be unused, e.g. if the
codepoint only has 2 dots/dashes then the final 3 slots will be unused, and it
doesn't matter if they're 0 or 1. These slots are coloured a darker grey in the
diagrams. (If this inefficiency bums you out, you'll get a chance to fix it in the 
[Extra Tasks](#extras) section after the main exercises.

Your job for Task 2 is to write a function which takes (as a parameter) the
base address (i.e. the address of the first slot) of one of these morse data
structures and "blinks out" the codepoint using an LED.

As a hint, here are the steps to follow:

1. pick any character from the morse code table at the [start of this lab
   content](#introduction)

2. store that character in memory (i.e. use the `.data` section) using the morse
   codepoint data structure shown in the pictures above

3. write a `blink_codepoint` function which:
   - takes the base address of the data structure as an argument in `r0`
   - reads the "size" of the codepoint from the first slot
   - using that size information, loops over the other slots to blink out the
     dots/dashes for that codepoint (use the `blink_dot` and `blink_dash`
     functions you wrote earlier)
   - when it's finished all the dots/dashes for the codepoint, delays for 3x dot
     length (the gap between characters)

Since the `blink_codepoint` function will call a bunch of other functions, make
sure you use the stack to keep track of values you care about. If your program's
not working properly, make sure you're not relying on something staying in `r0`
(or any of the scratch registers) between function calls!

{:.think-box}

When you start to use functions, the usefulness of the **step over** vs **step
in** buttons in the debugger toolbar starts to become clear. When the debugger
is paused at a function call (i.e. a `bl` instruction) then step **over** will
branch, do the things without pausing, and then pause when the function
*returns*, while step **in** will follow the branch, allowing you to step
through the called function as well. Sometimes you want to do one, sometimes you
want to do the other, so it's useful to have both and to choose the right one
for the job.<br>
If you're confused about what this section is referring to, ask your neighbour 
/ tutor to point them out to you.

{:.push-box}

Write a program which uses the morse data structure and your `blink_codepoint`
function to blink out the first character of your name on infinite repeat.
Copy the code into `tasks/task-2.S` then commit and push your changes to GitLab.

## Task 3: [ASCII](https://en.wikipedia.org/wiki/ASCII) to morse conversion

The final part of today's lab is to bring it all together to write a program
which takes an input string (i.e. a sequence of
[ASCII](https://en.wikipedia.org/wiki/ASCII) characters) and blinks out the
morse code for that string.

To save you the trouble of writing out the full morse code alphabet, you can
copy-paste the following code into your editor. It also includes a place to 
put the input string (using the `.asciz` directive).

``` ARM
.data
input_string:
.asciz "INPUT STRING"

@ to make sure our table starts on a word boundary
.align 2

@ Each entry in the table is 6 words long
@ - The first word is the number of dots and dashes for this entry
@ - The next 5 words are 0 for a dot, 1 for a dash, or padding (value doesn't matter)
@
@ E.g., 'G' is dash-dash-dot. There are 2 extra words to pad the entry size to 6 words
morse_table:
  .word 2, 0, 1, 0, 0, 0 @ A
  .word 4, 1, 0, 0, 0, 0 @ B
  .word 4, 1, 0, 1, 0, 0 @ C
  .word 3, 1, 0, 0, 0, 0 @ D
  .word 1, 0, 0, 0, 0, 0 @ E
  .word 4, 0, 0, 1, 0, 0 @ F
  .word 3, 1, 1, 0, 0, 0 @ G
  .word 4, 0, 0, 0, 0, 0 @ H
  .word 2, 0, 0, 0, 0, 0 @ I
  .word 4, 0, 1, 1, 1, 0 @ J
  .word 3, 1, 0, 1, 0, 0 @ K
  .word 4, 0, 1, 0, 0, 0 @ L
  .word 2, 1, 1, 0, 0, 0 @ M
  .word 2, 1, 0, 0, 0, 0 @ N
  .word 3, 1, 1, 1, 0, 0 @ O
  .word 4, 0, 1, 1, 0, 0 @ P
  .word 4, 1, 1, 0, 1, 0 @ Q
  .word 3, 0, 1, 0, 0, 0 @ R
  .word 3, 0, 0, 0, 0, 0 @ S
  .word 1, 1, 0, 0, 0, 0 @ T
  .word 3, 0, 0, 1, 0, 0 @ U
  .word 4, 0, 0, 0, 1, 0 @ V
  .word 3, 0, 1, 1, 0, 0 @ W
  .word 4, 1, 0, 0, 1, 0 @ X
  .word 4, 1, 0, 1, 1, 0 @ Y
  .word 4, 1, 1, 0, 0, 0 @ Z
```

The main addition you'll need to make to your program to complete this exercise
is a `morse_table_index` function which takes a single
[ASCII](https://en.wikipedia.org/wiki/ASCII) character as input, and returns the
base address of the corresponding codepoint data structure for that character
(which you can then pass to your `blink_codepoint` function). 

For example, the letter P is [ASCII](https://en.wikipedia.org/wiki/ASCII) code `80`, 
and the offset of the P codepoint data structure in the table above is 15 (P is 
the 16th letter) times 24 (size of each codepoint data structure) equals 360 bytes.

So, your main program must:

1. loop over the characters in the input string (`ldrb` will be useful here)
2. if the character is `0`, you're done
3. if the character is not `0`:
   - calculate the address of the morse data structure for that character
   - call the `blink_codepoint` function with that base address to blink out the
     character
   - jump back to the top of the loop and repeat for the next character

If you like, you can modify your program so that any non-capital letter (i.e.
[ASCII](https://en.wikipedia.org/wiki/ASCII) value not between 65 and 90
inclusive) will get treated as a space (`blink_space`).

{:.push-box}

Write a program which blinks out **your name** in morse code. 
Copy the code into `tasks/task-3.S` then commit and push your changes to GitLab.

## Extra Tasks {#extras}

There are many ways you can extend your morse program. Here are a few things to try (pick which
ones interest you---you don't have to do them in order):

1. can you modify your program to accept both lowercase and uppercase
   [ASCII](https://en.wikipedia.org/wiki/ASCII) input?
2. the current `morse_table` doesn't include the numbers 0 to 9; can you modify
   your program to handle these as well?
3. can you remove the need for the number of dots/dashes in each table entry
   altogether?
4. this is **far** from the most space-efficient way to store the morse
   codepoints, can you implement a better scheme?

