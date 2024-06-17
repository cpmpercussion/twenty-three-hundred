---
title: References and links
summary: Useful resources for this course (and beyond)
show_toc: true
---

## Manuals

Here are the important manuals for your microbit, its nRF52 MCU, and the ARM Cortex-M4 CPU within it.

### [COMP2300 ARMv7 cheat sheet]({{ site.armv7_cheat_sheet_url | relative_url }}) {#cheat-sheet}

This cheat sheet has all the most important ARM assembly instructions that you
will use in this course. It doesn't include everything, but it's a good one to
keep handy (Charles has one printed out on his desk at all times).

It's available in [PDF]({{ site.armv7_cheat_sheet_url | relative_url }}) or as a [web page]({%
link _resources/ARM_cheat_sheet.md %}).


### [ARM®v7-M Architecture Reference Manual]({{ site.armv7_architecture_ref_url | relative_url }}) {#armv7-reference}

This is the official manual for the ARM Instruction Set Architecture used by your microbit. Make
sure you know how to search & bookmark this document in your pdf viewer of
choice.

### ARM Cortex-M4 Technical Reference Manual ([pdf]({{ site.arm_cortex_M4_ref_url | relative_url }}), [website](https://developer.arm.com/documentation/ddi0439/b))

This is the reference manual for the Cortex-M4 CPU. This provides documentation
of the built-in peripherals such as the NVIC (nested vectored interrupt
controller), Memory Protection Unit (MPU) and Floating Point Unit (FPU).

### [nRF52833 Product Specification](https://infocenter.nordicsemi.com/pdf/nRF52833_PS_v1.2.pdf)

This manual is for the microcontroller chip on your micro:bit (a Nordic
Semiconductor nRF52833). It's important because it explains how you can
interact with the peripherals on that particular MCU. (There are lots of
different Cortex-M4 MCU designs in the world with different features and
setups, so we need a specific manual).

### [micro:bit Technical Schematic](https://tech.microbit.org/hardware/schematic/)

This is the hardware schematic for the micro:bit board. This explains how the
components of the microbit connect to the nRF52833 MCU. Importantly, it lists a
pin-map showing which GPIO pins are connected to which component (LED, button,
etc) on the board.

You can see very detailed information about how the microbit hardware works on
the [PDF
schematic](https://github.com/microbit-foundation/microbit-v2-hardware/blob/main/V2/MicroBit_V2.0.0_S_schematic.PDF).

### [ARM Architecture Procedure Call Standard](https://developer.arm.com/documentation/dui0040/d/Using-the-Procedure-Call-Standards?lang=en)

The [Procedure Call
Standard](https://developer.arm.com/documentation/dui0040/d/Using-the-Procedure-Call-Standards?lang=en)
gives guidelines for writing code so that components written by different
programmers/compilers are likely to work together. It sets out expected usage
for registers, including special uses and which registers should be saved by
which parts of a program. Essential reading!

## Books

These are text books that are useful for the course.

### [Introduction to Computer Organization](http://bob.cs.sonoma.edu/IntroCompOrg-RPi/intro-co-rpi.html) by Robert G. Plantz {#plantz}

This (free, online-only) book is for a similar course at a different university.
There are a couple of reasons why we don't use it as an official text for this
course, but it's still a good resource if you're looking for another angle in
understanding this stuff.

This is a great book for understanding digital logic, basic assembly, memory,
the stack, functions, and data structures.

### [Digital Design and Computer Architecture by Sarah Harris and David Harris](https://dl.acm.org/doi/10.5555/2815529)

[Available for free online from ACM (link)](https://dl.acm.org/doi/10.5555/2815529)

This book (available for a PDF for free!) is all about how ARM CPUs actually
work. If you want to dive further into digital logic and microarchitecture,
this is the book to read.

### [Essentials of computer organization and architecture by Linda Null and Julia Lobur](https://virtual.anu.edu.au/login/?url=https://learning.oreilly.com/library/view/~/9781284123043/?ar)

This book (available at the ANU library and online through O'Reilly press) is a
bit more of a high level tour approach to how computers work in layers from
digital logic, to system software. It is particularly good on operating
systems, networking and CPU architectures. This is the place to go when you
want to how the whole story of a computer (hardware and software) fits
together.

## Links

### [GNU Assembler documentation](https://sourceware.org/binutils/docs/as/index.html) {#gas} 

Our VSCode to Microbit toolchain uses GNU compiler tools to turn assembly code into machine instructions. The **GNU Assembler** documentation can help understand how these work:

- [Symbols](https://sourceware.org/binutils/docs/as/Syntax.html#Symbols)
- [Syntax](https://sourceware.org/binutils/docs/as/Syntax.html#Syntax)
- [Assembler directives](https://sourceware.org/binutils/docs/as/Pseudo-Ops.html#Pseudo-Ops)
- [ARM-specific directives](https://sourceware.org/binutils/docs/as/ARM-Directives.html)

### [Ben Eater's Youtube Channel](https://www.youtube.com/channel/UCS0N5baNlQWJCUrhCEo8WlA) 

Ben Eater is a computer science teacher on YouTube who makes _amazing_ videos about computer organisation and program execution. We'll look at some of them in the lectures, but it's worth a watch!

- Build a 6502 computer series (ongoing!) <https://eater.net/6502> 
- Let's build a video card! <https://eater.net/vga>
- [Youtube Channel](https://www.youtube.com/channel/UCS0N5baNlQWJCUrhCEo8WlA) 

Building your own computer following Ben Eater's instructions would be a _great_ holiday project. 

### [Davespace ARM tutorial](http://www.davespace.co.uk/arm/introduction-to-arm/) {#davespace}

This online reference material is a bit more chatty than the official arm
reference, and has some more explanatory text. It does mention some stuff that
we won't cover in this course (and it's not specific to the CPU on your
micro:bit), so I won't refer to it often. Still, it might be useful if you're
looking for alternative ways of explaining things, or just want to dive deeper
in to ARM assembly programming.

### [Godbolt compiler explorer](https://godbolt.org/) {#godbolt}

The Godbolt compiler explorer is an interactive online tool for turning C code
into assembly instructions using the `gcc` compiler. It has support for various
architectures, including ARM. To see the code which would be generated for a
Cortex-M processor like your micro:bit, make sure you select the `ARM GCC 5.4`
compiler (or similar) and specify the `-mcpu=cortex-m4` compiler option.

This tool doesn't give you anything you can't technically pull out yourself with
`gcc` and a few commandline shenanigans, but it has a few nice touches like
using colour-coding to show which bits of C match up with which bits of assembly
code, and a few other things like that.

### [Visual 6502](http://visual6502.org)

It's an online, visual transistor-level emulation of a [MOS 6502 CPU](https://en.wikipedia.org/wiki/MOS_Technology_6502) (circa 1975). 

We'll have a look at this in later lectures but it's fun to try out at any time!

### [NAND 2 Tetris](https://www.nand2tetris.org)

A famous course in computer organisation, could be useful if you're looking for some different materials. This course differs from COMP2300 by creating a "simulated" computer, rather than working with a real micro:bit.

## Resources about Digital Sound and Synthesis

The assignments and labs may involve making sounds with your micro:bit, but the basics of digital sound aren't covered in detail in the course. If you want some more detailed information, I recommend the following resources:

- Monty Montgomery: Digital Sampling [Youtube](https://xiph.org/video/vid2.shtml), [Direct Video Download](https://xiph.org/video/vid2.shtml)
- Technology Connections: Nyquist-Shannon [Youtube](https://youtu.be/pWjdWCePgvA)
- Computerphile: How Digital Audio Works [YouTube](https://youtu.be/1RIA9U5oXro)

I also have a lecture about digital synthesis which extends the basics a bit, and could help with your assignments. The [slides and video are up]({% link _lectures/13-digital-synthesis.md %}).

