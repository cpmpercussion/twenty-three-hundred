---
title: Digital Logic
summary: The building blocks of a CPU
permalink: /lectures/week-1/
image: assets/lectures/week-1/george-boole.jpg
---

{% include slides/title.html %}

{:.center}
# Week 1: Boolean algebra {#Boolean-algebra}

{% include slides/background-image.html
           image="lectures/week-1/george-boole.jpg"
           heading="George Boole"  
           bgsize="contain" %}


## It starts with a thought

*An Investigation of the Laws of Thought on Which are Founded the Mathematical
Theories of Logic and Probabilities* by **George Boole**, 1854

You can still buy it from
[Amazon](https://www.amazon.com/Investigation-Thought-Mathematical-Theories-Probabilities/dp/0265266262)

Boole's big idea: **true & false are all you need**

## What is Boolean algebra?

**Algebra** is the study of mathematical symbols and the rules for manipulating
these symbols; it's about **variables** like *a* and *b* and **operators** like
*∧* (binary *and*), *∨* (binary *or*), *¬* (unary *not*, sometimes represented
with an overline e.g. $\overline{q}$).

**Boolean** means that all variables & expressions can take one of two values.
We can call them **true** and **false**, **1** and **0**, or **Mary** and
**Mengyuan**; it doesn't matter.

Boolean algebra builds expressions with these basic building blocks, e.g.

*¬(a ∧ b) ∨ c*

{% include slides/impact.html %}

this is all revision from **MATH1005**, so we're gonna speed through

## Truth tables

Truth tables are just a convenient way of enumerating all the of the possible
values our variables can take. If you've got $n$ variables, you need $2^n$ rows
in your truth table (why?)

Here's an example with 2 variables:

| a | b | a∧b |
|---|---|-----|
| T | T | T   |
| T | F | F   |
| F | T | F   |
| F | F | F   |

## Other handy Boolean operators

<!-- TODO, revise this slide, this is nonsense -->

{: style="width:80%;"}

| a → b = (¬a ∨ b)              | a **implies** b              |
| (a ≡ b) = (a ∧ b) ∨ (¬a ∧ ¬b) | a **equivalent to** b               |
| (a ⊕ b) = (a ∧ ¬b) ∨ (¬a ∧ b) | a **exclusive or**/**xor** b |
| ¬(a ∧ b) = (¬a ∨ ¬b)          | a **not and**/**nand** b     |
| ¬(a ∨ b) = (¬a ∧ ¬b)          | a **not or**/**nor** b       |

You can reduce any Boolean expression to only NAND or only NOR operators
(**try it and see!**).

## Logic functions

You know about functions from maths, e.g. here's a two-argument function of $x,
y \in \mathbf{R}$

$f(x, y) = x^2sin(y)$

We can have functions of Boolean variables $a$ and $b$ as well:

$g(a, b) = \ldots$

{% include slides/talk.html %}

$f(x, y) = \ldots$

$g(a, b) = \ldots$

Can you think of anything we can do with the Boolean function $g(a,b)$ that we
can't do with the real-valued function $f(x,y)$?

## Full binary operator truth table

{:.stretch}
![Table of all binary Boolean operators]({% link assets/lectures/week-1/all-binary-boolean-operators.png %})

{% include slides/background-image.html
           image="lectures/all/all-lost.jpg"
           heading="What does this have to do with my microbit?"  %}

## Logic gates

{:.stretch}
![Logic gates]({% link assets/lectures/week-1/logic-gates.png %})

{% include slides/background-image.html
           image="lectures/all/all-bigpicture.jpg"
           heading="How does your computer add 1+1?"  %}

{% include slides/background-image.html
           image="lectures/all/all-quiz.jpg"
           heading="How would a 5yo do it? "  %}

## Number representations {#converter-slide}

Remember that an integer can be represented in a different "base" (or "radix"),
e.g. binary (base-2), octal (base-8), hexadecimal (base-16) or the familiar
decimal (base-10).

{% include conversion.html %}

*Note: hex & binary padded to 32-bit, negative numbers represented with 32-bit
two's complement*

{:.center}
# Combinational logic {#combinational-logic}

## Let's start simple: 1+1

Consider the Boolean function $s(a, b) = a + b$ (the s is short for *sum*). How
would we put this in a (pseudo) truth table?

| a | b | s |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 2 |

## Not quite...

This doesn't really work because we can't have *three* distinct values (0, 1 and
2) in Boolean algebra. But what if we just consider one "column" of the
addition?

| a | b | s |               |
|---|---|---|---------------|
| 0 | 0 | 0 |               |
| 0 | 1 | 1 |               |
| 1 | 0 | 1 |               |
| 1 | 1 | 0 | (carry the 1) |

## Add a c (carry) column

| a | b | s | c |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 |

{% include slides/impact.html %}

**bit** == **b**inary dig**it**

## But what is $s(a,b)$?

The truth table *is* a complete spec for the function $s(a, b)$ that we're
interested in, but it doesn't tell us how to express $s$ using the rules we
looked at earlier.

{:style="font-size:0.9em;"}

| a | b | s | c | s minterms | c minterms |
|---|---|---|---|------------|------------|
| 0 | 0 | 0 | 0 |            |            |
| 0 | 1 | 1 | 0 | ¬a ∧ b     |            |
| 1 | 0 | 1 | 0 | a ∧ ¬b     |            |
| 1 | 1 | 0 | 1 |            | a ∧ b      |

{:.fragment}
s = (a ∧ ¬b) ∨ (¬a ∧ b) = a ⊕ b

{:.fragment}
c = a ∧ b

{% include slides/background-image.html
           image="lectures/all/all-bigpicture.jpg"
           heading="So far..."  %}

**Combinational Logic:** 

lets us make a Boolean expressions for any truth-table

**Boolean Algebra:** 

lets us simplify Boolean expressions to something manageable

## Half-adder

s = a ⊕ b

c = a ∧ b

{:.stretch}
![Half-adder]({% link assets/lectures/week-1/half-adder.png %})

## DLS: Digital Logic Simulator

[DLS](https://makingartstudios.itch.io/dls) is a time-driven event-based
multi-delay 3-value digital logic simulator.

There's both [desktop](https://makingartstudios.itch.io/dls) (cheap) &
[web](http://dls.makingartstudios.com/sandbox/wasm/) (free) versions.

DLS isn't compulsory for the course, but it's a nice way for me to demo things.

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Demo: Half-adder"  %}

{:.center}
# Full-Adder

## What about carry *in*?

What's missing with the half-adder? Carry *in* (ci) as well as carry out (co).

{:style="font-size:0.8em; float:right;"}

| a | b | ci | s | co |
|---|---|----|---|----|
| 0 | 0 |  0 | 0 |  0 |
| 0 | 1 |  0 | 1 |  0 |
| 1 | 0 |  0 | 1 |  0 |
| 1 | 1 |  0 | 0 |  1 |
| 0 | 0 |  1 | 1 |  0 |
| 0 | 1 |  1 | 0 |  1 |
| 1 | 0 |  1 | 0 |  1 |
| 1 | 1 |  1 | 1 |  1 |

{:.fragment}
s = (a ∧ ¬b ∧ ¬ci) ∨ (¬a ∧ b ∧ ¬ci) ∨ (¬a ∧ ¬b ∧ ci) ∨ (a ∧ b ∧ ci)

{:.fragment}
&nbsp;&nbsp;&nbsp;= (((a ∧ ¬b) ∨ (¬a ∧ b)) ∧ ¬ci) ∨ (((¬a ∧ ¬b) ∨ (a ∧ b)) ∧ ci)

{:.fragment}
&nbsp;&nbsp;&nbsp;= ((a ⊕ b) ∧ ¬ci) ∨ ((a = b) ∧ ci)

{:.fragment}
&nbsp;&nbsp;&nbsp;= ((a ⊕ b) ∧ ¬ci) ∨ (¬(a ⊕ b) ∧ ci)

{:.fragment}
&nbsp;&nbsp;&nbsp;= (a ⊕ b) ⊕ ci

## Full-adder

cout = (a ∧ b) ∨ ((a ⊕ b) ∧ cin)
<span class="fragment" style="float:right;">*(trust me!)*</span>

{:.stretch}
![Full-adder]({% link assets/lectures/week-1/full-adder.png %})

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Demo: Full-adder"  %}

## Ripple-carry adder

We can join them together like so:

{:.stretch}
![Ripple carry adder]({% link assets/lectures/week-1/ripple-carry-adder.png %})

{% include slides/talk.html %}

1. how many bits can be added together?
2. how long does it take?
3. where does the final carry bit go?

{:.stretch}
![Ripple carry adder]({% link assets/lectures/week-1/ripple-carry-adder.png %})

## What about subtraction?

We've got two options:

1. do some more minterms stuff (boo!)
2. trick the full *adder* into subtracting things instead

**show of hands?**

## Twos complement representation {#twos-complement-representation}

The basic idea: can we define (binary) negative numbers such that our adder still works?

{:.stretch}
![]({% link assets/lectures/week-1/42-plus-what.png %})

## Twos complement representation

{:.stretch}
![]({% link assets/lectures/week-1/42-plus-that.png %})

also remember the [number conversion widget](#converter-slide) from earlier

## [The twos complement "circle"](https://www.allaboutcircuits.com/technical-articles/twos-complement-representation-theory-and-examples/)

{:.stretch}
![Twos complement circle representation]({% link assets/lectures/week-1/TwoComplementCircleV2.jpg %})

{% include slides/background-image.html
           image="lectures/all/all-quiz.jpg"
           heading="Quiz: negative or positive?"  %}

`0b10`

`0b011011`

`0b011011101110101010010`

`0b1011000000000011101111111111101010010000000001010101`

{% include slides/impact.html %}

it's all in your **mind**

## Simple ALU

A simple ALU (Arithmetic & Logic Unit) which can ADD, XOR, AND, OR two
arguments.

{:.stretch}
![A simple ALU]({% link assets/lectures/week-1/simple-alu.png %})

{:.center}
# Sequential logic {#sequential-logic}

{% include slides/talk.html %}

What does it mean for a computer to have **memory**? Can the combinational logic
functions we've looked at so far *remember* things?

{% include slides/impact.html %}

no! we need **feedback**

## Sequential == state-oriented

This makes intuitive sense---the feedback loop allows the current output to be
fed back in (as input).

Sequential logic circuits can no longer be treated as "pure" input-output black
boxes---they carry "state" (i.e. the **sequence** of inputs matters).

## SR latch

S (set), R (reset)

{:.stretch}
![SR flip flop]({% link assets/lectures/week-1/sr-flip-flop.png %})

[stackexchange](https://electronics.stackexchange.com/questions/51625/why-is-the-output-of-stateful-elements-often-named-q)
asks: "Why is the output of stateful elements often named Q?"

## SR input

There are four possible input combinations:

| ¬s | ¬r | *effect*                               |
|----|----|----------------------------------------|
|  1 |  1 | keep current state q                   |
|  0 |  1 | set q (to 1)                           |
|  1 |  0 | reset q (to 0)                         |
|  0 |  0 | **forbidden** (q and ¬q both set to 1) |

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Demo: SR latch"  %}

## Problems with the SR latch

1. the forbidden thing (this is obviously bad)
2. there are some tricky timing issues (because physics: remember, there are
   *real* electrons flying around)
3. have to keep changing inputs...

## Gated D latch

The gated D latch uses an *enable* input, so that the latch is set only when you want it to be.

{:.stretch}
![Gated D latch]({% link assets/lectures/week-1/gated-d-latch.png %})

## JK master-slave flip-flop

Better again, set/reset on a *clock*: no timing problems, no forbidden inputs, toggle operation
(although it's a more complex circuit)

{:.stretch}
![Master/slave JK flip flop]({% link assets/lectures/week-1/master-slave-jk-flip-flop.png %})

{% include slides/youtube.html id="EYl2NwDr1aM" %}

## Register

Store multiple bits, can serve as general-purpose *fast* on-CPU
storage, or hold state for peripherals, etc. Note the shared clock line

{:.stretch}
![Register]({% link assets/lectures/week-1/register.png %})

## Counter

{:.stretch}
![Counter]({% link assets/lectures/week-1/counter.png %})

Your microbit has several of these!

{% include slides/background-image.html
           image="lectures/all/all-lost.jpg"
           heading="Feeling lost?"  %}

These are all physical components in your computer.

There's no magic (!), just these **billion** of these little mathematical machines.

{% include slides/background-image.html
           image="lectures/all/all-reading.jpg"
           heading="Further reading"  %}

[Plantz: Introduction to Computer Organization]({% link
_resources/04-books-links.md %}#plantz) chapters 5-7

[Patterson &
Hennessy]({% link _resources/04-books-links.md
%}#patterson-hennessy) *Appendix A “The Basics of Logic Design”*

EEVblog [Intro to Digital Logic (YouTube)](https://youtu.be/7bVnsXHO6Uw)

Ben Eater: [Logic Gates](https://youtu.be/sTu3LwpF6XI), [SR
Latch](https://youtu.be/KM0DdEaY5sY), [D Latch](https://youtu.be/peCh_859q7Q),
[D Flip-Flop](https://youtu.be/YW-_GkUguMM), [JK Flip
Flop](https://youtu.be/F1OC5e7Tn_o)


{% include slides/background-image.html
           image="lectures/all/all-questions.jpg"
           heading="Questions"  %}
