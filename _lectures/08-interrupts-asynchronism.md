---
title: Interrupts and Asynchronism
summary: Connecting a computer to the world
permalink: /lectures/week-8/
image: assets/lectures/week-8/tng-enterprise.jpg
---

{% include slides/title.html %}

## Interrupts

- Interrupts: what, when and why?
- What happens during an interrupt?
- How does it work on your microbit?
- How is this related to parallel computing?

{% include slides/background-image.html
           image="lectures/all/all-todos.jpg"
           heading="Admin Time"  %}

You've now completed 45% of the assessment for COMP2300/6300!

midsem results, eta end of week 9.

assignment 2 coming out this week --- a new challenge for you!

week 9 is an assignment pre-submission week!

don't forget to **go to your labs!!**

{% include slides/background-image.html
           image="assessments/cosmoh-love-unlm6Fxxvjw-unsplash.jpg"
           heading="Assignment 2: Digital Pet!"  %}

This is going to be fun!


## What is an interrupt? {#what-is-interrupt}

- Do you check you messages **only** at certain times of day?
- If your phone rings, do you answer it?

## On your microbit...

- CPU is running its sequence of machine instructions
- How is it going to handle communications with all the other devices on the board?


<!-- analogy time, star trek -->
{% include slides/background-image.html
           image="lectures/week-8/tng-enterprise.jpg"
           heading="Imagine your microbit is a starship..." %}

{% include slides/background-image.html
           image="lectures/week-8/tng-bridge.jpg"
           heading="Every starship has a captain" %}

{:.fragment}
(This is assumed knowledge)

{% include slides/background-image.html
           image="lectures/week-8/tng-polling.jpg"
           bgsize="contain" %}

{% include slides/background-image.html
           image="lectures/week-8/tng-interrupt.jpg" 
           bgsize="contain" %}

{% include slides/impact.html %}

polling vs interrupts

## Idea 1: Polling!

- Check each external device at a certain time. 
- We will need to do this regularly.

{: style="font-size:0.8em;"}
``` arm
  main: @ do some work!
  bl check_keyboard
  bl check_mouse
  bl check_camera
  bl do_some_actual_work @ yeah!
  bl check_usb_1
  bl check_temperature
  bl do_some_other_work @ woo!
  bl check_usb_2
  bl check_network
  b main
```

<!-- - Maximal latencies can be calculated straight forward. -->
<!-- - Simplicity of design (with small number of devices). -->
<!-- - Fastest option with small number of devices (like: one). -->
<!-- - All devices will need to wait their turn ... even if this device is the only one with new data! -->
<!-- - The “main” program transforms into one large loop which can be hard to handle in terms of scalable program design. -->
<!-- - Events or data can be missed. -->

## Idea 2: Interrupts

Change our processor architecture to allow an external part to **"interrupt"** our fetch-decode-execute cycle!

Sequence of code is interrupted, and the CPU automatically branches to an "interrupt handler".

<!-- One or multiple lines wired directly into the sequencer -->
<!-- Required for: -->
<!-- Pre-emptive scheduling, Timer driven actions, Transient hardware interactions, ... -->
<!-- Usually preceded by an external logic (“interrupt controller”) which accumulates and encodes all external requests. -->
<!-- On interrupt (if unmasked): -->
<!-- CPU stops normal sequencer flow. -->
<!-- Lookup of interrupt handler’s address -->
<!-- Current PC and state pushed onto stack. -->
<!-- PC set to interrupt handler. -->

{: style="font-size:0.8em;"}
``` arm
  main: @ do some work!
  bl do_some_actual_work @ yeah!
  bl do_some_other_work @ woo!
  b main

  keyboard_interrupt_handler:
  @ do what's needed to check the keyboard
  bx lr
```

{:.fragment}
But how does this work in practice? (we'll find out in a minute...)

## Interrupts: CPU Perspective

{:.stretch}

![a CPU view of an interrupt]({% link assets/lectures/week-8/interrupt-cpu.jpg %})

## Polling vs Interrupts

**Polling:** Simple to implement, easy to calculate latency, fastest for small number of devices (e.g., one)

_BUT_: Devices need to wait their turn, events/data could be missed, `main` can get unmanageably long!

**Interrupts**: Enables pre-emptive scheduling, timer driven actions, transient hardware interactions, etc...

_BUT_: A little bit more work to set up, requires external hardware ("interrupt controller") to encode external requests.

{% include slides/background-image.html
  image="lectures/all/all-lost.jpg"
  heading="Why is this important?" %}

So far, your microbit has been running like clockwork (fetch-decode-execute, fetch-decode-execute, etc).

Now, an interrupt could happen at **any time**.

{% include slides/talk.html %}

"An interrupt could happen at **any time**."

What does this mean for your assumptions as a programmer?

{% include slides/background-image.html
  image="lectures/all/all-bigpicture.jpg"
  heading="Interrupts - Expecting the Unexpected" %}

Our computers **need** to respond to external events, as well as errors!

Interrupts happen **all the time** (keyboard?)

Breaks our assumptions about fetch-decode-execute cycle, need to follow a process to save our **context**, and get back to it later.

{:.center}
# How does an interrupt work? {#anatomy-of-an-interrupt}

## How is this going to work?

- How should we store the interrupt code?
- How does the microbit know how to get there?

## Pre-Interrupt

![pre-interrupt]({% link assets/lectures/week-8/interrupt-story-0-pre.png %}){:style="width:45%; float:left;"}

Everything is fine!

fetch-decode-execute ticking away!

## Interrupt occurs!!

![pre-interrupt]({% link assets/lectures/week-8/interrupt-story-1-int.png %}){:style="width:45%; float:left;"}

Save PC and flags on the stack (_the CPU hardware does this for you!!_)

Now the PC is inside an **interrupt handler** (a function that has been set up previously to look after this interrupt)

The link register `lr` has been set up with a **special value!**


## Run the handler code

![pre-interrupt]({% link assets/lectures/week-8/interrupt-story-2-hand.png %}){:style="width:45%; float:left;"}

push registers

declare local variables

..do some I/O..

..run some time critical code..


## Clean up after the handler

![pre-interrupt]({% link assets/lectures/week-8/interrupt-story-3-clean.png %}){:style="width:45%; float:left;"}

remove local variables

pop registers

## Return from Interrupt

![pre-interrupt]({% link assets/lectures/week-8/interrupt-story-4-end.png %}){:style="width:45%; float:left;"}

**Return from interrupt** (`bx lr`)

The "special" `lr` gets the CPU to put everything back the way it was! (Clever!)

## Interrupt Timeline...

{: style="font-size:0.8em;"}
- Save PC and flags on the stack (_the CPU hardware does this for you!!_)
- Now the PC is inside an **interrupt handler** (a function that has been set up previously to look after this interrupt)
- The link register `lr` has been set up with a **special value!**
-  Do our normal function things:
  - push registers
  - declare local variables
  - ..do some I/O..
  - ..run some time critical code..
  - remove local variables
  - pop registers
- **Return from interrupt** (`bx lr`)

## Things to consider

- Interrupt handler code can also be interrupted!
- Which interrupts are more important? (we have **priorities** to handle this!)
- Can you overrun a stack with interrupt handlers?
- Can we have a "do not disturb" sign?

{:.stretch}

![multiple interrupts]({% link assets/lectures/week-8/multi-interrupt-timeline.png %})

{% include slides/background-image.html
	image="lectures/all/all-bigpicture.jpg"
	heading="Interrupt Handler is a Function" %}

You get to write it! (more on that later...)

But you don't get to choose _when_ it runs!

{:.center}
# Interrupts in Practice

{% include slides/impact.html %}

You've probably experienced an interrupt (exception) already!

{:.fragment}

What about "Usage Fault"?

## Guaranteed interrupt in two clock cycles

```arm
ldr r0, =0x20000000
bx r0
```

N.B., the above code is broken on purpose! Your microbit will end up in the "Default_Handler"

## How do we configure an interrupt?

1. Need to enable the interrupt.
2. Need to define the handler function.
3. Need to configure hardware (if using MCU features).

## Where are interrupt vectors defined?

Have a look in `startup.S`:

```arm
.section .rodata.vtable @ (r)ead-(o)nly(data), the .vtable suffix is just a way to uniquely identify this section in the linker
.word _stack_end
.word Reset_Handler
.word NonMaskableInt_Handler
.word HardFault_Handler
.word MemManage_Handler
  ...
```

All the interrupt vectors are named here, and linked to a default handler.

## How do we take over an interrupt handler?

Need to redefine one of the handler functions. E.g., for `GPIOTE_IRQHandler`:

```arm
.global GPIOTE_IRQHandler
.type GPIOTE_IRQHandler, %function
GPIOTE_IRQHandler:
  @ do some important stuff!
  nop
  bx lr
.size GPIOTE_IRQHandler, .-GPIOTE_IRQHandler
```

{% include slides/impact.html %}

So I want to use the **buttons**...

{:.fragment}
Isn't that similar to activating the LEDs?

## A map to the buttons... 

The microbit's buttons are connected to pin `P0.14` (A) and `P0.23` (B).

{:.stretch}
![A map from P0.14 to the processor core.]({% link assets/lectures/week-8/interrupt-from-PA0-to-core.png %})

## Connecting it all up

We need to configure the `GPIOTE` module to listen on `P0.14`, _and_ configure the NVIC to make this happen. This is a little bit fussy!

1. Configure the GPIOTE channel 0 to to be in “event” mode, associate with GPIO pin 14 and port 0 (the pin and port of the A button), and to to listen for low-to-high voltage events. 
2. Enable interrupts for events from GPTIOTE channel 0. 
3. Enable the GPIOTE interrupt in the NVIC, its ID number is “6”. For this you need to set bit “6” in the NVIC’s Interrupt Set Enable Register. 
4. Implement a function called GPIOTE_IRQHandler and make sure you have the .global GPIOTE_IRQHandler directive.

Let's do it.

## Button A Interrupt Config

{: style="font-size:0.6em;"}
```arm
@ 1: Configure GPIOTE_CONFIG[0] (Section 6.9.4.8 in nRF52833 reference manual)
  @ mode = 1 (event), pin = 14 and port = 0 (P0.14 = Button A), polarity = 1 (LoToHi)
  ldr r0, =GPIOTE_CONFIG0
  ldr r1, =(1 | 14 << 8 | 0 << 13 | 1 << 16)
  str r1, [r0]

@ 2: Enable Interrupt for GPIOTE[0] (id = 6) (S6.9.4.6 in nRF52833 reference manual)
  ldr r0, =GPIOTE_INTENSET
  ldr r1, =0b1
  str r1, [r0]

@ 3: enable GPIOTE (interrupt #6 = NVIC_GPIOTE_ID) in NVIC_ISER0 (B3.4.4 in ARMv7-M Reference Manual)
  ldr r0, =NVIC_ISER0
  ldr r1, =(1 << 6) @ set the 6th bit since NVIC_GPIOTE_ID = 6
  str r1, [r0]
```

## Button A Interrupt Handler

```arm
.global GPIOTE_IRQHandler
.type GPIOTE_IRQHandler, %function
GPIOTE_IRQHandler:
  @ interrupt code goes here
  @ clear event
  ldr r0, =GPIOTE_EVENTS_IN0
  ldr r1, =0
  str r1, [r0]
  bx lr
.size GPIOTE_IRQHandler, .-GPIOTE_IRQHandler
```

{% include slides/background-image.html
           image="lectures/all/cpm-stones.jpg"
           heading="Interrupt archaeology"  %}

What about the interrupt handler function and the [AAPCS]({% link _lectures/05-functions.md %}#aapcs)?

[link register]({% link _lectures/05-functions.md %}#link-register) `lr`?

[status register]({% link _lectures/02-alu-operations.md %}#condition-flags) `xPSR`?

*caller-save registers* (`r0`-`r3`)?

{:.fragment}

let's look at an interrupt handler and do some digging...

{% include slides/background-image.html
  image="lectures/all/all-reading.jpg"
  heading="Further Reading" %}

<http://bob.cs.sonoma.edu/IntroCompOrg-RPi/chp-except.html>

<http://6502.org/tutorials/interrupts.html>

<https://youtu.be/uFBNf7F3l60>

<https://learning.oreilly.com/library/view/essentials-of-computer/9781284123043/xhtml/09_Chapter04_06.xhtml>

<https://learning.oreilly.com/library/view/essentials-of-computer/9781284123043/xhtml/12_Chapter07_03.xhtml>

{% include slides/background-image.html
           image="lectures/all/all-questions.jpg"
           heading="Questions" %}

{:.center}
# Week 8 (part 2): Asynchronism {#asynchronism}

## Where were we?

![program context]({% link assets/lectures/week-8/program-context.png %}){:style="width:45%; float:right;"}

We just learned that an **interrupt** can stop our program _at any time_ and run different code in the handler.

Returning from the handler puts our program back _just the way it was before the interrupt_.

{% include slides/background-image.html
           image="lectures/week-8/tng-enterprise.jpg"
           heading="SO your microbit is a starship..." %}

{% include slides/background-image.html
           image="lectures/week-8/tng-bridge.jpg"
           heading="Every starship has a captain (program)" %}

{% include slides/background-image.html
           image="lectures/week-8/tng-interrupt.jpg" 
           bgsize="contain" %}

{% include slides/background-image.html
           image="lectures/week-8/tng-crusher.jpg" 
           bgsize="contain" %}

{% include slides/background-image.html
  image="lectures/all/all-lost.jpg"
  heading="Wait a minute... can we now run two programs?" %}

we kind of can, folks!

## Context Switching {#contextswitch}

![program context]({% link assets/lectures/week-8/program-context.png %}){:style="width:45%; float:right;"}

**Big Idea**: 

Have two (or more) _main programs_ and use interrupts to swap in between them.

But what is a context? 

The set of information that needs to be saved for a program to start up again after an interruption.

## Step 1: Before a context switch...

{:.stretch}
![]({% link assets/lectures/week-8/context-switch-1-pre.png %})

## Step 2: Interrupt! And switch to dispatcher...

{:.stretch}
![]({% link assets/lectures/week-8/context-switch-2-move-to-dispatcher.png %})

## Step 3: Swapping to the new context...

{:.stretch}
![]({% link assets/lectures/week-8/context-switch-3-switch-stack.png %})

## Step 4: Returning from dispatcher...

{:.stretch}
![]({% link assets/lectures/week-8/context-switch-4-return.png %})

{% include slides/background-image.html
  image="lectures/all/all-bigpicture.jpg"
  heading="Will either program notice?" %}

Would a program notice if it's been switched out and back?

Could anything go wrong here?

{:.fragment}
What if both programs _share data_?

{:.center}
# Concurrency and Synchronisation

## What is the value of G?

`int G = 0;`

<table style="width:100%">
<tr>
<td>
<pre>
G = 1;
G = G + G;
</pre>
</td>
<td>
<pre>
G = 2;
G = G + G;
</pre>
</td>
<td>
<pre>
G = 3;
G = G + G;
</pre> 
</td>
</tr>
</table>

What's the value of G at the end?

{:.fragment}
What's the _smallest_ G that could be produced? What's the _largest_?

## What is the value of G?

`G: .word 0x00000000`

<table style="width:100%">
<tr>
<td>
<pre>
ldr r4, =G
mov r1, #1
str r1, [r4]
ldr r4, =G
ldr r2, [r4]
add r2, r2, r2
str r2, [r4]
</pre>
</td>

<td>
<pre>
ldr r4, =G
mov r1, #2
str r1, [r4]
ldr r4, =G
ldr r2, [r4]
add r2, r2, r2
str r2, [r4]
</pre>
</td>

<td>
<pre>
ldr r4, =G
mov r1, #3
str r1, [r4]
ldr r4, =G
ldr r2, [r4]
add r2, r2, r2
str r2, [r4]
</pre> 
</td>
</tr>
</table>

What are the values of G that we can see now?

{% include slides/background-image.html
           image="lectures/week-8/fridge.jpg"
           heading="The too-much-milk problem" %}


Fact 1: There are two roommates

Fact 2: When a roommate gets home, they open the fridge. If there is no milk, they go out to get some.

Now what is going to happen? What is the solution?


## Solutions to the Too-Much-Milk Problem!

- a note? "I've gone to get milk!"
- a lock on the fridge door?
- two fridges? (ok now the analogy is going too far...)

## Mutual Exclusion

A "critical section" is a section where a program is accessing a shared resource.

We need a way to ensure that only _one process_ can enter a critical section at a time.

This is called "mutual exclusion".

## What happens without?

`int count = 0;`

{: style="font-size:0.8em;"}
<table style="width:100%">
<tr>
<td>
<pre>
for (i = 1; i <= 100; i++) {
  count = count + 1;
}
</pre>
</td>
<td>
<pre>
for (i = 1; i <= 100; i++) {
  count = count - 1;
}
</pre>
</td>
</tr>
</table>

## What happens without?

{:.stretch}
![]({% link assets/lectures/week-8/mutex-no-mutex.png %})

## What does ARMv7-M give us?

{:.stretch}
![]({% link assets/lectures/week-8/mutex-strex-ldrex.png %})

## Can we improve this?

{:.stretch}
![]({% link assets/lectures/week-8/mutex-critical-section.png %})

## Using a "lock" variable

{:.stretch}
![]({% link assets/lectures/week-8/mutex-in-assembly.png %})


{:.center}
# Alternatives to `strex` and `ldrex`

{% include slides/background-image.html
           image="lectures/week-8/dan-meyers-unsplash.jpg"
           heading="Atomic Operations" %}

An _atomic_ operation is one that either happens _completely_, or _not at all_.

It's indivisible.

There's lots of operations we need to be atomic... (e.g., bank transfers)

(Photo by [Dan Meyers](https://unsplash.com/@dmey503?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on Unsplash)

## Alternatives: Atomic Test-and-Set Operation

- a special instruction to _read_ a value, and set as a _new value_ atomically.

{:.stretch}
![]({% link assets/lectures/week-8/atomic-test-and-set.png %})

{:.fragment}
"keep reading the lock (and setting it to 1) until you find it open"


## Alternatives: Atomic Exchange Operation

- special instruction to atomically swap two values.
- similar idea...

{:.stretch}
![]({% link assets/lectures/week-8/atomic-exchange.png %})


## ARMv7-M Memory Cell Reservation

This is what we have! Also called "load-link/store-conditional".

{:.stretch}
![]({% link assets/lectures/week-8/memory-cell-reservation.png %})

{% include slides/background-image.html
  image="lectures/all/all-history.jpg"
  heading="Semaphores"
%}

A [semaphore](https://en.wikipedia.org/wiki/Semaphore_(programming)) (Dijkstra, 1968) is a generalisation of our _lock_ to handle common resources more generally. 

We define a _semaphore variable_ (**S**), and two operations:

**Wait(S)**: if S > 0, then S := S - 1 and continue, else wait

**Signal(S)**: S := S + 1, tell someone waiting to try again

So **S** could start at 1 (binary) or a higher number.

{% include slides/background-image.html
  image="lectures/week-8/semaphore-implementation.png"
  bgsize="contain"   %}

{% comment %}
## Semaphore Example 1:

![]({% link assets/lectures/week-8/semaphore-1.png %})

{:.fragment}
All good! Potentially, one process could _starve_ if the other never signals.

## Semaphore Example 2:

![]({% link assets/lectures/week-8/semaphore-2.png %})

{:.fragment}
Uh oh... this looks like a _deadlock_ waiting to happen.
{% endcomment %}

{% include slides/background-image.html
  image="lectures/all/all-bigpicture.jpg"
  heading="This happens all the time!"
%}

Concurrency is not an edge case! It's needed _all the time_.

Multi-task, and multi-CPU systems require hardware support for concurrency.

Now you know the _hardware operations_ that can support synchronisation implementations in your code.

In general, **higher abstractions** and **safer** solutions are provided; learn more in [COMP2310](https://comp.anu.edu.au/courses/comp2310/)!

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
	   id="ldrex" 
           heading="Let's try it on a microbit: LDREX"  %}

```arm
  ldr r0, =label_in_data_section
  ldrex r1, [r0]
```

`ldrex` loads `r1` with the memory that `r0` is pointing to, and sets the "local exclusive monitor" to exclusive.

It doesn't do any checking of the exclusive monitor before doing so!

The local exclusive monitor is just 1-bit! Either "open" or "exclusive".

(Multi-processor systems also have a "global exclusive monitor"... not covered here!)

## STREX {#strex}

```arm
  ldr r0, =label_in_data_section
  mov r1, 5
  strex r2, r1, [r0]
  cmp r2, 0
  bne do_something_to_recover
```

`strex` tries to store `r1` in the memory that `r0` is pointing to, but checks the exclusive monitor first. 

If the store is allowed, `r2` is set to 0, if it fails then `r2` is set to 1.

{:.fragment}
Then what should we do?

## When can a `strex` actually fail?

Need to look in the ARMv7-M reference manual (Section A3.4 "Synchronisation and Semaphores")

1. If address of `strex` is tagged exclusive in the local monitor; then store takes place (woo hoo!)
2. If address of `strex` is NOT tagged exclusive; then it is "implementation defined" whether the store takes place (????).

## Local Exclusive Monitor {#local-exclusive-monitor}

"Any `ldrex` operation updates the tagged address to the most significant bits of the address... used for the operation." (ARMv7-M reference manual)

{:.stretch}
![Local exclusive monitor on ARM.]({% link assets/lectures/week-8/local-exclusive-monitor.png %})

Note that `clrex` **always** clears the monitor, and that interrupt handlers run `clrex`!


{% include slides/background-image.html
           image="lectures/all/all-reading.jpg"
           heading="Further Reading" %}

G. Taubenfeld. Concurrent programming, mutual exclusion (1965; Dijkstra), Encyclopedia of Algorithms (2008) 188--191
<http://www.faculty.idc.ac.il/gadi/MyPapers/2008T-mutex.pdf>

[Wikipedia: Load-link and store conditional](https://en.wikipedia.org/wiki/Load-link/store-conditional)

[Wikipedia: Semaphores](https://en.wikipedia.org/wiki/Semaphore_(programming))

[ARM Synchronization Primitives: Development Article](https://static.docs.arm.com/dht0008/a/DHT0008.pdf)

[Mutual Exclusion Non-Solutions (Youtube)](https://www.youtube.com/watch?v=kzQik4bQeh0)


{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Making a `millis` function" %}

Is there a smarter way to measure time on the microbit?

How about a function that tells you how much time has passed?

On an Arduino or in `p5` or Processing you can call `millis()` which returns how long your program has been running in milliseconds. How does that work?

## Millis Function

{: style="font-size:0.6em;"}

```arm
@ returns: r0, number of milliseconds since starting 
.type millis, %function
millis:
    ldr r0, =milliseconds_count
    ldr r0, [r0]
    bx lr
.size millis, . - millis

.global SysTick_Handler
.type SysTick_Handler, %function
SysTick_Handler:
    @ update the milliseconds count.
    ldr r0, =milliseconds_count
    ldr r1, [r0]
    add r1, r1, #1
    str r1, [r0]
    bx lr

.data
milliseconds_count:
.word 0x0
```

## Setup

{: style="font-size:0.6em;"}

```arm
    @ enable SysTick - lower three bits of SYST_CSR (SysTick Control and Status Regsiter)
    ldr r0, =ADR_SYST_CSR
    ldr r1, =0b111 @ (enable systick, enable interrupt, set CPU as clock source)
    str r1, [r0]

    @ Store a reload value in SYST_RVR (Reload Value Register)
    ldr r0, =ADR_SYST_RVR
    ldr r1, =64000 @ 1ms @ 64MHz
    str r1, [r0]
```

{% include slides/background-image.html
           image="lectures/all/all-questions.jpg"
           heading="Questions" %}
