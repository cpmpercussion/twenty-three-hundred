---
title: Glossary
summary: Short definitions & examples for key concepts in the course
hidden: true
show_toc: true
---

This glossary provides short definitions & examples for some of the key concepts
in the course. There's not much here at the moment, but it'll grow as time goes
by. If you have suggestions, improvements, or if you want to write a glossary
entry yourself, then let us know on [the COMP2300 forum]({{ site.forum_url }}) using the
`glossary` label.

These glossary entries aren't meant to be exhaustive technical definitions,
they're designed to illustrate things in a concrete manner (with examples where
possible). They don't say *everything* that could be said about a topic, they
just try and provide the key or essential ideas behind each concept.

The entries won't be in alphabetical order, they'll be in (approximately) the
order we presented them in the course. So the later stuff will build on the
earlier stuff, and if you don't understand everything in one section make sure
you check the earlier glossary entries---you might have to jump around a bit to
get all the information you need.

## Registers

A register is a specific piece of hardware (i.e. a bunch of logic gates) for
storing data. There are hundreds of registers on the microbit, but you'll use
some of them more than others. Because the microbit is a 32-bit machine most
of these registers are also 32 bits wide

There are 16 general purpose registers (`r0`-`r16`) which are connected to the
arithmetic & logic unit (ALU) and you can do, well, arithmetic and logic on
them---e.g. adding the 32-bit values in two registers and storing the result in
a third register.

As well as these general-purpose registers, there are also lots of different
registers for configuring and controlling the peripherals on your microbit.
For example, you configure the clocks and turn on the LEDs on your microbit by
writing to special GPIO registers. If you're after a refresher course on this
stuff, [lab 5]({{site.baseurl}}/labs/05-blinky/) has lots more
information.

## Memory address

A memory address is a number which represents a memory **location** which you
can read data from (with `ldr`) and write data to (with `str`). The "address
space" of a computer (e.g. your microbit) is a mapping from addresses (which
are just numbers) to different memory addresses on the microbit. On your
32-bit microbit (and on any 32-bit CPU) there are $$2^{32}$$ possible memory
addresses, but not all of them will be "connected" to actual memory. Some of
them will point to RAM, some will point to special registers (e.g. for
controlling clocks, interrupts or GPIO pins) and some of them won't be connected
to anything.

## Bits and bytes

One byte is equal to eight bits. So to get from bits to bytes, divide by 8 (and
multiply by 8 to go the other way). Sometimes a group of 4 bits is called a
nibble (but that's not so common).

The microbit's [memory space](#memory-address-space) is addressed in bytes, so
the first byte of the memory space is address `0`, the second byte is address
`1`, etc. If data is stored in memory in 32-bit (i.e. word-size) chunks, then
successive values will have memory offsets of 4 bytes (since $$4 \times 8 = 32$$).

One of the reasons that hexadecimal numbers are used so frequently when dealing
with memory addresses (and computing in general) is that there's a nice 4-to-1
mapping from bits to hex characters: a 4-bit unsigned number can represent the
values from 0 to 15, and so can one hex character (e.g. `0xF` in hex is `15` in
decimal). To convert from hex to binary (and vice-versa), just "expand" every
hex digit out into four binary digits:

``` ARM
ldr r0, =0x    1    2    3    4
ldr r1, =0b 0001 0010 0011 0100
; r0 and r1 now hold the exact same bit pattern
```

## Endianness

Endianness refers to the way that multi-byte values (e.g. 32-bit words, which
are 4 bytes) are stored in memory. In a 32-bit register such as `r0` this isn't
an issue, since the least-significant bit is always the rightmost one, and the
most-significant bit is always the leftmost one. But once you start storing
values to memory (or reading them from memory) then it matters. Here's an example:

``` ARM
ldr r0, =0xAABBCCDD ; the value
ldr r1, =0x20000000 ; the address

str r0, [r1] ; store 0xAABBCCDD to 0x20000000
```

On a **big-endian** architecture, the least significant byte `0xDD` is in the
highest memory address. Since the SystemWorkbench Memory Viewer shows the memory
from lower addresses on the left to higher addresses on the right, a big-endian
representation will look "normal": i.e. like `0xAABBCCDD`.

Confusingly, though, on your **little-endian** microbit the least significant
byte of the value goes at the lowest memory address, which is the leftmost one
in the Memory Viewer. As a result, in memory the above value will look
"reversed": `0xDDCCBBAA`. Now, this isn't a problem as long as the system is
always *consistent* when it loads and stores, but it's just something to be
aware of when you're looking at multi-byte values in the memory viewer.

## Interrupt controller

The interrupt controller is a piece of hardware which connects directly to the
CPU and tells it (by raising and lowering the voltages on the connecting wires)
to stop what it's doing, and run a special handler [function](#functions). On
the microbit, the interrupt controller is called the Nested Vectored Interrupt
Controller (NVIC). The **nested** part means that the interrupt controller can
handle several interrupts at once, allowing a higher priority interrupt handler
to take over from lower priority one (but still returning to the lower-priority
one once the higher-priority one has finished). The **vectored** part means that
the addresses of the handler functions (i.e. the locations of the actual machine
code which will run) are stored in a "vector table" somewhere, so that the
programmer define both which interrupt handler is triggered by a given interrupt,
and also what the handler does.

Interrupts are covered extensively in labs 8-10, so that's a good place to start
for more information.

## Functions

A function (sometimes called a subroutine) is a series of instructions which you
branch *to*, execute the instructions, and then branch *back* when you're done.
That's it. You go there with a `bl` (which saves the "next instruction" address
into the link register `lr`) and you branch back with a `bx lr` when you're
done. It *may* take arguments (input) or return values (output) but it doesn't
have to.

So here's a **simple** example of a program which contains a `square` function
which squares (i.e. $$x^2$$) it's input value (passed in `r0`) and returns the
result in `r0`.

``` ARM
.syntax unified
.global main

square:
  mul r0, r0, r0
  bx lr

main:
  bl r0, #2
  nop
```

There are lots of things this function doesn't do, but which a different
function *might* need to do:

- it doesn't call any other functions (so it doesn't have to worry about saving
  `lr` onto the stack)
  
- it's not recursive (it doesn't call itself)

Note that this definition of function is different from the mathematical
definition (which is used in programming languages like Haskell)---in those
cases it's talking about functional purity (no side effects). Our definition
here doesn't really have anything to do with functional purity. It's kindof a
shame that the word *function* has multiple meanings like this, but that
sometimes happens in life. Oh well.
