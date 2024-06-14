---
title: Revision
summary: A tour of the topics
permalink: /lectures/week-12/
image: assets/lectures/all/cpm-ski.jpg
---

{% include slides/title.html %}

{% include slides/background-image.html
           image="lectures/all/all-todos.jpg"
           heading="Admin Time"  %}

{% include slides/background-image.html
    image="lectures/all/cpm-ski.jpg"
    heading="It's been a journey..." %}
    
{% include slides/impact.html %}

What was this course **about** again?

{% include slides/background-image.html
    image="lectures/week-12/comp2300-topic-map.png"
    bgsize="contain" %}

{:.center}
# Digital Logic

## Digital Logic Topics (in short):

- Boolean Algebra
- Combinatorial Logic Functions
- Digital Electronics - Logic Gates
- Binary Encoding, and 2's-Complement
- Adders: Half, Full, Ripple Carry
- Arithmetic Logic Unit
- Simple CPU Architecture

## Logic gates

{:.stretch}
![Logic gates]({% link assets/lectures/week-1/logic-gates.png %})

All gates can be represented by NAND or NOR.

{% include slides/talk.html %}

1. how many bits can be added together?
2. how long does it take?
3. where does the final carry bit go?

{:.stretch}
![Ripple carry adder]({% link assets/lectures/week-1/ripple-carry-adder.png %})

## Twos complement representation {#twos-complement-representation}

The basic idea: define (binary) negative numbers so the adder works.

![]({% link assets/lectures/week-1/42-plus-what.png %}){:style="width:40%;"}

How do we make a number negative? Invert bits and add one! Why does that work?

## Flip-flops

![]({% link assets/lectures/week-12/flip-flop-family.png %})

![Register]({% link assets/lectures/week-1/register.png %}){:style="width:40%;"}

{% include slides/talk.html %}

What's the difference between Boolean algebra, combinational logic, and sequential logic?

Why do we need all three of these things to describe computers?

Are there parts of the story missing from this course?


## CPU Architecture

![a simple CPU]({% link assets/lectures/week-11/simple-CPU.png %}){:style="width:40%; float:right;"}

What are the **main components** of a CPU?

Can you **explain** what each of these components do?

We come back to this later...

{:.center}
# Hardware/Software Interface

## Hardware/Software Interface Topics (in short)

- Structure of an instruction
- Assembly to CPU instructions
- CPU Status Flags (NCZV)
- ARM v7 instructions (adding, subtracting, moving, rotate/shift,
  bit-wise ops)
- loading and storing from memory
- branch instructions
- Contents of Quick Ref. Card

## NCZV Flags

- **N**egative
- **Z**ero
- **C**arry
- O**v**erflow

## Negative

This status flag is set when the result of an ALU operation is negative *if
interpreted as a twos complement signed integer*

``` ARM
movs r0, 5
movs r1, 6
subs r2, r0, r1
```

don't forget the `s` suffix

## Zero

This status flag is set when the result of an ALU operation is zero

``` ARM
movs r5, 5
movs r6, -5
adds r4, r5, r6
```

## Carry

This status flag is set when the result of an ALU operation requires a "carry
out" *if interpreted as an unsigned 32-bit integer* (i.e. it requires 33 or more
bits to represent)

``` ARM
movs r2, 0xFF000000
movs r3, 0xFF000000
adds r5, r2, r3
```

## Overflow {#overflow}

This status flag is set when the result of an ALU operation would overflow the
min/max value *if interpreted as a twos complement signed integer*

``` ARM
movs r0, 0x7FFFFFFF @ largest signed integer
adds r0, 1
```

``` ARM
movs r0, 0x80000000 @ smallest signed integer
subs r0, 1
```

{% include slides/talk.html %}

``` ARM
movs r0, 5
movs r1, 6
subs r2, r0, r1
```

What flags will be set after the `subs` instruction is executed?

{% include slides/background-image.html
           image="lectures/week-3/cortex-memory-map.png" 
           bgsize="contain" %}

{% include slides/background-image.html
           image="lectures/week-2/rotation-types.png" 
           bgsize="contain" %}

## ARM is a load-store architecture

Instructions are _either_:

- **ALU operations** which take inputs and save results to registers, or,
- **memory access** operations which _just_ save and load from memory

What does this mean for the programmer?

## Loading and Storing

Load:

``` arm
mov r1, 0x20000000 @ put the address in r1
ldr r0, [r1]       @ load the data into r0
```

Store:

``` arm
mov r0, 42
mov r1, 0x20000000
str r0, [r1]
```

## Extra Operations

Load less than 32 bits
``` arm
ldrb @ load byte from register
ldrh @ load halfword from register
strb @ store byte to register
strh @ store halfword to register
```

Negative Stack
``` arm
stmdb <Rs>!, {Rgstrs} @ store multiple decrement before
ldmia <Rs>!, {Rgstrs} @ load multiple increment after
push {Rgstrs}
pop {Rgstrs}
```

## Conditional branch examples

``` arm
beq <label> @ branch if Z = 1
bne <label> @ branch if Z = 0
bcs <label> @ branch if C = 0
bcc <label> @ branch if C = 1
bmi <label> @ branch if N = 1
bpl <label> @ branch if N = 0
bvs <label> @ branch if V = 1
bvc <label> @ branch if V = 0
```

{% include slides/background-image.html
    image="lectures/week-12/comp2300-topic-map.png"
    bgsize="contain" %}

{:.center}
# Functions

## Functions Main Topics (in short)

- There and back again, `bl`, `bx`, and `lr`
- The stack
- Calling conventions
- Functions calling functions
- Functions calling themselves! (a.k.a. recursive functions)
- Local variables, and the stack frame (incl. `sp` and `fp`)
- Relative addressing
- Passing values: by copy and by reference

{% include slides/background-image.html
           image="lectures/week-5/jeremy-cai-1169-unsplash.jpg"
           heading="there, and back again"  %}

## AAPCS {#aapcs}

The [ARMv7 Architecture Procedure Call Standard]({{site.armv7_procedure_call_standard_url}}) is the convention we'll (try to) adhere to in programming our microbits

The full standard is quite detailed, but the general summary is:

- `r0`-`r3` are the parameter and scratch registers
- `r0`-`r1` are also the result registers
- `r4`-`r11` are callee-save registers
- `r12`-`r15` are special registers (`ip`, `sp`, `lr`, `pc`)

## Store and Load to the stack

{: style="font-size:0.8em;"}
``` arm
@ Push the value in r2 onto the stack
str r2, [sp, -4]
sub sp, sp, 4

@ Different one-liners for Push
str r2, [sp, -4]!
push {r2}
stmdb sp!, {r2}

@ Pop the value from the "top" of the stack into r3
ldr r3, [sp]
add sp, sp, 4

@ One-liners for Pop
ldr r3, [sp], 4
pop {r3}
ldmia sp!, {r2}
```

## Push and Pop; illustrated

<-- Push
![stack push example]({% link assets/lectures/week-5/stack-push-example.png %}){:style="width:40%; float:left;"}

Pop -->
![stack pop example]({% link assets/lectures/week-5/stack-pop-example.png %}){:style="width:40%; float:right;"}

## Passing by Copy or Reference

{:.stretch}
![lectures/week-12/pass-by-copy-or-reference.png]({% link assets/lectures/week-12/pass-by-copy-or-reference.png %})

## Function stack frame

![Stack frame diagram]({% link assets/lectures/week-5/stack-frame.png %}){:style="width:40%; float:left;"}

![Nested stack frames]({% link assets/lectures/week-5/nested-stack-frames.png %}){:style="width:40%; float:left;"}

## Recursive Functions: Factorial

{: style="font-size:0.8em;"}
``` arm
fact: @ assume input is in r1
  push {lr}
  cmp r1, #1
  beq base_case
  @ recursive case
  push {r1}
  sub r1, #1 
  bl fact @ get fact(n-1)
  pop {r1}
  mul r0, r0, r1 @ calc fact(n-1) * n
  b continue_code

  base_case:
  mov r0, #1
  continue_code:
  pop {lr}
  bx lr
```

{:.center}
# Control Structures

## Control Structures Main Topics (in short)

- Conditional branching
- Control Structures in Machine Code:
- if
- while
- for

## CPSR table {#cpsr-table}

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

## while loop components

{:.stretch}
![]({% link assets/lectures/week-4/whileloop-examples-colour.png %})

## control structures gallery - practice these!

{:.stretch}
![]({% link assets/lectures/week-4/uwe-control-structure-cheatsheet.png %})

{% include slides/talk.html %}

Which control structures were useful for your assignments?

Is there anything you can do in assembly that goes beyond "typical control structures"?

{:.center}
# Data Structures

## Data Structures Main Topics (in short)

- **Arrays**
- Structure
- Alignment
- Addressing
- Iterators
- Copying

{:.stretch}
{% include slides/background-image.html
           image="lectures/week-7/array-diagram-4-byte-elements.png" 
           bgsize="contain" %}

{% include slides/talk.html %}

How do we know how big an array is in memory?

Is it possible to write outside the bounds of the array?

Can you make an array where the size can be changed? (mutable array?)

How do we address a particular element in an array?

{% include slides/background-image.html
           image="lectures/week-12/array-addressing.png" 
           bgsize="contain" %}

## Add up the numbers in an array

{: style="font-size:0.8em;"}

```arm
  ldr r0, =array @ base address
  mov r1, 0      @ from_index
  mov r2, 7      @ to_index
@ setup
  mov r3, 0 @ "accumulator" register
  mov r4, 4 @ element size

array_sum:
  mul r5, r1, r4   @ calculate offset
  ldr r6, [r0, r5] @ load from offset
  add r3, r6       @ update accumulator
  add r1, 1        @ increment index
  cmp r1, r2       @ keep looping?
  ble array_sum
```

## Records

![lectures/week-7/hearthpebble-synth-records.png]({% link assets/lectures/week-7/hearthpebble-synth-records.png %})

{% include slides/talk.html %}

What's the difference between an **array** and a **record**?

Imagine you are creating a Point-of-Sale system (cash register) using a microbit. What data structures might be required?

{% include slides/background-image.html
    image="lectures/week-12/comp2300-topic-map.png"
    bgsize="contain" %}

{:.center}
# Asynchronism, Interrupts, and Concurrency

## Async Main Topics (in short)

- Interrupts & Exceptions: When and Why?
- What happens during an interrupt?
- How is this related to **parallel computing**?
- Concurrency and Synchronisation
- Race Conditions
- Mutual Exclusion
- Synchronisation (Locks and Semaphores)

{% include slides/talk.html %}

What's an interrupt? Why are they necessary?

## Interrupts

![a CPU view of an interrupt]({% link assets/lectures/week-8/interrupt-cpu.jpg %}){:style="width:40%; float:right;"}

One or multiple lines **wired directly to the sequencer**.

**Interrupts**: Enables pre-emptive scheduling, timer driven actions, transient hardware interactions, etc...

_BUT_: A little bit more work to set up, requires external hardware ("interrupt controller") to encode external requests.

## Interrupt Handler

![program context]({% link assets/lectures/week-8/program-context.png %}){:style="width:40%; float:right;"}

A "normal function", called when an interrupt is triggered.

The CPU saves the "caller-save" context on the stack, loads `lr` with special value.

Handler saves "callee-save" context, then runs I/O or time-critical code.

## Context Switch

Switch out a program (during an interrupt) without it even noticing!

{:.stretch}
![]({% link assets/lectures/week-8/context-switch-3-switch-stack.png %})

{% include slides/talk.html %}

What's problems can occur when running concurrent programs? What are the possible solutions?

How does the "too much milk" problem help us understand this issue?

## Race Conditions and Mutual Exclusion

When the sequence or timing of _threads of execution_ has an effect on the outcome.

Can result in bugs! (e.g., in Assignment 3!) What is the value at `Count` in this code?

{:.stretch}
![]({% link assets/lectures/week-8/mutex-no-mutex.png %})

## Critical Section

{:.stretch}
![]({% link assets/lectures/week-8/mutex-critical-section.png %})

## What does ARMv7-M give us?

{:.stretch}
![]({% link assets/lectures/week-8/mutex-strex-ldrex.png %})

## Using a "lock" variable

{:.stretch}
![]({% link assets/lectures/week-8/mutex-in-assembly.png %})

{% include slides/talk.html %}

What's mutual exclusion? 

Can this be achieved on a microbit? 

How would you do it?

{:.center}
# Networks

## Networks Main Topics (in short)

- Transmission mediums
- Communications protocols
- Packet switched/circuit switched
- Simplex/duplex
- Topology
- Parallel/Serial
- Timing and Synchronisation
- OSI reference model (7-layers!)

{% include slides/talk.html %}

How many transmission mediums can you name?

If you were stuck on a desert island what transmission media could you
use to send a message for help?

What is a communications protocol?

Why would it be needed?

Explain your answer.

## Topology

topology is the way that the nodes are connected to one another (both physically
and logically)

there are several different ways to connect the nodes together, each with pros
and cons

{:.stretch}
![Basic network topologies]({% link assets/lectures/week-9/topology-alternatives.png %})

## Serial vs parallel

| serial                                    | parallel                                                  |
| :---------------------------------------- | :-------------------------------------------------------- |
| data is sent one-bit-at-a-time            | multiple bits sent simultaneously (e.g. multiple wires)   |
| fewer bits sent per signal, but simpler   | need to keep all the connections in sync                  |

![serial vs parallel communication]({% link assets/lectures/week-9/serial-vs-parallel.png %})

## Synchronous vs Asynchronous

| synchronous                                                                       | asynchronous                                                                                               |
| :-------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------- |
| transitions on a *clock line* | (independent) timers at each end  |
| no clock skew issues, but requires an extra connection                            | no extra connections required, but more vulnerable to synchronisation issues                               |

{:.stretch}
![lectures/week-9/sync-async.jpg]({% link assets/lectures/week-9/sync-async.jpg %}){:style="width:30%;}

{% include slides/background-image.html
           image="lectures/week-9/osi-layers.png" 
           bgsize="contain" %}

{:.center}
# Operating Systems

## OS Main Topics (in short)

- Operating Systems: Concept
- OS Categories
- OS Architectures
- Processes - what are processes anyway?
- How do OSs handle processes?
- Scheduling

Why do we need operating systems anyway?

## What's an OS? ...two main roles

| virtual machine                      | resource manager             |
| :----------------------------------- | :--------------------------- |
| _provides friendly & safe environment_ | _coordinates access to resources_  |
| memory management                    | processors |
| hardware abstraction                 | memory  |
| process management                   | mass storage |
| inter-process comms (IPC)            | communications channels |
|                                      | devices (timers, GPUs, DSPs, peripherals...) |
                           
## Kernel: definition {#kernel-definition}

![kernel]({% link assets/lectures/week-12/os-kernel.png %}){:style="width:50%; float:right;"}

the **kernel** is the program (functions, data structures in memory, etc.) which
performs the *core* role(s) of the OS

access to the CPU, memory, peripherals all happens *through* the kernel through
a [system call](#system-calls-with-svc)


## Monolithic OS - Modular - μKernels

![Monolithic OS]({% link assets/lectures/week-10/monolithic-OS-diagram.png %}){:style="width:30%; float:left;"}

![Monolithic & Modular OS]({% link assets/lectures/week-10/modular-OS-diagram.png %}){:style="width:30%; float:left;"}

![microkernel OS]({% link assets/lectures/week-10/microkernal-OS-diagram.png %}){:style="width:30%; float:left;"}

{% include slides/talk.html %}

Why are kernels and (user) programs separate? 

How are they different? 

Aren't they both programs?

## Process: definition {#process-definition}

![process control block]({% link assets/lectures/week-10/process-control-block.png %}){:style="width:20%; float:right;"}

{:style="display:inline;"}

-  a *running* program
- includes the code (instructions) for the program, and the current state/context:
- registers/flags
- memory (stack and heap)
- permissions/privileges
- other resources (e.g. global variables, open files & network connections,
  address space mappings)
  
## Mapping processes to CPUs

![1 CPU per control-flow]({% link assets/lectures/week-10/1-cpu-per-control-flow.png %}){:style="width:30%; float:left;"}

![1 CPU for all control-flows]({% link assets/lectures/week-10/1-cpu-all-control-flows.png %}){:style="width:30%; float:left;"}

![Symmetric multiprocessing]({% link assets/lectures/week-10/symmetric-multiprocessing.png %}){:style="width:30%; float:left;"}

{:.center}
# Architecture

## Architecture Main Topics (in short)

- History of computing architectures
- Harvard vs von Neumann architecture
- Pipelines
- Out-of-order execution
- Vector/SIMD instructions
- Hyper-threading
- Multi-core computing
- Virtual Memory
- Alternative architectures (Parallax Propeller)

## A simple CPU {#a-simple-cpu}

![a simple CPU]({% link assets/lectures/week-11/simple-CPU.png %}){:style="width:40%; float:right;"}

{:style="display:inline; font-size:0.8em; margin:0 0 0 0;"}

- **decoder/sequencer** converts instructions into CPU control signals
- **arithmetic logic unit** (ALU) performs maths & logic operations
- **registers** provide small, fast storage to the CPU
- **flags** indicate the states of the latest calculations
- **code/data management** for loading/storing, caching
- **memory**

Are any of these components unneccessary?

## Simple Pipeline

![A simple three-stage pipeline]({% link assets/lectures/week-11/instruction-pipelining.png %})

What can go wrong in a pipeline?

## Vector/SIMD vs hyper-threading vs multi-core

![CPU with SIMD]({% link assets/lectures/week-11/CPU-with-SIMD.png %}){:style="width:30%; float:left;"}

![hyperthreaded CPU]({% link assets/lectures/week-11/CPU-with-hyperthreading.png %}){:style="width:30%; float:left;"}

![multicore CPU]({% link assets/lectures/week-11/CPU-multicore.png %}){:style="width:30%; float:left;"}

What are the differences?

## Virtual Memory

![lectures/week-12/virtual-memory.png]({% link assets/lectures/week-12/virtual-memory.png %})

Is virtual memory an architecture (hardware) topic or an OS (software)
topic?

{% include slides/background-image.html
    image="lectures/week-12/comp2300-topic-map.png"
    bgsize="contain" %}

{% include slides/impact.html %}

**Finally** done. That was epic, thanks for coming with me everybody!



