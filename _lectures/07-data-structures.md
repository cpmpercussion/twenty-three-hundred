---
title: Data structures
summary: What to do when your data doesn't fit in registers
permalink: /lectures/week-7/
image: assets/lectures/week-7/erol-ahmed-48243-unsplash.jpg
---

{% include slides/title.html %}

## Week 7: Data Structures

- [why do we need data structures?](#motivation)
- [arrays](#arrays)
- [records](#records)
- [memory allocation](#memory-allocation)


{% include slides/background-image.html
           image="lectures/all/all-todos.jpg"
           heading="Admin Time"  %}

Assignment 1 results

Mid-semester Exam

Psyche up for second half of the course


{% include slides/background-image.html
           image="lectures/week-7/erol-ahmed-48243-unsplash.jpg"
	   id="motivation" 
	   heading="Why do we need data structures?"  %}

to structure our **data** (um, ok...)

to minimise bookkeeping

to make our lives easier

to play nicely with others

{:.center}
# Arrays {#arrays}

{% include slides/background-image.html
           image="lectures/all/all-bigpicture.jpg"
           heading="Arrays are for collections of homogeneous data"  %}

[Wikipedia](https://en.wikipedia.org/wiki/Array_data_structure) has more (as usual)

## You might need an array if you've got

- a string of ASCII characters (remember [Shouty McShoutface]({{site.baseurl}}{% link _lectures/04-control-flow.md %}#livecode-shouty-mcshoutface)?)
- an audio file (e.g. an array of 16-bit signed values to "send" to an audio output)
- a collection of red-green-blue (3 x 8-bit unsigned) values which represent a
  bitmap image

## Essential information for an array

An array is just a bunch of things, but here are the key things to figure out:
- what are the things?
- where are the things?
- how big are the things?
- how many things are there?

{% include slides/background-image.html
           image="lectures/week-7/nathan-dumlao-523529-unsplash.jpg"
           heading="Can you fit an array into a register?"  %}

{:.fragment}

probably not

{:.fragment}

need to store it in memory

{:.stretch}
{% include slides/background-image.html
           image="lectures/week-7/array-diagram-4-byte-elements.png" 
           bgsize="contain" %}

## Addressing

Array addressing is about reading and writing specific elements of the array

also called *indexing* (Latin: _indicō_ "point out, show")

``` c
//             the index
//                 ↓
int x = the_things[0]; // the 1st element
int y = the_things[4]; // the 5th element
```

## In assembly code

it's just [loads and stores]({% link
_lectures/03-memory-operations.md %}) (like you've been doing all along)

``` arm
  .data
the_things:
  .word 2, 3, 0, 0, 6, 3, 0, 0

  .text
get_elements:
  ldr r0, =the_things
  ldr r1, [r0]     @ the 1st element
  ldr r2, [r0, 16] @ the 5th element
```

{% include slides/background-image.html
           image="lectures/week-7/array-diagram-aligned-vs-unaligned.png"
           heading="Alignment" 
           bgsize="contain" %}

{% include slides/talk.html %}

what's the big deal? why are unaligned loads/stores a problem?

hint: check out the Cortex M4 Technical Reference Manual section on [load store timings](https://developer.arm.com/documentation/ddi0439/b/Programmers-Model/Instruction-set-summary/Load-store-timings)

{% include slides/impact.html %}

you can put *anything* in an array, not just **words**

{% include slides/background-image.html
           image="lectures/week-7/array-diagram-8-byte-elements.png" 
           bgsize="contain" %}

{% include slides/background-image.html
           image="lectures/week-7/array-diagram-packed-vs-padded.png" 
           bgsize="contain" %}

{% include slides/impact.html %}

abstract data type

**vs**

data structure

## Working with arrays

they don't fit in registers, so we have to operate on them one element at a time

{:.fragment}

we need **loops**!

## Array sum example

given an array of (word-size) integers, find the sum of the elements from
`from_index` to `to_index`

```c
int sum(int array[], int from_index, int to_index){
  int acc = 0; // the "accumulator" variable
  for(int i = from_index; i <= to_index; i++){
    acc += array[i];
  }
  return acc;
}
```

## The array in memory

```arm
  .data
array:
  .word 2, 3, 0, 0, 6, 3, 0, 0
```

back-of-the-envelope maths: the sum is 14 (0xE)

## Array sum setup

For the following examples, assume:
- the base address of the array is in `r0`
- the from (start) index is in `r1` (0 in the setup code below)
- the to (end) index is in `r2` (7 in the setup code below)

```arm
  ldr r0, =array @ base address
  mov r1, 0      @ from_index
  mov r2, 7      @ to_index
```

{% include slides/background-image.html
           image="lectures/week-7/array-sum-example-diagram-1.png" 
           bgsize="contain" %}


{% include slides/background-image.html
           image="lectures/week-7/array-sum-example-diagram-2.png" 
           bgsize="contain" %}

## Array sum #1

{: style="font-size:0.8em;"}

```arm
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
  
@ cleanup
  mov r0, r3
```

2 instructions in setup, 6 in loop

## Array sum #2

{: style="font-size:0.8em;"}

```arm
@ setup
  mov r3, 0 @ acc

array_sum:
  @ load with shifted index register
  ldr r6, [r0, r1, lsl 2]
  add r3, r6     @ update running total
  add r1, 1      @ increment index
  cmp r1, r2     @ keep looping?
  ble array_sum

@ cleanup  
end_array_sum:
mov r0, r3
```

1 instruction in setup, 5 in loop, no need to explicitly calculate the offset
(but size must be power of 2)

## Array sum #3

{: style="font-size:0.8em;"}

```arm
@ setup
  mov r3, 0     @ acc
  lsl r1, r1, 2 @ change index -> offset
  lsl r2, r2, 2 @ change index -> offset

array_sum:
  ldr r6, [r0, r1]
  add r3, r6    @ update running total
  add r1, 4     @ increment index
  cmp r1, r2
  ble array_sum

@ cleanup  
mov r0, r3
```

3 instruction in setup, 5 in loop

uses byte offset instead of element index

{% include slides/talk.html %}

any more ideas for how we could speed this up?

## Array sum #4

{: style="font-size:0.8em;"}

```arm
@ setup
  mov r3, 0      @ acc
  lsl r1, r1, 2  @ change index -> offset
  add r1, r0, r1 @ address of from element
  lsl r2, r2, 2  @ change index -> offset
  add r2, r0, r2 @ address of to element

array_sum:
  ldr r6, [r1], 4 @ load & post-index r1
  add r3, r6      @ update running total
  cmp r1, r2
  ble array_sum

@ cleanup  
  mov r0, r3
```

5 instructions in setup, **only 4 in loop**, note the [load with post-index]({% link _lectures/04-control-flow.md %}#load-and-store-with-offset)

## On optimisation...

loops are often the "hot" part of a program, therefore worth optimising

optimising compilers will do some *weird* things to get the most optimised code

in general, write simple code first, and optimise later (if necessary)

## Gotchas

- don't forget about [endianness]({% link _lectures/03-memory-operations.md %}#endianness)!
- remember, `ldr`/`str` still just loads **words**, not elements (it's
  convenient if your elements are word-sized, but watch out if they're not)
- no bounds checking so far!
- we weren't careful about the [AAPCS]({% link _lectures/05-functions.md %}#calling-conventions) in our array sum examples
  earlier

## Memory allocation for arrays

static: memory is set aside at compile-time (e.g. in the `.data` section)
- *pro*: allocation is already done when the program starts
- *con*: need to know the size of the array in advance

dynamic: memory is made available (e.g. on the stack) at run-time
- *pro*: can pick the best size at runtime, can re-size
- *con*: takes time (while program is running)

*we'll return to this later...*

## Better(?) array data structures

The arrays we've looked at so far are pretty bare-bones; containing just the raw
data (at runtime, anyway)

there are several improvements
- null-termination
- store array size alongside the data
- can we make a resizeable array?

{% include slides/background-image.html
           image="lectures/week-7/improved-arrays.png" 
           bgsize="contain" %}

{% include slides/background-image.html
           image="lectures/week-3/1s-and-0s.png"
           heading="Where are the array(s)?"  %}

{:.center}
# Records {#records}

{% include slides/background-image.html
           image="lectures/all/all-bigpicture.jpg"
           heading="Records are for collections of heterogeneous data"  %}

[Wikipedia](https://en.wikipedia.org/wiki/Record_%28computer_science%29) says:

A **record** is a collection of **fields**, possibly of different data types,
typically in fixed number and sequence. The fields of a record may also be
called members, ... or elements, though these risk confusion with the elements
of a collection.

{% include slides/background-image.html
           image="lectures/all/all-history.jpg"
           heading="Overloaded names!" %}

records might also be referred to as structs, tuples, objects

(although those terms can also mean different things)

**context** matters

{% include slides/background-image.html
           image="lectures/week-7/guillaume-bolduc-259596-unsplash.jpg" 
           heading="Array"  %}

{% include slides/background-image.html
           image="lectures/week-7/chuttersnap-485281-unsplash.jpg"
           heading="Record"  %}


## Simple examples

Suppose we are making character data for a computer game:
- HP (word)
- mana (word)
- name (16-byte, null-terminated ASCII array)

Or a basic synthesizer
- frequency (word)
- phase (word)
- amplitude (word)
- type (halfword)

{% include slides/background-image.html
           image="lectures/week-7/hearthpebble-synth-records.png" 
           bgsize="contain" %}

## Field ordering

what's the difference here?

{:.stretch}

![synth record field ordering]({% link assets/lectures/week-7/synth-record-alignment.png %})

{% include slides/impact.html %}

the **address** of the first element is all you need

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Records by request" %}

## Composite data structures

Things really get interesting and useful when we combine things
- records inside records (nested records)
- records of arrays
- arrays of records

Are these things OO *objects*? No. They have the variables but not the methods.

{:.center}
# Memory Allocation {#memory-allocation}

{% include slides/talk.html %}

what does it mean to allocate memory for an array?

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="<code>smalloc</code> (silly memory allocate)"  %}

Let's make a silly memory allocator

## Describing the `smalloc` function

At a *minimum*, our memory allocator function must
- take (as an input parameter) the number of bytes to allocate
- return a memory address which points to that many bytes of **free** memory

there are many other things it could do, but this will do for now

## Silly Malloc

```ARM
@ r0 param is number of bytes to allocate returns a memory address with that number of bytes allocated
.type smalloc, %function
smalloc:
  push {r0} @ just save r0 for a sec
  ldr r3, =smalloc_value 
  ldr r0, [r3] @ get latest free memory address, this is the return value
  pop {r1} @ get back parameter
  add r1, r1, r0 @ new "smalloc_value", just move it along by requested number of bytes
  str r1, [r3] @ save new smalloc_value
  bx lr
.size smalloc, . - smalloc

.data
smalloc_value:
.word 0x20000004 @ 4 because it starts AFTER this word!
```

## Real `malloc`

real operating systems provide a `malloc` function for dynamically allocating
memory which sortof works like this, but is much better:
- allows you to "release" memory after you're done with it
- keeps track of the memory allocations using metadata
- (tries to) gracefully fail when it can't give you enough memory

{:.fragment}

*although it's implementation dependent*


{:.center}
# Data structures and argument passing {#argument-passing}

{% include slides/talk.html %}

how would you pass an array or a record as an argument to a function? how about
as a return value?

{% include slides/background-image.html
           image="lectures/week-7/freestocks-org-425059-unsplash.jpg"
           heading="it's alive"  %}

## Records as function parameters

imagine an `is_alive` function which
- takes one parameter: a *hearthpebble character* data structure
- returns a (word-sized) `0` if the character is dead, and `1` if the character
  is alive

```arm
  .data
zoltan_the_magnificent:
@ initialise hp and mana
  .word 100, 200 @ more mana because wizard
```

## It's alive #1: pass character in registers

{: style="font-size:0.8em;"}

```arm
is_alive:
  movs r0, r0 @ cheeky trick!
  mov r0, 0
  ble end_is_alive
  mov r0, 1
end_is_alive:
  bx lr
  
@ call
  ldr r2, =zoltan_the_magnificent
  ldr r0, [r2]    @ hp
  ldr r1, [r2, 4] @ mana
  bl is_alive
```

## It's alive #2: pass character on stack

{: style="font-size:0.8em;"}

```arm
is_alive:
  pops {r0,r1} @ read args off stack
  mov r0, 0
  ble end_is_alive
  mov r0, 1
end_is_alive:
  bx lr
  
@ call (including copy record onto the stack)
@ for larger records this might require a loop
  ldr r2, =zoltan_the_magnificent
  ldr r0, [r2]
  ldr r1, [r2, 4]
  push {r0,r1}
  bl is_alive
```

## It's alive #3: pass character by reference

{: style="font-size:0.8em;"}

```arm
is_alive:
@ load hp using the address argument
@ no need to load mana
  ldr r1, [r0]
  movs r1, r1
  mov r0, 0
  ble end_is_alive
  mov r0, 1
end_is_alive:
  bx lr

@ call (pass only address of "zoltan" record)
  ldr r0, =zardok
  bl is_alive
  cmp r0, 1
  beq whee
  b no
```

## Gotchas

the records in these examples are all still small enough that they *could* be
passed in registers, but large ones can't be

be aware of [stack discipline]({% link _lectures/05-functions.md
%}#stack)

pass by reference: no copying, but the caller can mess with the "source" data

{% include slides/background-image.html
           image="lectures/all/all-reading.jpg"
           heading="Further reading"  %}

[Inside memory management: The choices, tradeoffs, and implementations of
dynamic allocation](https://developer.ibm.com/tutorials/l-memory/)

[A look at how malloc works on mac](https://www.cocoawithlove.com/2010/05/look-at-how-malloc-works-on-mac.html)

[Plantz: Chapter 15 - Data Structures](http://bob.cs.sonoma.edu/IntroCompOrg-RPi/chp-structs.html)

{% include slides/background-image.html
           image="lectures/all/all-questions.jpg"
           heading="Questions?"  %}
