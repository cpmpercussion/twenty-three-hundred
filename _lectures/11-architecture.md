---
title: Architecture and Organisation
summary: CPU architectures from 1937 to now
permalink: /lectures/week-11/
image: assets/lectures/all/cpm-reykjavic.jpg
---

{% include slides/title.html %}

{% include slides/background-image.html
           image="lectures/all/all-todos.jpg"
           heading="Admin Time"  %}

Assignment 2 due _Sunday_ 22/5/2022 23:59 AEST

Lab 11 starts tomorrow -- keep going to labs!

Lab Pack 4 due: Wednesday 1/6/2022 23:59 AEST (day before exam period)

{:.center}
# Week 11: Architecture

What is a computer again?

{% include slides/background-image.html
           image="lectures/all/cpm-nicta.jpg"  %}

{% include slides/background-image.html
           image="lectures/all/cpm-kinkakuji.jpg"  %}

{% include slides/background-image.html
           image="lectures/all/cpm-castle.jpg"  %}

## Outline

- [a basic computer](#basics)
- [origins](#origins)
- [architectures](#architectures-section)
- [alternatives?](#alternatives)
- [visual ARM1](#visual-arm1-simulation)

## A basic computer... {#basics}

![MOS6502]({% link assets/lectures/week-11/R6502.png %})

{% include slides/background-image.html
           image="lectures/week-11/replica1.jpg"
           heading="Don't we need more stuff?"  %}

## Don't we need more stuff?

![replica1 diagram]({% link assets/lectures/week-11/replica1-diagram.png %})

{:.center}
# Origins {#origins}

{% include slides/background-image.html
           image="lectures/week-11/Zuse_Z1-2.jpg"
           heading="The Z1 (1937)"  %}

created by Konrad Zuse

first digital computer: relays, programmable via punch tape, 1 Hz clock, 64
words of memory @ 22-bit, 2 registers, floating point unit, weight 1 ton

[image](https://en.wikipedia.org/wiki/Z1_(computer)#/media/File:Zuse_Z1-2.jpg) from
[ComputerGeek](https://de.wikipedia.org/wiki/User:ComputerGeek), [CC BY-SA
3.0](http://creativecommons.org/licenses/by-sa/3.0/)

{% include slides/background-image.html
           image="lectures/week-11/Z3_Deutsches_Museum.JPG"
           heading="Z3 (1941)"  %}

first freely programmable (Turing complete) computer, relays, 5.3 Hz clock


[image](https://en.wikipedia.org/wiki/Z3_(computer)#/media/File:Z3_Deutsches_Museum.JPG) from
[Venusianer](https://de.wikipedia.org/wiki/User:Venusianer), [CC BY-SA
3.0](http://creativecommons.org/licenses/by-sa/3.0/)

{% include slides/background-image.html
           image="lectures/week-11/Eniac.jpg"
           heading="ENIAC (1945)"  %}

ENIAC: first Turing complete vacuum-tube computer, 100 kHz clock, weight 27
tons, size 167 sq m


[image](https://commons.wikimedia.org/wiki/File:Eniac.jpg) from [U.S. Army
Photo](https://de.wikipedia.org/wiki/User:Venusianer), public domain

{% include slides/impact.html %}

... then came the **microbit**

{:.fragment}

*(not really)*

{:.center}
# Architectures {#architectures-section}

## Harvard architecture

![Harvard architecture]({% link assets/lectures/week-11/harvard-architecture.png %}){:style="width:40%; float:right;"}

**control unit** concurrently addresses program and data memory and fetches next
instruction---controls next ALU operations and instruction based on ALU status

**Arithmetic Logic Unit** (ALU) fetches data from memory, executes
arithmetic/logic operations, and writes data to memory

separate memory for program & data

## von Neumann architecture

![von Neumann architecture]({% link assets/lectures/week-11/von-neumann-architecture.png %}){:style="width:40%; float:right;"}


**control unit** sequentially addresses program and data memory and fetches next
instruction---controls next ALU operations and instruction based on ALU status

**Arithmetic Logic Unit** (ALU) fetches data from memory, executes
arithmetic/logic operations, and writes data to memory

program and data memory not distinguished (so programs can change themselves)

## A simple CPU {#a-simple-cpu}

![a simple CPU]({% link assets/lectures/week-11/simple-CPU.png %}){:style="width:40%; float:right;"}

**decoder/sequencer** converts instructions into CPU control signals

**arithmetic logic unit** (ALU) performs maths & logic operations

**registers** provide small, fast storage to the CPU

**flags** indicate the states of the latest calculations

**code/data management** for loading/storing, caching

**memory**

## Pipeline

![pipelined CPU]({% link assets/lectures/week-11/CPU-with-pipelining.png %}){:style="width:40%; float:right;"}

some CPU actions are naturally sequential (e.g.
[fetch-decode-execute]({% link _lectures/02-alu-operations.md
%}#fetch-decode-execute)).

an **instruction pipeline** allows these sequences to be overlapped in *time*

same latency, but higher throughput

{% include slides/background-image.html
           image="lectures/week-11/gordon-williams-228787-unsplash.jpg"
           %}
           
## Simple Pipeline

![A simple three-stage pipeline]({% link assets/lectures/week-11/instruction-pipelining.png %})

{% comment %}
- https://www.anandtech.com/show/12785/arm-cortex-a76-cpu-unveiled-7nm-powerhouse/2 
- https://www.anandtech.com/Show/Index/2493?cPage=2&all=False&sort=0&page=11&slug=
{% endcomment %}

## Pipeline example

{:.stretch}
![ARM Cortex-M3/4 pipeline]({% link assets/lectures/week-11/arm-cortex-m4-pipeline.png %})

(from p15. [ARM Cortex-M Programming Guide to Memory Barrier Instructions]({{site.arm_cortex_programming_memory_barrier_url}}))

(conditional) branches might break the pipelines (requiring a "flush").

## Pipeline Hazards

- [Hazards](http://web.cs.iastate.edu/~prabhu/Tutorial/PIPELINE/hazards.html) are circumstances that prevent the pipeline from working efficiently.
- **Data**: When the outcome of one instruction is required to execute
  the next.
- **Structural**: When part of the CPU hardware required by two
  instructions simultaneously (e.g., memory to fetch and store simultaneously).
- **Control**: When the location of the next branch is unknown until an instruction is executed. 

## How do you deal with these?

- Add "bubbles" in the pipeline?
- branch prediction?
- out-of-order execution?
- all these have [downsides](https://en.wikipedia.org/wiki/Spectre_(security_vulnerability))

{% include slides/background-image.html
           image="lectures/week-11/pacino-out-of-order.jpg" 
           bgsize="contain" %}

## Out-of-order execution

![CPU with out-of-order execution]({% link assets/lectures/week-11/CPU-with-out-of-order.png %}){:style="width:40%; float:right;"}

re-ordering the sequence inside each pipeline leads to 'out of order' CPU designs

pipeline becomes a hardware scheduler, and results need to be
"re-sequentialised" (or possibly discarded)

finer-grained sequences can be introduced by breaking CPU instructions into
micro code (better if there are more independent instructions)

## Out-of-order example

$ f(a, b, c) = (a + b) \times c $

```arm
@ in-order
ldr r0, =0x20000000
ldr r1, [r0] @ load a into r1
ldr r2, [r0, 4] @ load b into r2
ldr r3, [r0, 8] @ load c into r3
add r1, r1, r2  @ add a and b
mul r0, r1, r3  @ (a + b) * c
```
{:style="width:48%; float:left; margin-right:2%; font-size:0.8em;"}


```arm
@ out-of-order
ldr r0, =0x20000000
ldr r1, [r0]
ldr r2, [r0, 4]
add r1, r1, r2  @ these two are
ldr r3, [r0, 8] @ switched around
mul r0, r1, r3
```
{:style="width:48%; float:right; margin-left:2%; font-size:0.8em;"}

[Computerphile](https://www.youtube.com/watch?v=_qvOlL8nhN4) has a more detailed
explanation

{% include slides/background-image.html
           image="lectures/week-11/fineas-anton-437552-unsplash.jpg"
           heading="it's not <em>quite</em> magic, but..."  %}

{:.center}
# Multiprocessing

## SIMD/vector processing {#simd-vector-processing}

![CPU with SIMD]({% link assets/lectures/week-11/CPU-with-SIMD.png %}){:style="width:40%; float:right;"}

**S**ingle **I**nstruction **M**ultiple **D**ata ALUs provide the facility to
apply the same instruction to multiple "datas" concurrently

often requires special "wide" registers and new instructions (e.g. fitting 4
32-bit values into one 128-bit register, then adding them all using one SIMD
instruction)

requires specialised compilers or programming languages with implicit
concurrency

*examples*: NEON, Altivec, MMX, SSE2/3/4, AVX

## Hyper-threading

![hyperthreaded CPU]({% link assets/lectures/week-11/CPU-with-hyperthreading.png %}){:style="width:40%; float:right;"}

emulates multiple "virtual" CPU cores by replicating:

{:style="display:inline; font-size:0.8em; margin:0 0 0 0;"}
- register sets
- decoder/sequencer
- flags
- interrupt logic

while sharing other resources like the ALU, data management

*examples*: Intel Core i-series, POWER9 (up to 8 threads per core)

{% include slides/talk.html %}

what sort of workloads would benefit from SIMD? how about hyperthreading?

## Multi-core CPUs

![multicore CPU]({% link assets/lectures/week-11/CPU-multicore.png %}){:style="width:40%; float:right;"}

full replication of multiple CPU cores on the same chip package

often combined with the other techniques discussed

cleanest and most explicit implementation of concurrency on the CPU level

requires synchronised atomic operations, and programming languages with implicit
or explicit concurrency

## Flynn's Taxonomy (1966)

Classification system for [processor functionalities](https://en.wikipedia.org/wiki/Flynn%27s_taxonomy):

|                      | single data          | multiple data    |
|----------------------|----------------------|------------------|
| single instruction   | SISD - uniprocessing | SIMD (SSE, NEON) |
| multiple instruction | MISD? (??)           | MIMD (multi-core processors) |

Which of these are common today?

{:.center}
# Amazing parallel computers of today

{% include slides/background-image.html
           image="lectures/week-11/smartphone.jpg"
           heading="Your phone!"  %}

## ARM [big.LITTLE architecture](https://en.wikipedia.org/wiki/ARM_big.LITTLE)

![biglittle]({% link assets/lectures/week-11/biglittle.png %}){:style="width:40%; float:right;"}

[Heterogeneous computing architecture](https://youtu.be/KClygZtp8mA
)

"little" cores: efficient and power saving (use these most of the time)

"big" cores: powerful but power-hungry (use these just in bursts)

all cores have access to same memory regions

scheduler figures out where to execute threads

e.g., Apple A11 (2 big cores, 4 little)

{% include slides/background-image.html
           image="lectures/week-11/gpu.jpg"
           heading="Your gaming PC!"  %}

## NVIDIA GPU architectures

![NVIDIA SM]({% link assets/lectures/week-11/nvidia-sm.jpg %}){:style="width:35%; float:right;"}

GPUs are **highly parallel** processors

focussed on bandwidth, not latency

NVIDIA uses [CUDA (computer unified device architecture).](https://en.wikipedia.org/wiki/CUDA)

One CUDA SM (streaming multiprocessor) has **lots of cores** (~ALUs)

Image: [Copyright NVIDIA.](https://images.nvidia.com/content/volta-architecture/pdf/volta-architecture-whitepaper.pdf)

{% include slides/background-image.html
           image="lectures/week-11/nvidia-v100.jpg"
           heading="NVIDIA Volta Architecture (V100) layout"  %}

One GPU has **lots** of SMs! RTX 2080 ti = 68 SMs, Tesla V100 = 84 SMs! (5376 cores!)

Image: [Copyright
NVIDIA](https://images.nvidia.com/content/volta-architecture/pdf/volta-architecture-whitepaper.pdf),
[more](https://www.dcce.ibilce.unesp.br/~aleardo/cursos/arqcomp/Introduction-to-GPUs.pdf)
 [resources](https://medium.com/@smallfishbigsea/basic-concepts-in-gpu-computing-3388710e9239)
{:style="position:fixed; bottom:0; left:0; margin-bottom:0;"}

{:.center}
# Alternatives? {#alternatives}

{% include slides/background-image.html
           image="lectures/week-11/digicomp1.jpg"
           heading="Digital Computing in Plastic!"  %}
           

## Parallax Propeller

{:.stretch}
![Parallax propeller]({% link assets/lectures/week-11/parralax-propeller.png %})

## Embedded Programming without Interrupts

<iframe class="stretch" src="https://www.youtube.com/embed/Iuf44VCMh60?rel=0&amp;showinfo=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## RISC-V

![RISC-V logo]({% link assets/lectures/week-11/risc-v-logo.jpg %}){:style="width:40%; float:right;"}

<https://riscv.org/>

*The Free and Open RISC Instruction Set Architecture*

a collaborative design effort

small core ISA with lots of optional "extensions" (e.g. floating point, SIMD/vector ops)

this allows it to scale from embedded to HPC (in *principle*)

{% include slides/background-image.html
           image="lectures/week-11/james-hammond-541018-unsplash.jpg"
           heading="Intel x86/amd64?"  %}

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Visual ARM1 simulation"
		   id="visual-arm1-simulation"  %}

ARM1 chip (created in 1985) is the ancestor of all smartphone chips, and also
the microbit

check out this [visual ARM1
simulation](http://visual6502.org/sim/varm/armgl.html) (runs in the web browser)

also see [Ken Shirrif's explanation](http://www.righto.com/2015/12/reverse-engineering-arm1-ancestor-of.html)

{% include slides/impact.html %}

do you (kindof) **get it**?

{% include slides/background-image.html
           image="lectures/week-11/replica1.jpg"
           heading="Replica 1 Demo!"  %}

## Replica 1 Demo

Let's have a look at an Apple I... replica! (1975)

- modern replica of Apple I computer 
- [Serial Programming](http://sowerbutts.com/replica1-serial/)
- No OS (has a "monitor" program and BASIC interpreter in ROM).
- MOS6502 processor, [6821 peripheral interface adapter](https://en.wikipedia.org/wiki/Peripheral_Interface_Adapter) (PIA), one bank
  of RAM, one ROM
- Modern things: USB serial adapter, Parallax Propeller (drives video
  and manages keyboard).
  
## Make your own?

- [Ben Heck Apple 1 Replica Build](https://github.com/thebenheckshow/158-tbhs-apple-1-replica)
- Get parts from [AliExpress/Ebay](https://www.aliexpress.com/item/33003055433.html), grab a soldering iron and start hacking!
- Alternative--Z80 computer with a "new" design: [RC2014](https://rc2014.co.uk)
- Build computer just from [logic gates](https://eater.net/8bit/)?

{:.stretch}
![lectures/week-11/homebrew-computers.jpg]({% link assets/lectures/week-11/homebrew-computers.jpg %})

{% include slides/background-image.html
           image="lectures/all/all-reading.jpg"
           heading="Further Reading"  %}

[Essentials of Computer Organisation and Architecture (Null) - Ch. 1.9](https://learning.oreilly.com/library/view/essentials-of-computer/9781284123043/xhtml/06_Chapter01_08.xhtml#ch1-sec1-9)

[Essentials of Computer Organisation and Architecture (Null) - Ch. 1.10](https://learning.oreilly.com/library/view/essentials-of-computer/9781284123043/xhtml/06_Chapter01_08.xhtml#ch1-sec1-10)

[Essentials of Computer Organisation and Architecture (Null) - Ch. 1.11](https://learning.oreilly.com/library/view/essentials-of-computer/9781284123043/xhtml/06_Chapter01_10.xhtml#ch1-sec1-11)

[Essentials of Computer Organisation and Architecture (Null) - Chapter 9](https://learning.oreilly.com/library/view/essentials-of-computer/9781284123043/xhtml/14_Chapter09.xhtml#ch9)

GPU Topics [Multicore and GPU Programming](https://learning.oreilly.com/library/view/multicore-and-gpu/9780124171374/)

{% include slides/background-image.html
           image="lectures/all/all-questions.jpg"
           heading="Questions"  %}
