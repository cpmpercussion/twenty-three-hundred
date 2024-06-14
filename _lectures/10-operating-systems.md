---
title: Operating Systems
summary: A safe, comfortable home for your programs
permalink: /lectures/week-10/
image: assets/lectures/week-10/IBM704-1957.jpg
---

{% include slides/title.html %}

{% include slides/background-image.html
           image="lectures/all/all-todos.jpg"
           heading="Admin Time"  %}

Little wires and alternatives---[see details here]({% link _resources/14-getting-jumper-wires.md %})

{:.center}
# Week 10: Operating Systems

## Outline

- [what is an OS?](#what-is-an-os)
- [privilege levels](#privilege-levels)
- [processes & scheduling](#processes-scheduling)

{:.center}
# What is an OS? {#what-is-an-os}

{% include slides/background-image.html
           image="lectures/week-10/os-logos.png" 
           bgsize="contain" %}

<!-- [source: iconscout](https://iconscout.com/icon-pack/operating-system-2) -->

{% include slides/talk.html %}

what *is* an **operating system** (OS)?

## ...it's a virtual machine

offering a more familiar, comfortable and safer environment for your programs to
run in

- memory management
- hardware abstraction
- process management
- inter-process communication (IPC)

## ...it's a resource manager {#its-a-resource-manager}

co-ordinating access to hardware resources

- processors
- memory
- mass storage
- communication channels
- devices (timers, GPUs, DSPs, other peripherals...)

{:.fragment}

multiple tasks/processes/programs may be applying for access to these resources!

{:.center}
# A brief history of operating systems... {#os-history}

{% include slides/background-image.html
           image="lectures/week-10/IBM704-1957.jpg"
           heading="1950s-60s: system monitors" %}

IBM 704 mainframe at NACA in 1957

NASA / Public Domain

{% include slides/background-image.html
           image="lectures/week-10/Atlas-1963.jpg"
           heading="1960s - multi-programming system" %}

University of Manchester Atlas, January 1963

Iain MacCallum / CC BY (https://creativecommons.org/licenses/by/3.0)

{% include slides/background-image.html
           image="lectures/week-10/Pdp-11.jpg"
           heading="1970s - multi-tasking systems" bgsize="contain" %}

DEC PDP-11

Stefan_Kögl / CC BY-SA (http://creativecommons.org/licenses/by-sa/3.0/)

{% include slides/background-image.html
           image="lectures/week-10/xerox-alto.jpg"
           heading="1970s - early workstations..." bgsize="contain" %}

Xerox Alto

Joho345 / Public domain

{% include slides/background-image.html
           image="lectures/week-10/Trinity77.jpg"
           heading="1970s-80s: Consumer OSs" 
           bgsize="contain" %}

Springsgrace / CC BY-SA (https://creativecommons.org/licenses/by-sa/4.0)


{% include slides/background-image.html
           image="lectures/week-10/NeXTstation.jpg"
           heading="1990s+" bgsize="contain" %}

NeXTStation

Blake Patterson / CC BY (https://creativecommons.org/licenses/by/2.0)

## A brief history of operating systems (1)

{: style="font-size:0.8em;"}
in the beginning: single user, single program, single task, serial processing---no OS

- 50s: system monitors/batch processing
  - the monitor ordered the sequence of jobs and triggered their sequential execution
- 50s-60s: advanced system monitors/batch processing:
  - the monitor handles interrupts and timers
  - first support for memory protection
  - first implementations of privileged instructions (accessible by the monitor only)
- early 60s: multi-programming systems:
  -  use the long device I/O delays for switches to other runnable programs
- early 60s: multi-programming, time-sharing systems:
  - assign time-slices to each program and switch regularly

## A brief history of operating systems (2)

{: style="font-size:0.8em;"}
- early 70s: multi-tasking systems
  – multiple developments resulting in UNIX (and others)
- early 80s: single user, single tasking systems, with emphasis on user interface or APIs. MS-DOS, CP/M, MacOS and others first employed 'small scale' CPUs (personal computers).
- mid-80s: Distributed/multiprocessor operating systems - modern UNIX systems (SYSV, BSD)
- late 70s: Workstations starting by porting UNIX or VMS to 'smaller' computers.
- 80s: PCs starting with almost none of the classical OS-features and services, but with an user-interface (MacOS) and simple device drivers (MS-DOS)

## A brief history of operating systems (3)

{: style="font-size:0.8em;"}
- last 20 years: evolving and expanding into current general purpose OSes, like for instance:
  - Solaris (based on SVR4, BSD, and SunOS, and pretty much dead now)
  - Linux (open source UNIX re-implementation for x86 processors and others)
  - current Windows (used to be partly based on Windows NT, which is 'related' to VMS)
  - MacOS (Mach kernel with BSD Unix and a proprietary user-interface)
- multi-processing is supported by all these OSes to some extent
  - but not (really) suitable for embedded, or real-time systems



## Standard features?

is there a standard set of features for operating systems?

**no.**

the term *operating system* covers everything from 4 kB microkernels, to > 1 GB
installations of desktop general purpose operating systems

## Minimal set of features?

**is there a *minimal* set of features?**

almost: memory management, process management and inter-process communication/synchronisation would be considered essential in most systems

**is there always an explicit operating system?**

no: some languages and development systems operate with standalone runtime environments

## Process management

(we'll talk more about this [in a moment](#processes-scheduling))

basically, this is the task of keeping multiple things going all at once...

...while tricking them all into thinking they're the main game

{% include slides/talk.html %}

what's a task?

## Memory management

remember memory? the OS is responsible for sharing it around

- allocation / deallocation
- virtual memory: logical vs. physical addresses, segments, paging, swapping, etc.
- memory protection (privilege levels, separate virtual memory segments, ...)
- shared memory (for performance, communication, ...)

## Synchronisation/inter-process communication

remember all the [asynchronism]({% link _lectures/index.md
%}#async-interrupts-concurrency) stuff? the OS is responsible for managing that
as well

semaphores, mutexes, condition variables, channels, mailboxes, MPI, etc.

this is tightly coupled to scheduling / task switching!

## Hardware abstraction

remember all the specific load-twiddle-store addresses in the labs? no?

good news everyone! the OS does so you don't have to

- device drivers
- protocols, file systems, networking, everything else...

all through a consistent API

## Kernel: definition {#kernel-definition}

the **kernel** is the program (functions, data structures in memory, etc.) which
performs the *core* role(s) of the OS

access to the CPU, memory, peripherals all happens *through* the kernel through
a [system call](#system-calls-with-svc)

{% include slides/background-image.html
           image="lectures/week-10/pranay-pareek-489128-unsplash.jpg"  %}

{% include slides/background-image.html
           image="lectures/week-10/torsten-muller-30382-unsplash.jpg"  %}

{% include slides/background-image.html
           image="lectures/week-10/herson-rodriguez-96102-unsplash.jpg"  %}

{% include slides/info.html %}

if you want to look at some real system call APIs

on Linux,
- [`syscalls.h` header file](https://github.com/torvalds/linux/blob/master/include/linux/syscalls.h)
- [how to add a new system call](https://www.kernel.org/doc/html/v4.10/process/adding-syscalls.html)

on Windows,
- [Windows API Index](https://msdn.microsoft.com/en-us/library/windows/desktop/ff818516(v=vs.85).aspx)

{% include slides/impact.html %}

writing an OS seems **complicated**

how is it done in practice?

## Monolithic OS

![Monolithic OS]({% link assets/lectures/week-10/monolithic-OS-diagram.png %}){:style="width:20%; float:right;"}

*(or 'the big mess...')*

{: style="font-size:0.8em;"}
- non-portable/hard to maintain
- lacks reliability
- all services are in the kernel (on the same privilege level)
- but: may reach high efficiency

{: style="font-size:0.8em;"}
e.g.:
most early UNIX systems, MS-DOS (80s),
Windows (all non-NT based versions)
MacOS (until version 9), etc...

## Monolithic & Modular OS

![Monolithic & Modular OS]({% link assets/lectures/week-10/modular-OS-diagram.png %}){:style="width:20%; float:right;"}

{: style="font-size:0.8em;"}
- modules can be platform independent
- easier to maintain and to develop
- reliability is increased
- all services are still in the kernel (on the same privilege level)
- may reach high efficiency

e.g., current Linux versions

## μKernels & client-server models


![microkernel OS]({% link assets/lectures/week-10/microkernal-OS-diagram.png %}){:style="width:20%; float:right;"}

{: style="font-size:0.8em;"}
- μkernel implements essential process, memory, and message handling
- all 'higher' services are user level servers
- kernel ensures reliable message passing between clients and servers
- highly modular, flexible & maintainable
- servers can be redundant and easily replaced
- (possibly) reduced efficiency through increased communications

e.g., current research projects, μ, L4, Minix 3, etc.



{% include slides/background-image.html
           image="lectures/week-10/this-is-a-Unix-system-I-know-this.png"
           id="unix" %}

## Example: UNIX

- hierarchical file-system (maintained via `mount` and `unmount`)
- universal file-interface applied to files, devices (I/O), as well as IPC
- dynamic process creation via duplication
- choice of shells
- internal structure as well as all APIs are based on C
- relatively high degree of portability

many versions/flavours: UNICS, UNIX, BSD, XENIX, System V, QNX, IRIX, SunOS,
Ultrix, Sinix, Mach, Plan 9, NeXTSTEP, AIX, HP-UX, Solaris, NetBSD, FreeBSD,
Linux, OPENSTEP, OpenBSD, Darwin, QNX/Neutrino, OS X, QNX ROTS, ...

{:.center}
# Privilege levels {#privilege-levels}

{% include slides/talk.html %}

what do you think privilege means?

how does it affect your code running on the microbit?

## Privilege

![Privilege Rings]({% link assets/lectures/week-10/privilege-levels.png %})
{:.stretch}

## Privilege levels {#privilege-levels-2}

<!-- TODO -->

certain instructions can only be executed in "privileged" mode---this is
enforced in **hardware**

different architectures enforce this in different ways

check the manual (e.g. *Section A2.3.4* on p32 or *Table B1-1 Mode* on p568 of the [ARMv7-M reference
manual]({{site.armv7_architecture_ref_url}})


[Fun video for the nostalgic: What is DOS protected mode?](https://youtu.be/XAyQLV5bbb0)

## ARMv7-M execution levels

|                    | **thread** mode   | **handler** mode                        |
| :----------------- | :---------------- | :-------------------------------------- |
| **privileged**     | regular code      | all exceptions (including interrupts)   |
| **unprivileged**   | regular code      | n/a                                     |

priviliges may control:
- code execution
- memory read/write access
- register access (e.g., for peripherals)

## "Supervisor call" instruction

have you noticed these entries in the vector table in labs?

```arm
	.word	SVC_Handler
    @ ...
	.word	PendSV_Handler
```

the `svc` instruction (A7.7.175 in the [reference manual]({{site.armv7_architecture_ref_url}})) runs the
`SVC_Handler` immediately

{:.stretch}
![SVC instruction encoding]({% link assets/lectures/week-10/svc-instruction-encoding.png %})

## Deferred supervisor call (PendSV)

there's a **PENDSVSET** bit (bit 28) in the Interrupt Control and State Register
(`ICSR`)

if set, the `PendSV_Handler` will be called according to the usual
interrupt/exception priority rules

both `SVC_Handler` and `PendSV_Handler` run in privileged mode, like *all* interrupts

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="System calls with <code>svc</code>"
		   id="system-calls-with-svc"  %}

How might we implement a system call on a microbit?

How can we get at the argument? (Hint: see Figure B1-3 from the ARM-v7 M architecture reference)

How do [system calls work in linux](https://youtu.be/FkIWDAtVIUM)?


{:.center}
# Types of Operating Systems {#os-types}

## Distributed operating systems

- all CPUs carry a small kernel operating system for communication services
- all other OS services are distributed over available CPUs
- services may migrate
- services can be multiplied in order to guarantee availability (hot stand-by),
  or to increase throughput (heavy duty servers)

## Real-time operating systems {#rtos}

<ul>
<li>
<span>fast context switches?</span>
<span class="fragment" style="float:right;">should be fast anyway</span>
</li>
<li>
<span>small size?</span>
<span class="fragment" style="float:right;">should be small anyway</span>
</li>
<li>
<span>quick response to external interrupts?</span>
<span class="fragment" style="float:right;">not <em>quick</em>, but predictable</span>
</li>
<li>
<span>multitasking?</span>
<span class="fragment" style="float:right;">often, not always</span>
</li>
<li>
<span>'low level' programming interfaces?</span>
<span class="fragment" style="float:right;">needed in many operating systems</span>
</li>
<li>
<span>interprocess communication tools?</span>
<span class="fragment" style="float:right;">needed in almost all operating systems</span>
</li>
<li>
<span>high processor utilisation?</span>
<span class="fragment" style="float:right;">fault tolerance builds on redundancy</span>
</li>
</ul>

{% include slides/background-image.html
 image="lectures/week-10/bela-guitars2.jpg"
 heading="Real-time OS for music?"
 id="rtos-music"  %}

{% include slides/background-image.html
 image="lectures/week-10/uio-robot-surgery.jpg"
 heading="Real-time OS for robots?"
 id="rtos-robots"  %}

{% include slides/background-image.html
 image="lectures/week-10/IanMaddox_TeslaX_CCSABY4.jpg"
 heading="Real-time OS for cars?"
 id="rtos-cars" %}

## Real-time operating systems need to provide...

the **logical correctness** of the results as well as the correctness of the **time**:
*what* and *when* are both important

all results are to be delivered **just-in-time**---not too early, not too late.

timing constraints are specified in many different ways... often as a
response to **external** events (reactive systems)

{% include slides/impact.html %}

**predictability**, not performance!

{% include slides/background-image.html
           image="lectures/week-10/wang-xi-514760-unsplash.jpg"
           heading="Embedded Operating Systems"  %}

usually real-time systems, often hard real-time systems

very small footprint (often a few kBytes)

none or limited user-interaction

most processors in the world are in embedded systems


{:.center}
# Processes & scheduling {#processes-scheduling}

{% include slides/background-image.html
           image="lectures/week-10/process.jpg"
           heading="Trust the Process" %}

{% include slides/talk.html %}

(if you've got your laptop here) how many processes are running on your machine
right now?

how about on your phone?

## Process: definition {#process-definition}

basically: a *running* program

includes the code (instructions) for the program, and the current state/context:
- registers/flags
- memory (stack and heap)
- permissions/privileges
- other resources (e.g. global variables, open files & network connections,
  address space mappings)
  
{% include slides/background-image.html
           image="lectures/week-10/jurassic-park-unix-2.jpg"
           heading="processes as far as the eye can see" %}

{% include slides/impact.html %}

exact definition of process

**depends on the OS**

{% include slides/impact.html %}

so how do we **manage** them?

## 1 CPU per control-flow {#one-cpu-per-control-flow}

![1 CPU per control-flow]({% link assets/lectures/week-10/1-cpu-per-control-flow.png %}){:style="width:40%; float:right;"}

specific configurations only, e.g.:
- distributed microcontrollers
- physical process control systems

1 cpu per task, connected via a bus system
- Process management (scheduling) not required
- Shared memory access need to be coordinated

## 1 CPU for all control-flows {#one-cpu-for-all-control-flows}

![1 CPU for all control-flows]({% link assets/lectures/week-10/1-cpu-all-control-flows.png %}){:style="width:40%; float:right;"}

the OS may "emulate" one CPU for every control-flow

this is a **multi-tasking operating system**

{:style="display:inline;"}

- support for memory protection essential
- process management (scheduling) required
- shared memory access need to be coordinated

## Symmetric multiprocessing (SMP)

![Symmetric multiprocessing]({% link assets/lectures/week-10/symmetric-multiprocessing.png %}){:style="width:40%; float:right;"}

all CPUs share the same physical address space (and have access to the same
resources) so any process can be executed on any available CPU

## Processes vs threads

*processes* (as discussed [earlier](#process-definition)) have their own
registers, stack, resources, etc.

*threads* have their own registers & stack, but share the other process
resources

one process can create/manage many threads

![lectures/week-10/threads-to-array-task.png]({% link assets/lectures/week-10/threads-to-array-task.png %})

## Torvalds vs Threads

![lectures/week-10/torvalds-processes.png]({% link assets/lectures/week-10/torvalds-processes.png %})

{% include slides/background-image.html
           image="lectures/all/all-history.jpg"
           heading="\"Depends on the implementation\"..."  %}

## Process Control Blocks (PCBs) {#process-control-blocks}

![process control block]({% link assets/lectures/week-10/process-control-block.png %}){:style="width:20%; float:right;"}

{:style="display:inline;"}

- process ID
- process state: {created, ready, executing, blocked, suspended, bored ...}
- scheduling attributes: priorities, deadlines
- CPU state: (e.g. registers, stack pointer)
- memory attributes/privileges: permissions, limits, shared areas
- allocated resources: open/requested devices and files, etc.

{% include slides/impact.html %}

a data structure for **processes**

## Process states

- **created**: the task is ready to run, but not yet considered by any dispatcher
- **ready**: ready to run (waiting for a free CPU)
- **running**: holds a CPU and executes
- **blocked**: not ready to run (waiting for a resource)
- **suspended**: swapped out of main memory (e.g. waiting for main memory space)

{% include slides/background-image.html
           image="lectures/week-10/process-state-transitions-1.png" 
           bgsize="contain" %}

## First come, first served (FCFS) scheduling {#fcfs-scheduling}

{:.stretch}
![first-come, first-served scheduling 1]({% link assets/lectures/week-10/fcfs-scheduling-1.png %})

- **Waiting time**: 0..11, average: 5.9
- **Turnaround time**: 3..12, average: 8.4

{:.fragment}

even a deterministic scheduling schema like FCFS can lead to different outcomes

## FCFS (again)

{:.stretch}
![first-come, first-served scheduling 2]({% link assets/lectures/week-10/fcfs-scheduling-2.png %})

- **Waiting time**: 0..11, average: 5.4 (was 5.9 before)
- **Turnaround time**: 3..12, average: 8.0 (was 8.4 before)

FCFS gives the shortest possible *maximal* turnaround time

## Round-robin (RR) scheduling

{:.stretch}
![Round-robin scheduling]({% link assets/lectures/week-10/rr-scheduling.png %})

- **Waiting time**: 0..5, average: 1.2
- **Turnaround time**: 1..20, average: 5.8

optimised for swift initial responses, but "stretches out" long tasks

bound maximal waiting time! (depended only on the number of tasks)

{% include slides/talk.html %}

when might you want to use FCFS scheduling? how about RR?

{% include slides/background-image.html
           image="lectures/week-10/jurassic-park-scheduling.jpg"
           heading="Again, a whirlwind tour of OSes"  %}

remember the concepts

{% include slides/impact.html %}

go build your own in labs.

{% include slides/background-image.html
           image="lectures/all/all-questions.jpg"
           heading="Questions"  %}

## Fun With Operating Systems

- [Kernel writing 101](https://arjunsreedharan.org/post/82710718100/kernels-101-lets-write-a-kernel)
- [Linux on an 8bit AVR](http://dmitry.gr/index.php?proj=07.+Linux+on+8bit&r=05.Projects)
- [How to make an operating system (WikiHow)](https://www.wikihow.com/Make-a-Computer-Operating-System)

{% include slides/background-image.html
           image="lectures/all/all-reading.jpg"
           heading="Further Reading"  %}

[Essentials of Computer Organisation and Architecture - Chapter 8.2: Operating Systems](https://learning.oreilly.com/library/view/essentials-of-computer/9781284123043/xhtml/13_Chapter08_01.xhtml#ch8-sec1-2)

[Nick Moffitt's $7 History of Unix](https://zork.net/seven-dollars/unix.html)

[LGR Tech Tales - How Digital Research Almost Ruled PCs](https://youtu.be/hJNaAG2BXow)
