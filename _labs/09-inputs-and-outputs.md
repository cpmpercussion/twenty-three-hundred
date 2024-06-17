---
title: "Week 9: inputs and outputs"
summary: "Putting it all together with inputs and outputs"
template_repo: https://gitlab.cecs.anu.edu.au/comp2300/2022/comp2300-2022-lab-pack-3
show_toc: true
image: assets/labs/lab-9/florian-krumm-1osIUArK5oA-unsplash.jpg
image_alt: Photo by Florian Krumm on Unsplash
---

{:.warn-box}
This lab includes in-lab assessment for the Assignment 2 Pre-Submission task.
Read about it how that works on the [assignment presubmission page (link)]({%
link _assessments/08-assignment-presubmissions.md %}).

## Introduction

Last week you worked on understanding the fundamentals of interrupts and using the two key types of interrupt you need in COMP2300: timer and GPIO interrupts. 

This week you will combine this knowledge with what you learned in previous labs and assessments to create a real interactive application---now things are really getting interesting!

If you haven't finished the tasks in the previous lab, you should probably look at these before you attempt this week's tasks.

{:.info-box}

The tasks this week are directly related to assignment 2. Make sure you try them and get help from your tutors if you are stuck!

## Task 1: QuickClick {#quickclick}

In the first task, your job is to take your new knowledge of interrupts and
make a game called **QuickClick**. It's a simple game:

1. you blink an LED on your microbit for a short time every 5 seconds

2. the player's goal is then to press a button when the LED is on

3. if you get the timing right (i.e. the LED *is* on when the button is
   pressed) a different LED comes on.

4. each time you get it right, the LED blink duration gets shorter (so that it's
   harder to get the timing right for the next round).

For this task, you can take advantage of your ability to enable & disable
different interrupts in software to make it easy to implement the "is the LED
on? if so, then clicking the button will turn on the other LED" logic:

1. perform all the configurations steps necessary (including defining the
   handler function) to use button A as an input device

2. in your `SysTick_Handler`:

   - enable the GPIOTE interrupt by setting the bit in the interrupt **set**
     enable register `NVIC_ISER0` (address: `0xE000E100`) The bit you are
     looking to set can be found in the ID column of the interrupt vector
     table in section 4.2.4 "Instantiation" of the [microbit reference
     manual]({{site.mcu_reference}})

   - You may also want to clear **both** GPIOTE and NVIC interrupt pending bits
     **before** enabling the GPIOTE interrupt.
     Otherwise the pending interrupt will trigger when you enable it.

   - blink the red LED in a **blocking** fashion (i.e. use a delay, so that the
     red LED goes on and then off again before the `SysTick_Handler` exits)

   - before `SysTick_Handler` exits, disable the GPIOTE interrupt by setting
     the bit in the interrupt **clear** enable register `NVIC_ICER0` (address:
     `0xE000E180`)

<div id="clear-enable-gotcha" class="info-box" markdown="1" style="margin-bottom: 20px;">

There's one more "gotcha" to be aware of when dealing with the ***clear**
enable* and ***clear** pending* NVIC control registers (e.g. `NVIC_ICER0` or
`NVIC_ICPR0`). As described above, to disable an interrupt (ICER) or clear a
pending interrupt (ICPR) you write a `1` to the corresponding bit (e.g. to
disable the interrupt in position 6 of the NVIC you write a `1` to the 7th bit
from the right in `NVIC_ICER0`).

However, you might have noticed something if you were reading Sections B3.4.5
(p684) and B3.4.7 (p685) the [ARM reference
manual]({{site.armv7_architecture_ref_url}}) really closely. In the description
for those registers it says:

> **1**: On reads, interrupt enabled

which means that if an interrupt is enabled, then a *read* from that
(memory-mapped) register will show the corresponding bit as `1`.

This is a problem for the load-twiddle-store pattern, because the point of the
load twiddle store is to leave all the bits unchanged except for the one you're
interested in. However, this means that all of the currently enabled interrupts
(whose bits will read as `1` in the *load* phase) will be disabled when you
write the bits back in the *store* phase---which (almost certainly) isn't what
you want!

Again, here's an example: say there are 3 interrupts currently enabled, then a
load from the corresponding register would have `1`s in those three positions,
and `0`s elsewhere. If you load/twiddle/store the value, then all three of
those interrupts would be *cleared* by the store operation.

This means that for the ***clear** enable/pending* registers you should just
write a `1` for the particular interrupt you're interested in, and a `0` in all
the other bits.

</div>

Can you see how you can use this technique to temporarily enable the button
interrupt in the SysTick interrupt handler so that the button will only work
when the LED is on?

{:.push-box}

Implement the QuickClick game following the steps above (you can use as much of
the startup code provided earlier as you like). Commit and push your program to
GitLab.

## Task 2: Quick Click Data Structure

So far, the quick click game doesn't show you much about your current "score".

Use your knowledge of data structures to create a way to record the player's
current score and display it on the LED screen somehow.

For example, you could use a record to store the player's current number of
successful clicks, and their reaction time. After each successful or
unsuccessful click, the player's score (out of 5) could be displayed as a
number of LEDs lit in one column.

There are lots of ways to do this, but the important thing is to find a way to
incorporate buttons (inputs), LEDs (outputs), and memory in an interactive
game.


## Task 3: Click vs Click

The microbit has two buttons, so can you make a two player version of quick
click? 

A simple way to do this would be to have two independent games runing on either
side of the microbit. You'll have to be careful about using different channels
in the GPIOTE module, one for each button, and enabling, checking, and clearing
them independently.


A more complex (and maybe more fun) option would be to arrange so that only
_one_ player can win each click (the first one to have their button press
registered).

You could use your score storage more engagingly by removing a point from a
player that loses each round, as well as adding a point to the winner.

## Extra Tasks

### No Interrupt Click 

Can you re-implement the QuickClick game without interrupts?

### Random Number Generator QuickClick

Can you turn on the microbit's random number generator (RNG) and use it so that
LEDs blink randomly, rather than at regular intervals? Hint: *Section 6.19* of
the [nRF52833 Product Specification]({{ site.mcu_reference }}) is the place to
find the configuration steps required to get the RNG working---it's not too
difficult.

### QuickClick Byte Beats

Can you add sound to the quickclick game? You could start by playing  a small
"victory" sound when a player wins a round, or a starting squeak when the LED
lights up for each game.

The easiest "sounds" to make are the little byte beats we tried out in week 5,
but you'll have to experiment with how to make these sounds start and stop

Hint: you can't just _not_ send new samples and expect the sound to be silent,
you will have to send "silent samples" to turn off the sound.


