---
title: Functions
summary: Finally, we have functions!
permalink: /lectures/week-5/
image: assets/lectures/week-5/jeremy-cai-1169-unsplash.jpg
---

{% include slides/title.html %}

{:.center}
# Week 5: Functions

## Outline

- [why functions?](#why-functions)
- [calling conventions](#calling-conventions)
- [the stack](#stack)

{% include slides/background-image.html image="lectures/all/all-bigpicture.jpg"  %}

because copy-pasting **sucks**

## Function gallery

``` python
def plus_1(x):
  return x + 1
```
``` java
public String plusOne(int x) {
  return x + 1;
}
```
```scheme
(define plus-1
  (lambda (x)
    (+ x 1)))
```

{% include slides/impact.html %}

first, some **analogies**

{% include slides/background-image.html
           image="lectures/week-5/unsplash-tian-kuan.jpg"
           heading="Good: pipe (input & output)"  %}

or "black box"

{% include slides/background-image.html
           image="lectures/week-5/jeremy-cai-1169-unsplash.jpg"
           heading="Better: there, and back again"  %}

{% include slides/impact.html %}

$f(a, b) = \int_a^b g(x) \mathrm{d}x$

## A function call

{:.stretch}
![program control flow during a function call]({% link assets/lectures/week-5/function-execution-flow-abstract.png %})

{% include slides/talk.html %}

Can we do this with branch (`b`)?

## Open questions

- how does the program know where to come back to?
- how do we pass information (i.e., parameters) in?
- how do we get information (i.e., return values) back?
- can we have some "scribble paper"?

{:.fragment}

*note*: parameters/arguments - different words for the same thing

{% include slides/background-image.html
           image="lectures/week-5/forest.jpg"
           heading="Remember <a href=\"https://en.wikipedia.org/wiki/Hansel_and_Gretel\">Hansel and Gretel?</a>"  %}

{:.fragment}

They *try* and leave a trail of breadcrumbs behind them so they can find their
way back.

{:.center}
# `bl` and `bx` {#bl-and-bx}

## `bl`: branch with link

When the branch **with link** instruction (`bl`) is executed, the address of the
next instruction (i.e., the one *after* the `bl` instruction) is placed in a
specific register

{% comment %}
<!-- You've seen this already in [assignment 1]({% link _deliverables/01-synth.md %}) -->
{% endcomment %}

## `lr`: the "link register" {#link-register}

Just like `r15` (`pc`), `r14` also has a special meaning---it's the *link
register*

## `bx`: branch and exchange {#bx-branch-and-exchange}

The `lr` might contain the address of the instruction we want to go back to, but
how do we actually **return** there?

The branch and exchange (`bx`) instruction branches not to a static label, but
to an address in a register

{% include slides/background-image.html
           image="lectures/all/all-history.jpg"
           heading="Don't worry too much about the \"exchange\" part"  %}

The ["exchange"](https://developer.arm.com/documentation/dui0040/d/Cabdcdci) part means that `bx` can switch the CPU between "ARM" and "Thumb" execution modes.

We **only ever** use Thumb mode.

The way this work is tricky. `bx rN` says "branch to the address located in `rN`".

Code address are aligned to half-words, so the lowest bit of the memory address is always zero. This lowest bit is used by `bx` to change execution mode.

## Putting it all together

![bl sets the link register]({% link assets/lectures/week-5/plus-1-with-lr.png %})

## What about conditional branches?

Both of these new branch instructions (`bl`) and (`bx`) can't be used
conditionally (e.g. with an `eq` suffix) in the ARMv7-M ISA your microbit uses

You can get around this with [IT blocks]({% link _lectures/04-control-flow.md %}/#/it-blocks-extension) if you want, or you can use regular conditional branch (e.g., `bgt`)

{:.fragment}
``` arm
  cmp r0, #8
  IT eq
  bleq add_one
```

## Function template

``` arm
@ use the type directive to tell the assembler
@ that fn_name is a function (optional)
  .type fn_name, %function

fn_name: @ just a normal label
  @
  @ the body of the function
  @
  bx lr  @ to go back
```

{% include slides/background-image.html
           image="lectures/all/all-bigpicture.jpg"
           heading="Functions are simple"  %}

{:.fragment}
use a `bl <label>` to branch **with link**

{:.fragment}
use a `bx lr` instruction to come back

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Analogy Time: RPG quests"  %}

{:.center}
# Nested Functions {#nested-functions}

## Nested functions

![nested function execution flow]({% link assets/lectures/week-5/nested-functions.png %})

did the breadcrumbs thing **work** for [Hansel &
Gretel](https://en.wikipedia.org/wiki/Hansel_and_Gretel)?

## Nested `Plus_1` (broken!)

![nested Plus_1]({% link assets/lectures/week-5/nested-plus-1.png %})

{% include slides/talk.html %}

How can we stop the "first" return address getting clobbered?

{:.fragment}
Sure, store it to memory, but *where*?

## Nested `Plus_1` (fixed!)

![nested Plus_1 stores the link register to memory]({% link assets/lectures/week-5/nested-plus-1-with-sp.png %})

*this will work in this case, but there's still a slight problem with the use of
`sp` here---can you spot it?*

## The stack (sneak peek)

One final new register: the stack pointer (`sp`, but it's actually `r13`)

By convention: the value of the `sp` is an address in the SRAM region of the
address space (like with the `.data section`)

basically, it's memory you can use **to get things done**

{:.fragment}

We'll return to the stack [later](#stack)...

{:.center}
# Calling conventions {#calling-conventions}

## Open questions

- ~~how does the program know where to come back to?~~
- how do we pass information (i.e., parameters) in?
- how do we get information (i.e., return values) back?
- can we have some "scribble paper"?

{% include slides/impact.html %}

assume *x* is in `r0`...

{% include slides/background-image.html
           image="lectures/week-5/rawpixel-com-567016-unsplash.jpg"
           heading="We need a convention"  %}

an agreed-upon plan for where to find the input(s) and where to leave the result

## Calling convention definition

This is called a **calling convention** (CC)

It's a contract between the caller (the code which makes the function call with
`bl <label>`) and the callee (the code between `<label>` and the `bx lr`
instruction)

## What does the CC specify?

- where to look for the parameter values (the *inputs*)
- where to leave the *outputs*
- which registers to touch, which to leave alone

{% include slides/talk.html %}

Which calling convention does this function use?

``` c
int do_all_the_things(int how_many_things){
  // lies! does *none* of the things
  return 0;
}
```

{:.fragment}

**trick** question!

{% include slides/background-image.html
           image="lectures/all/all-bigpicture.jpg"
           heading="There are many possible CCs"  %}

It doesn't matter which calling convention you use (as we'll see), as long as
the caller and the callee use the same convention

## CC example

Do these two two `Plus_1` functions both give the right answer (i.e., `x+1`)?
What's the difference?

``` arm
Plus_1:
  add r0, r0, 1
  bx lr
```
``` arm
Plus_1:
  add r5, r2, 1
  bx lr
```

## AAPCS {#aapcs}

The [ARMv7 Architecture Procedure Call Standard]({{ site.armv7_procedure_call_standard_url | relative_url }}) is the convention we'll
(try to) adhere to in programming our microbits.

The full standard is quite detailed, but the general summary is:

- `r0`-`r3` are the parameter and scratch registers
- `r0`-`r1` are also the result registers
- `r4`-`r11` are callee-save registers
- `r12`-`r15` are special registers (`ip`, `sp`, `lr`, `pc`)

## What are scratch registers?

`r0`-`r3` are "scratch" registers, which means that the caller can freely use
them (and not worry about messing anything up)

These are also called "caller-save" registers, because if the caller wants to
preserve the values in them they need to save them somewhere

{:.center}
# Parameters and Return Values {#parameters-and-return}

## Different ways to get data in/out

Do *these* two two `Plus_1` functions both give the right answer (i.e., `x+1`)?
What's the difference?

``` arm
@ pass by value
Plus_1:
  add r0, 1
bx lr
```
``` arm
@ pass by reference
Plus_1:
  ldr r3, [sp]
  add r3, 1
  str r3, [sp]
bx lr
```

## Pass-by-value vs pass-by-reference

Two different approaches to passing parameters and return values in and out of a
function.

- **pass by value** makes a "copy" (*can* mess with it without affecting the caller)
- **pass by reference** gives the callee access to the same bits as the caller

pros and cons to both, depends on the nature of the things being passed in and out

in general, data needs to **live** in memory (registers are not for long-term storage)

{:.center}
# The stack {#stack}

## Open questions

- ~~how does the program know where to come back to?~~
- ~~how do we pass information (i.e., parameters) in?~~
- ~~how do we get information (i.e., return values) back?~~
- can we have some "scribble paper"?

## What about local variables?

``` javascript
function doStuff(a, b){
  let c = a+b;
  let d = a-b;
  let e = a*b;

  // function body here

}
```

{:.fragment}

maybe put `c`, `d` and `e` in more registers?

## What about local variables?

``` javascript
function doArrayStuff(a, b){

  let person = {
                 name: "Esmerelda",
                 age: 54,
                 pets: ["rex", "daisy"]
               };
  let junk = new Array(1000);

  // function body here

}
```

{:.fragment}

there aren't enough registers this time

## The stack pointer (revisited)

The stack pointer (`sp`) contains a *memory address*, and this can be used by
functions for various purposes:
- "saving" values in registers which would otherwise be overwritten (e.g. `lr`)
- passing parameters/returning values
- temporary variables, e.g. "scribble paper"

It's called the stack because (in general) it's used like a first-in-last-out
(FILO) [stack "data
structure"](https://en.wikipedia.org/wiki/Stack_(abstract_data_type)) with two
main *operations*: *push* a value on to the stack, and *pop* a value off the
stack

{% include slides/impact.html %}

but only if **you** follow the rules

## Setting up the stack

Look at the first instruction executed in the startup file:

```arm
ldr   sp, =_estack
```

Loads a value (`_estack`) into `sp` using the [ldr
pseudo-instruction]({% link _lectures/04-control-flow.md
%}#ldr-pseudo-instruction)

The exact value of `_estack` comes from the [linker file]({{site.baseurl}}{%
link _lectures/03-memory-operations.md %}#memory-segmentation) (line 34):

```c
/* Highest address of the user mode stack */
_estack = 0x20018000;    /* end of RAM */
```

## Stack pointer in memory

{:.stretch}
![Stack pointer memory]({% link assets/lectures/week-5/stack-pointer-memory.png %})

## More about the stack pointer

- the value (remember, it's a memory address) in `sp` changes as your program
  runs
- `sp` can either point to the last "used" address used (full stack) or the
  first "unused" one (empty stack)
- you (usually) don't care about the absolute `sp` address, because you use it
  primarily for offset (or relative) addressing
- stack can "grow" up (ascending stack) or down (descending stack)
- in ARM Cortex-M (e.g., your microbit) the convention is to use a **full
  descending** stack starting at the highest address in the [address
  space]({% link _lectures/03-memory-operations.md
  %}#memory-address-space) which points to actual RAM


{:.center}
# Stack Instructions {#stack-instructions}

## Using the stack

Just use `sp` like any other register containing a memory address:

``` arm
mov r2, 0xfe

@ push the value in r2 onto the stack
str r2, [sp, -4]
sub sp, sp, 4

@ do some stuff here

@ pop the value from the "top" of the stack into r3
ldr r3, [sp]
add sp, sp, 4
```

## Push, illustrated

{:.stretch}
![stack push example]({% link assets/lectures/week-5/stack-push-example.png %})

## Pop, illustrated

{:.stretch}
![stack pop example]({% link assets/lectures/week-5/stack-pop-example.png %})

{% include slides/impact.html %}

the "missing" values in the diagrams aren't empty, just **unknown**

## Offset load and store with write-back {#offset-load-and-store-with-write-back}

`ldr`/`str` with offset can write the new address (base + offset) back to the
address register (in this case `r1`) in two different ways

- pre-offset: update the index register *before* doing the store (or load)
``` arm
@ r1 := r1 + 4
str r0, [r1, 4]! @ note the "!"
```

- post-offset: update the index register *after* doing the load (or store)
``` arm
@ r1 := r1 - 8
ldr r0, [r1], -8 @ no "!" for post-offset
```

## Pre-offset addressing

{:.stretch}
![load/store pre-offset]({% link assets/lectures/week-5/address-pre-offset.png %})

## Post-offset addressing

{:.stretch}
![load/store post-offset]({% link assets/lectures/week-5/address-post-offset.png %})

## Stack pointer example (again)

Pre/post offset addressing means fewer instructions

``` arm
mov r2, 0xbc

@ push
str r2, [sp, -4]!

@ do stuff...

@pop
ldr r3, [sp], 4
```

## `push` and `pop` instructions

Doing this with the stack pointer (`sp`) as the base address is so common that
the ISA even has specific `push` and `pop` instructions

``` arm
mov r2, 0xfe

@ gives same result as `str r2, [sp, -4]!`
push {r2}

@ do stuff...

@ gives same result as `ldr r3, [sp], 4`
pop {r3}
```

{:.fragment}

note that the `sp` base address is implicit

## Register list syntax

There was one other difference in the `push` and `pop` syntax: the brace (`{`
`}`) syntax around the register name

Certain instructions take **register lists**---they can apply to multiple
registers at once, e.g.

``` arm
@ push r0, r1, r2, r9 to stack, decrement sp by 4*4=16
push {r0-r2,r9}

@ pop 4 words from the stack into r0, r1, r2, r9
pop {r0-r2,r9}
```

## `push` instruction encoding

from A7.7.99 of the [reference manual]({% link _resources/04-books-links.md %}#armv7-reference)

{:.stretch}
![Push instruction encoding]({% link assets/lectures/week-5/push-instruction-encoding.png %})

## Load/store multiple

There are also instructions for loading/storing multiple words using *any*
register as the base register

- `ldmdb` **l**oad **m**ultiple, **d**ecrement **b**efore
- `ldmia` **l**oad **m**ultiple, **i**ncrement **a**fter
- `stmdb` **s**tore **m**ultiple, **d**ecrement **b**efore
- `stmia` **s**tore **m**ultiple, **i**ncrement **a**fter

But if `sp` is the base address, then `push` and `pop` are probably easier to
read

{:.fragment}

be careful about the order!

{% include slides/background-image.html
           image="lectures/all/all-reading.jpg"
           heading="Further reading"  %}

<http://www.davespace.co.uk/arm/introduction-to-arm/stack.html>

Ben Eater - [What is a stack and how does it work? (YouTube)](https://youtu.be/xBjQVxVxOxc)

Plantz - [Passing Data in Registers](http://bob.cs.sonoma.edu/IntroCompOrg-RPi/sec-reg-use.html)

Plantz - [The Stack](http://bob.cs.sonoma.edu/IntroCompOrg-RPi/sec-stack.html)

{:.center}
# Functions and Stack Frames {#functions-and-stack-frames}

## Function prologue & epilogue {#function-prologue-epilogue}

The beginning (or **prologue**) of a function should:
- store (to the stack) `lr` and any other values (e.g. parameters) in registers
  which will clobbered during the execution of the function (remember the
  [AAPCS](#aapcs))
- make room for any temporary variables by decreasing the stack pointer

## Function prologue & epilogue {#function-epilogue}

The end (or **epilogue**) of a function should:
- re-increment the stack pointer to free up the room for temporary variables
- restore all the stored values back to the registers (e.g. `lr`)
- make sure the return value is left in the right place
- restore the stack state (e.g. put the `sp` back where it was)

{% include slides/background-image.html
           image="lectures/week-5/jens-johnsson-471362-unsplash.jpg"
           heading="Share house kitchen"  %}

## Function prologue & epilogue example

{: style="font-size:0.8em;"}

``` arm
  .type my_func, %function

@ assume three parameters in r0-r2

my_func:
  @ prologue
  push {r0-r2} @ sp decreases by 12
  push {lr}    @ sp decreases by 4
  
  @ body: do stuff, leave "return value" in r3

  @ epilogue
  mov r0, r3 @ leave return value in the right place
  pop {lr} @ sp increases by 4
  add sp, sp, 12  @ balance out the initial "push"
  bx lr
```

## Function stack frame

{:.stretch}
![Stack frame diagram]({% link assets/lectures/week-5/stack-frame.png %})

## Nested function calls

``` arm
outer_fn:
  push {r0,lr}
  bl middle_fn
  pop {r0,lr}
  bx lr

middle_fn:
  push {r0,lr}
  bl inner_fn
  pop {r0,lr}
  bx lr

inner_fn:
  @ do inner function stuff
  bx lr
```

## Nested stack frames

{:.stretch}
![Nested stack frames]({% link assets/lectures/week-5/nested-stack-frames.png %})

{% include slides/impact.html %}

the `sp` "zippers" up and down as the program executes

## There's lots more to say...

- there's more you *can* put in your stack frame (e.g. frame pointer `fp`)
- ARMv7/AAPCS is pretty register-heavy (other ISA/CCs use the stack more, e.g.
  for parameter passing and return addresses)
- an optimizing compiler will almost certainly not generate the code you expect
- recursion is an interesting case (wait till lab 7)

{% include slides/background-image.html
           image="lectures/all/all-bigpicture.jpg"
           heading="These are all <em>conventions</em>"  %}

It's the programmer's job to adhere to them: the operating systems programmer,
the compiler programmer, the library programmer, the application programmer, ...

For bare-metal assembly programming, you're **all** of those

{% include slides/background-image.html
           image="lectures/all/all-questions.jpg"
           heading="Questions?"  %}
