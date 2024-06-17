---
title: "Week 4: blinky"
summary: "Using the load-twiddle-store pattern to turn on and blink the lights on your microbit."
template_repo: https://gitlab.cecs.anu.edu.au/comp2300/2022/comp2300-2022-lab-pack-2
show_toc: true
image: assets/photos/microbit-front.jpg
image_alt: Image by Charles Martin
---

{% comment %}
- 5 tasks
- all submit via task-N.S
{% endcomment %}


{:.info-box} 
This lab looks long, and it is *fairly* long. There's a lot of detail to
explain what's going on when you complete these tasks and *why*. You will have
a chance to finish this work next week if you don't complete it today. 

## Introduction

In this week's lab you'll read and write some of the special hardware registers
on your microbit to see
[LED](https://en.wikipedia.org/wiki/Light-emitting_diode) "output" from your
program. Seeing stuff happen in the real world is a big part of the fun of
microcontrollers, so this is going to be fun.

You'll also start to see more clearly the connections between what we've been
covering in this course and the higher-level programming languages you're used
to, with "high-level" `if` statements, `for` loops, and other structures. This
process of "demystifying" programming is a big part of what this course is
about, so take the time to reflect on what you're doing and how it fits in with
what you know and do in other programming situations.

## Task 1: bit shifting practice

Plug in your microbit, fork & clone the [lab template]({{page.template_repo}})
to your machine, and open the `week-4` folder, then the `src/main.S` file as 
usual.

{:.info-box}
The stuff in Task 1 has been covered already but it's sometimes good to
have a warm-up/refresher, even if you _think_ you know how to do it all. 

### Bit-shifting & logic ops

You will need to use some logic operations in this lab, in particular, setting
(set `1`) and clearing (set `0`) bits. This warm up exercise gives you a chance
to practice bit shifting and using logic operations to set and clear bits.

Edit your `main.S` file so that it looks like the following. Don't forget the
required `.syntax unified` and `.global main` statements at the top of the
file.

``` ARM
main:
  ldr r0, =0xcafe0000
  ldr r1, =0xffff

  @ your code goes here

@ when it's all done, spin in an infinite loop
loop:
  nop
  b loop
```

{% include conversion.html %}

<div class="push-box" markdown="1">

Using *only* the instructions in the **Logic** and **Shift/Rotate** subsections
of the cheat sheet (but as many registers as you need) write a program which
puts *all* of the following values into the listed registers. Use the cheat
sheet and the converter widget to help you out---draw "bit pattern" pictures on
a piece of paper if it helps.

1. `0xcafeffff` into `r3`
2. `0xcafe` into `r4`
3. `0xcaff0000` into `r5`
4. `0xc0fe0000` into `r6`

Copy the code into `tasks/task-1.S`. Commit and push your changes with the message "completed task 1".
</div>

These shouldn't require heaps of code---just a couple of instructions for each.
Remember the [stuff you've]({% link
_labs/02-first-machine-code.md %}) [done in]({% link
_labs/03-maths-to-machine-code.md %}) previous labs.


## Task 2: using labels, ldr, and str {#using-labels}


### Labels and loading arbitrary numbers into registers

Label are the symbols in your source code followed by a colon
(`:`), e.g. `main:`. You've probably already got an intuitive feel for how they
work: you put them in your code wherever you like, and when you want to branch
to that part of the program you put the label in as the "destination" part of
the branch instruction. Here's an example:

```ARM
loop:
  @ do stuff

  b loop @ branch back to the "loop" label
```

In the [week 3 lab]({% link _labs/03-maths-to-machine-code.md
%}) you even used conditional branches to only branch under certain conditions
(i.e., if certain flags were set).

But what are labels, really? Add this code to your program (under the `main`
label):

``` ARM
ldr r0, =main
```

After you step through this line, what's in `r0`? You might be wondering what
the `=` sign is doing in your program. Remember that
instructions are stored in memory with various encodings (some are 16-bit, some
are 32-bit) and that when you use an *immediate value* constant (e.g. `42`) in
an instruction which supports it then the bit pattern for `42`
(which is `0b101010`) is stored *inside* that instruction.

This means that if you need to include a constant which is 32 bits long (e.g.
`0xABCD1234`) then you can't fit it in the instruction. You may have run into
this problem already---the error message will be something like

``` text
Error: invalid constant (ffffffffabcd1234) after fixup
```

and what it means is that the constant value you're using is too big (too many
bits) for the instruction you're trying to fit it inside.

<div class="extension-box" markdown="1">

If you're interested in how exactly the ARM instruction set deals with this
problem, and which constants *can* be stored inside a 32-bit instruction, then
[here's](https://alisdair.mcdiarmid.org/arm-immediate-value-encoding/) an
interesting blog post. Recall we use the Thumb-2 instruction set, so it's not
exactly the same on the microbit (see section A5.3.2 in the reference manual
for how they work on the microbit).

Instead, you can play with the following widget to see how our board encodes a
shift. The top input is the 12-bit encoded value. The second input is the
32-bit expanded output. Below this, the longer table is the binary
representation of the output. An orange colour represents one of the 4
"special" shifts, while blue means it is a regular shifted byte. Similarly, the
shorter table shows the parts of the encoded input, with the shift in purple
and the data in green. Note how bit 7 of the encoded input is conditionally
part of the shift or data, depending on bits 10 and 11. Each bit in the binary
table can also be toggled by clicking it.

</div>

{% include shifter.html %}

Because this is a bit of a pain, the assembler provides a special syntax for
storing larger values in registers. It's based around the `ldr` (load register)
instruction, and if you prefix the constant with an `=` sign then the assembler
will generate the code to load the full value into the register.

<div class="extension-box" markdown="1">

Have a look at these two lines of assembly code:

``` ARM
mov r0, 0xFFF
ldr r0, =0xFFF
```

will they result in the same assembly instructions when uploaded & running on
your microbit? How might you check? *Hint:* the disassembler is your friend
😊.

Can you think of any *other* lines of assembly code (apart from the two above)
which will be assembled into the same machine instruction(s)?

</div>

So how does this relate to the `ldr r0, =main` instruction above? Well, the
answer is that the labels in your program are just values---they're the
addresses (in your board's memory space) of the instruction which occurs after
them in the program. After the linker figures out exactly which address each
label points to, it "replaces" them in the program, so that

``` ARM
ldr r0, =main
```

becomes *something like*

``` ARM
ldr r0, =0x80001c8
```

or whatever address the `main` label ends up pointing to (which will change
every time your program changes).

And since `0x80001c4` (or whatever it is) is just a bit pattern in a register,
you can do the usual arithmetic/logic stuff you can do with any values in
registers:

{:.push-box}

Write a small program which calculates the size (in memory) of the `movs r3, 1`
instruction and stores the result in `r0`.
Copy the code into `tasks/task-2.S`. Commit and push your changes with the message "completed task 2".

## Task 3: the load-twiddle-store pattern {#load-twiddle-store}

The **load-twiddle-store** pattern is a fundamental pattern in making your
microbit do useful work. The basic idea is this:

1. load some data from memory into a register
2. operate on ("twiddle") the value in the register (e.g. with an `add` or `and`
   instruction)
3. store this new value from the register back into memory

![load-twiddle-store]({% link assets/labs/lab-5/load-twiddle-store.jpg %}){:style="width:70%;"}

Let's now make use of a data section to store some (spoilers) data, and attempt
to load-twiddle-store.

``` ARM
main:
  ldr r1, =storage
  @ your code starts here

.data
storage:
  .word 2, 3, 0, 0 @ don't change this line
```


Starting with the code above, use the **load-twiddle-store** pattern to change
the first four data words to `2` `3` `0` `1` instead of `2` `3` `0` `0`. Hint:
first load the `storage` label using the `=` instruction, then remember that you
can [load and store with an offset]({% link
_lectures/04-control-flow.md %}#load-and-store-with-offset) from this base
address (check the cheat sheet). You'll probably also want to use the memory
browser view (like you did [in week 2]({% link
_labs/02-first-machine-code.md %}#reverse-engineering)) to watch the values
change in memory.

{:.push-box}
Copy the code from your load-twiddle-store program into `tasks/task-3.S`.
Commit and push your changes with the message "completed task 3".

## Task 4: hello, LED! {#exercise-2}

So what does all that stuff have to do with blinking the LEDs? Well, the answer
is that there's a section of the microbit's [address space]({% link
_lectures/03-memory-operations.md %}#memory-address-space) (`0x40000000` to
`0x5FFFFFFF`) which is mapped to peripherals (as shown in the picture above).
To interact with the LEDs, speaker, microphone etc. on the board you need to
talk to the hardware by reading and writing to special memory locations in this
memory range. To figure out exactly which addresses are mapped to which
peripherals, you need to look at the microbit [reference
manual]({{site.mcu_reference}})

![microbit with LEDs lit up]({% link assets/photos/microbit-front.jpg %})

One type of peripheral is a [General Purpose
Input/Output](https://en.wikipedia.org/wiki/General-purpose_input/output) pin.
You can see them on your microbit as little gold-coloured contacts
at the bottom of the board. Your microbit has lots of them, and you
can wire them up to other devices (e.g., sensors, lights or motors) to make more sophisticated systems.

This exercise is pretty long, so here are the steps you'll go through to turn
on an LED:

1. figure out which pins are connected to the LED you want to turn on
2. set the pins direction to output
3. set a bit in the pin's output data register to turn the LED on

Don't worry if you don't understand some of those terms---the rest of this
exercise will explain all the details.

### Pins and memory addresses

Some of the GPIO connections from microbit's CPU are already connected to
certain bits of hardware on the board. The [microbit V2
pinmap](https://tech.microbit.org/hardware/schematic/#v2-pinmap) explains
exactly where each GPIO pin is connected.

As you can see on your microbit, the LEDs are arranged in a 5x5 array. There's
actually only one pin for each row and and one for each column. The second line
of the pin map says that "P1.05" is allocated to COL4. We can read this as "Port
1, pin 5 is allocated to the the 4th column of LEDs.

{:.think-box}
What GPIO port+pins do you think the top left LED is connected to?

The GPIO pins are grouped into 2 ports (port 0 and 1) and each port has up to
32 pins. It's worth pointing out that the pin numbering starts at 0, so the
first pin in port 0 is P0.0.

| Port | Pins |
|------|------|
| 0    | 0-31 |
| 1    | 0-9  |

Each GPIO port has special configuration registers that allow you to set up and
use each pin. GPIO pins support both sending data (setting a voltage to high or
low) and receiving data (reading the voltage on the pin as a 0 or 1).

The GPIO registers are not like the CPU registers you've been using so far
(e.g. `r0` or `r5`). These registers are mapped to certain parts of the address
space (they're sometimes called memory-mapped registers). Read/write access to
these registers happens through load/store instructions to a specific memory
address (as with pretty much everything in a load/store architecture.

The memory locations and descriptions of all these registers is in the [MCU
reference (6.8.2 p 141)]({{ site.mcu_reference }}), there's a lot of
information over those pages, so we'll copy in some of the information below
that is needed for this lab.

The first important piece of information is the _base address_ for each GPIO
port's configuration registers:

| Port | Base Address |
|------|--------------|
| P0   | `0x50000000` |
| P1   | `0x50000300` |

Now we can find each configuration register at certain _offset_ from these base
addresses. Here's a few that we will use today:

| Register | Offset    | Description            |
|----------|-----------|------------------------|
| OUT      | `0x504`   | Write GPIO port        |
| DIR      | `0x514`   | Direction of GPIO pins |

So reading these two tables together, if we want to write some data to a pin in
GPIO Port 0, we will need to store a value in the memory address found at
`0x50000000` + `0x504` (base + offset).

But how do we write data to a specific pin? Well port 0 can address 32 pins,
and the OUT register has 32 bits, so each pin can be changed by setting the
value of a specific bit in the OUT register for Port 0 (see the [MCU reference,
6.8.2.1]({{ site.mcu_reference }}) to see how this is described in the manual).

Note that in debug view in VSCode, you can conveniently see this information in
the **CORTEX Peripherals** pane: 

![Peripheral View]({% link assets/labs/lab-5/cortex-peripherals.jpg %}){:style="width:50%;"}

### Setting the pin direction to output

OK, now it's time to actually _change_ some of these memory-mapped configuration registers. We'll use the **load-twiddle-store** pattern.

The top-left LED is connected to Row 1 (P0.21) and Column 1 (P0.28). Let's
start by setting P0.21 (Row 1) to OUTPUT, that means setting a particular bit
in the P0 DIR register to 1. We'll need to follow these steps:

1. **load**: load the P0 base address into a register, then do an "offset"
   `ldr` with the `DIR` offset to read the current state of the
   `P0 DIR` register into a CPU register

2. **twiddle**: use bitwise operations to set bit 21 (counting from the right)
   of `P0 DIR` to 1 while leaving the other bits unchanged

3. **store**: write the new `P0 DIR` value back to the memory address you
   read it from earlier

{:.info-box}

When we talk about **setting** a bit, that means that it should be equal to `1`,
and **clearing** a bit means it should be equal to `0`.

So what does the code to perform these load-twiddle-store steps look like?

``` ARM
@ load r1 with the base address of P0
ldr r1, =0x50000000

@ load r2 with the value of P0 DIR
@ (note the 0x514 offset from the P0 base address)
ldr r2, [r1, 0x514]

@ set bit 21 of this register by doing a logical or with 0b1 left-shifted by 21
@ think: why does this work?
mov r3, 0b1
lsl r3, r3, #21
orr r2, r2, r3

@ store the modified result back into P0 DIR
str r2, [r1, 0x514]
```

{:.think-box}
Why is the **load** part of this process necessary? Why can't you
just store a single bit into the `P0 DIR` register and be done with it?

{:.do-box}
We have set one pin (P0.21) to output, but the LED is also connected to (P0.28) and that needs to be set to output as well. Copy the above code into your program and modify it so that you are setting bit 21 **and** 28 to output.

### Setting a pin's output to "high"

Now that the output direction is set correctly for P0.21 and P0.28, we can actually turn on the LED!

A bit more background: LEDs, like most electrical components have two
connections, you might have heard them being called "positive" and "negative"
or "+" and "-". On the microbit, each LED has it's positive side connected to a
ROW pin and it's negative side connected to a COLUMN pin (how do we know? The
circuit is in the [microbit schematics]({{ site.microbit_schematic_pdf }})
:-D).

This means that to turn an LED on, we have to set the corresponding ROW pin to
"high" (binary 1), and the COLUMN pin to "low" (binary 0) to create a circuit
so that current flows through the LED and it lights up!

{:.info}
COMP2300 is where coding meets the "real" world of electronics,
circuits and voltages and the language can be a bit confusing for
non-electrical-engineers (including your lecturer). While we have "+" and "-"
terminals on a battery or an LED, GPIO pins are always set to either "high" or
"low" voltage.

{:.do-box} 
Time to light it up! Copy-paste a second copy of the
load-twiddle-store code above. This time, you need to change the `P0 OUT`
register at offset `0x504` so that bit 21 is binary 1, that is, ROW 1 is set to
"high". You shouldn't need to change COLUMN 1 to "low", but you can if you want
to.

{:.push-box}

Following the steps above, write a program which turns on the top left LED on your
microbit.
Copy the code into `tasks/task-4.S`. Commit and push your changes with the message "completed task 4".

{:.talk-box}

There are a few fiddly things which can go wrong here. If your LED isn't coming
on, talk with your neighbour/tutor about your program. Have you accidentally set the
wrong bit (remember that the ports and bits are 0-indexed, so the rightmost bit
is bit 0, not bit 1). Are you reading the existing register value correctly? Are
you turning the bit on correctly? Are you writing it back to the right memory
address? Step through the program with your partner to see what might be going
wrong.


## Task 5: blinky

In this exercise you'll add a simple loop into your program to blink one of the
LEDs on and off. You can write some `delay` code to do this. The idea is that
in between turning your LED on and off your microbit should enter a loop that
will take a _long time to exit_.

{:.think}

You know how to turn an LED on. You probably can work out how to turn it off.
If you set your code to turn the LED on and then off straight away (no delay)
will you notice the change? If you blink an LED **very quickly** like this,
will it look like it's on, or will it look like it's off? Try it with your
neighbour and find out.

Now that you have tried turning the LED on and off immediately, it's time to
introduce a delay. Create a `delay` label in between the LED turning on and
off. The idea will be to create a loop of some sort to return to that delay
label. There are a bunch of ways to do this, but one way is to

1. set a register to a big number
2. subtract 1 from this register,
3. **if** the value isn't zero **then** goto step 2, **else** exit the loop.

Modify your program so that after the initial setup code, there is a loop which
turns the LED on, delays a little while, turns it back off, delays a little
again, then branches back to the top of the loop.
Once you've done that, you should be able to blink the LEDs on your board to
your heart's content.

{:.push-box}
Copy the code into `tasks/task-5.S`. Commit and push your changes with the message "completed task 5".

Wow! You made it to the end of the lab! You should be able to bathe in
the warm light of a glowing red LED.

## Extra Tasks

### Any LED

Create a program that can turn any single LED on the microbit **on or off**.
Are there any limitations about what LEDs could be turned on at the same time?


### Glowy

Turning things on and of with a fixed delay is cool, but you can achieve more
subtle effects with the LED using [pulse-width modulation
(PWM)](https://en.wikipedia.org/wiki/Pulse-width_modulation). The basic idea is
this: if you want the LED to glow brightly, then (in a loop) leave it on for a
long time, and turn it off for a short time. If you want it to glow dimly, do
the opposite. Using this technique, can you make the LED look like it's
*breathing*? 

### Morse Code

Can you store some data in your program somewhere to
blink a more complex pattern---can you program your microbit to blink in
[Morse Code](https://en.wikipedia.org/wiki/Morse_code)?
