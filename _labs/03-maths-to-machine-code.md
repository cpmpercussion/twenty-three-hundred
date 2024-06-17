---
title: "Week 3: maths to machine code"
summary: "Translating mathematical expressions into assembly sequences and an introduction to branching."
template_repo: https://gitlab.cecs.anu.edu.au/comp2300/2022/comp2300-2022-lab-pack-1
use_toc: true
image: assets/labs/lab-3/k-e-1qx2J3TsRsk-unsplash.jpg
image_alt: Photo by K E on Unsplash
---

## Introduction

Before you attend this week's lab, make sure:

1. you understand how simple assembly instructions are executed by the
   microbit (and can read the cheat sheet to figure out what they do)
2. you're able to follow the execution of your program in the debugger, and
   inspect registers to see what's going on
3. you have read the laboratory text below

In this week's lab you will:

1. translate simple mathematical expressions into sequences of assembly
   instructions
2. watch the status register and monitor the condition flags
3. branch (jump) around in your program, including conditional branches

Useful reference material:

- [ARM assembly cheat sheet]({{site.armv7_cheat_sheet_url}})
- [ARM®v7-M Architecture Reference Manual]({{site.armv7_architecture_ref_url}})

And here's the conversion widget again, because it always comes in handy:

{% include conversion.html %}

[Pokemon](https://en.wikipedia.org/wiki/Pok%C3%A9mon#Gameplay_of_Pok%C3%A9mon)
is a game where you play as a "pokemon trainer" and assemble a team of
fictional creatures, for battle--against wild pokemon (to capture), and
friends/foes (to prove your superiority). In this week's lab, you're going to
create your very own game---a (much) simplified version of Pokemon.

In this game, you will have a pokemon character take turns with an enemy
pokemon in an epic battle until one of the two pokemon runs out of hit points
(HP) and faints! This isn't a game for the faint of heart... You will start by
creating your own pokemon and then we will add in the enemy pokemon later.

{:.talk-box}

It's important to ask for help when you get stuck in your lab. If you're an
on-campus student: wave to one of your neighbours. If you're online: say hey in
your Teams chat! Ask what their favourite card game is, and whether they've
ever thought of writing a computer-program version of it?

You should already have the lab 3 repository on your machine, contained in the 
`comp2300-2022-lab-1` repo you forked and cloned in [week 1]({% link _labs/01-intro.md %}). 
If not, [here's a link]({{ page.template_repo }}). Make sure to open VSCode
into the `week-3` subfolder. I.e. `File -> Open Folder... -> comp2300-2022-lab-1/week-3`.


## Task 1: Creating your pokemon

Copy the following code into your `main.S` file to get started.
you started.

``` ARM
.syntax unified
.global main

.type main, %function
main:
  @ b task_3

  @ Your code goes here

@ a simple infinite loop
end_loop:
  nop
  b end_loop
.size main, .-main

@ a place for your to complete task 3. uncomment line 6 when you're ready to start working on it!
task_3:
...
```

{:.think-box}

But before you write any more code, think: what are the *minimum* features that
you'll need to put in your program to create a game like this?

At the very least, the game needs:

1. a **pokemon**, with some number of hit points
2. an **action** that our pokemon can perform

{:.talk-box}

This stuff is so common in computer games that you probably don't even think of
it. Using what you've learned so far about
programming your microbit, how might you keep track of your pokemon's hit
points (HP), and how could you represent an action in your program?

Given what you've covered so far, you probably decided to use a **register** to
store the pokemon's HP---good choice. Remember in last week's lab you used
registers and instructions to perform your `2`+`2` operation? This is the same
idea. From the computer's perspective the register is just a bunch of bits
(well, a bunch of logic gates which store a bunch of bits) but as long as *you*
know that that particular register really represents your pokemon's HP and
treat it accordingly, then your game will play just fine.

{:.push-box}

Write a program to store the pokemon's HP in the register `r0` with an initial
value of `100`. 
Copy the code into `tasks/task-1.S`. Commit and push your changes with the message "completed task 1".

### When things go wrong

By now you should be starting to get the hang of the way things can go wrong in
assembly programming. For example, if you try to write an instruction which
branches to *itself*:

``` arm
my_label:
  b my_label
```

then your board will stop talking to you (that's why we put a `nop` in the
middle). And if you set a breakpoint on a label (like `my_label` above) then it
may end up breaking one instruction *later* than you'd expect (this is a bug in
the debugger). All of this stuff is a bit painful at first, but you will get
the hang of it.

If all else fails, un-plug and re-plug your board (but once you get used to the
pitfalls you shouldn't have to do that too often).

## Task 2: Healing your pokemon {#condition-codes}

Now that you're storing the HP, here's the first action in the game:

- **healing potion**: add 50HP (hp := hp + 50)

Write an assembly instruction for this action. Remember to look at the [cheat
sheet]({{site.armv7_cheat_sheet_url}})---nobody expects you to recall this
stuff perfectly from memory.

Step through your program---what's the value in the hit point register after
your "action" instruction has occurred? Does that seem right?

At this point, the Pokemon world only has one action, so the only way for
the game to proceed is to keep performing that action. We can do that with a
**branch** instruction: `b` (hint: check page 2 of your cheat sheet). This
instruction tells your microbit to "branch" (sometimes called a jump on other
CPU types) to a different part of the code. You can specify the "destination" of
the branch in a bunch of different ways, including using a label, or a constant
value (if you know exactly what address you want to go to ahead of time) or even
the address in a register. If you've wondered how to get your program to do
something other than just keep following the instructions from top to bottom,
branching is the answer.

Add a label and a branch instruction to modify your program so that the
pokemon keeps drinking healing potions (one after the other) indefinitely.

Hit the continue (play) button in the debug toolbar and let the program run for
a while, pausing every now and again to check the pokemon's HP value---what do
you notice?

{:.talk-box}

What do you think is going on here (think about this: what's the biggest number
a register can store?)

{:.push-box}

When you have your infinite healing program working,
copy the code into `tasks/task-2.S`. Commit and push your changes with the message "completed task 2".


## Task 3: Status Flags and Condition Codes {#condition-codes}

How can you deal with this problem? The answer lies is in the program status
register in every ARMv7 CPU (including our little microbit). You can see it in
the *cortex registers* viewlet in VSCode under `xPSR`:

![Current program status register view in VSCode]({% link assets/lectures/week-2/xpsr-viewlet.png %}){:style="width:50%;margin:0px auto;"}

Remember we talked about these status flags in the week 2 lectures (go and have
a look if you need to refresh your memory). [This stackoverflow
post](http://stackoverflow.com/a/24002847/1510867) also has a nice "clock"
animation to show how all the condition codes in the status register work.

When the microbit executes any instruction with an `s` suffix (e.g. `adds`) it
updates these status flags according to the result of the operation. That's all
the `s` does---`add` and `adds` will leave the exact same result in the
destination register, but `adds` will update the flags to leave some
"breadcrumbs" about the result (which can be helpful, as you'll soon see).

In addition to this, if you look at the *Tests* section of the [cheat
sheet]({{site.armv7_cheat_sheet_url}}) then you can see that there are some
instructions specifically used to update the flags without changing the values
in the general purpose registers (`r0` - `r12`). For example, `cmp r0, 10` is
the same as `subs r0, 10` except that the value in r0 is left untouched.

{:.info-box}

Sometimes the status flags are called status bits, or condition flags, or
condition codes, or some other combination of those words. They all refer to
the same thing---the bits in the program status register.

It's time to see this in action. Go back to your "healing loop" program from
Task 1 and step through, but this time keep an eye on the `xPSR` register. As a
tip, you probably want to bump up the "healing amount" to something like
`0xF000000` so that it doesn't take you a million steps before you overflow :)
What do you notice about the status register bits when the HP register switches
to a negative (when viewed as a signed decimal number) value?

Write a series of simple programs (e.g. `mov` some values into registers, then
do an arithmetic operation on those registers) to set (a) the negative flag bit
(b) the zero flag bit (c) the carry flag bit and (d) the overflow flag bit.

Uncomment the "b task_3" instruction on line 7 of your project, and use the
template underneath the task_3 label to fill out your solutions. When
you're done, you can re-comment "b task_3" and use it as a reference.

``` arm
task_3:
@ set the negative flag

@ ... your instruction(s) go here ...

@ set the zero flag

@ ... your instruction(s) go here ...

@ set the carry flag

@ ... your instruction(s) go here ...

@ set the overflow flag

@ ... your instruction(s) go here ...
```

{:.info-box}

If you're getting bored of stepping through every instruction, don't forget you
can set breakpoints, these control exactly where your debugger will pause after
clicking 'continue' (the green button). You can do this by clicking in the
left-hand “gutter” (or margin) of the code view. You should see a little red
dot appear:  ![A breakpoint (indicated by the red dot)]({% link
assets/labs/lab-1/VSCodium-breakpoint.png %})

{:.push-box}

Once your `task_3` program is working, 
copy the code into `tasks/task-3.S`. Commit and push your changes with the message "completed task 3".


It might seem like this carry/overflow stuff isn't worth worrying about
because it'll never happen in real life. But that's not true.  It can cause
serious problems, like literally [causing rockets to
explode](http://www.bbc.com/future/story/20150505-the-numbers-that-lead-to-disaster).
So understanding and checking the status flags really matters :)

## Task 4: Enriching our game world

At the moment our game is pretty boring, we have a pokemon that constantly
increases it's HP by drinking a healing potion. Let's make the game more
exciting by adding an enemy pokemon, that we can ruthlessly damage in each
_turn_. This enemy pokemon will also need it's own HP so that we can add a loss
condition. This means that when the enemy pokemon eventually faints, we can
tell (and win!)

Your pokemon will just have one attack for now, which subtracts a certain
amount of health from our enemy pokemon.

You've seen in lectures (and every time you look at the cheat sheet) that most
of the ARM assembly instructions can be made to execute "conditionally" using a
one or two letter suffix. (e.g. `eq`, `mi`, `vs`)

{:.think-box}

What do these instruction suffixes do? What about the instruction `bne
end_loop`. You can look at your cheat sheet if you like.

Go back up to the top of your program (just under the `main` label) and add the
following instructions. Keep the rest of your pokemon code further down, just
make sure this stuff is at the top.

``` ARM
movs r0, #100
beq end_loop  @ conditional branch 1
subs r0, #200
beq end_loop  @ conditional branch 2
adds r0, #100
beq end_loop  @ conditional branch 3
```

{:.talk-box}

Which of the `beq` instructions do you think will actually trigger the branch to
the `end_loop`?

Then, step through and see what happens. Can you change the condition (i.e.
change the `eq` to something else) to execute conditional branch 2? How about
branch 1? Have a look at the "Condition codes" section of the cheat sheet to
familiarise yourself with all the options.

Delete the above lines from your program and discuss how you
can now use this "conditional branching" behaviour to make Pokemon work
like a proper game:

1. at the end of your pokemon's turn, check if the enemy pokemon has
   fainted---if so, branch to a `pokemon_wins` loop at the end (you'll have to
   add this in, too)
2. otherwise if the enemy pokemon hasn't fainted, branch back up to the start
   of your pokemon's turn and start again.

{:.push-box}

Your program should now feature two pokemon, each with their own HP and
alternating turns. If the enemy pokemon's health is 0 or less, branch to an
infinite loop labelled `pokemon_wins`.
Copy the code into `tasks/task-4.S`. Commit and push your changes with the message "completed task 4".


## Task 5: the empire fights back

We've been a bit unfair to our enemy pokemon at this point--it has to just sit
there and take damage! That's not a very fun game, so lets give our enemy a
turn attacking! Give your enemy pokemon it's own turn and let it attack your
pokemon back! Pick an attack that means that your pokemon faints just before
the enemy pokemon would. This means we need another loss condition for our own
pokemon, i.e. at the end of the enemy pokemon's turn--if your pokemon has
fainted, branch to an `enemy_wins` loop. If both of the pokemon are still awake
at the end of both pokemon's turns, branch back up to the start of your
pokemon's turn and start again.

Run through your code until your pokemon faints. Do all of the steps behave as
expected?

{:.push-box}

Copy your enemy-enhanced code into `tasks/task-5.S`. Commit and push your changes with the message "completed task 5".

## Task 6: conditionals and branching

We're now going to do two things to make our game more interesting:

1. Add in a "strength" variable for each of our pokemon (you'll need to use two
   new registers for this, one for each pokemon). This strength variable will
   change the power of some of the attacks. Choose an initial value for the
   strength which makes sense to you (perhaps try 10 and see what happens)
2. Add more attacks that do more than just decrease the health of our enemy

Here are some attacks we've come up with:

- **fireball**: remove 20HP
- **frenzy**: remove 30HP, but add 10 strength to the opposing pokemon
- **magic poison**: do *double* the pokemon's strength attribute in damage (hp := hp - 2 * strength)
- **strength from weariness**: hp := hp + ((hp-strength)/20)^2
- **eye of Zardok**: strength := (hp * strength) / 100; HP := HP - (strength / 16)^3

Note that these ones (unlike the simpler actions from the previous section)
might require more than one instruction, so feel free to use whitespace and
comments (any text on a line following the `@` character is a comment) to make
things clearer. You can use whatever registers you like, but make sure that the
**destination** register of each instruction isn't already holding something
important (like your HP!). For more complex mathematical expressions, you need
to break it down into smaller steps. Use a pencil and paper if that helps.

Choose one of the first three, and one of the last two to implement yourself.

{:.talk-box} 

Come up with an idea for your own action, share it with a
neighbour (or send it to the rest of your lab on Teams).

Implement your own custom action (or someone else's) and add it to either your
pokemon or the enemy pokemon.

{:.push-box}

Submit your program with your new actions---describe exactly what your new
custom action does (give it a story!) in a comment.
Copy the code into `tasks/task-6.S`. Commit and push your changes with the message "completed task 6".


## Extra Tasks

### Access `xPSR`

The program status register `xPSR` is a bit different from the other registers,
and you can't use it in all instructions. You can access it with special
instructions, though---check out `MRS` and `MSR` in the [ARMv7 reference
manual]({{site.armv7_architecture_ref_url}}).
Can you think of a way (or an addition to your program) to make your life easier
in reading the program status register?

### Change the game

You can play (run) the program as many times as you like, watching the
all-important HP and strength registers to see how the game evolves. When
you've figured out what the outcome is in the current version of the game, find
some new actions for the pokemon to take so that you end up with a different
outcome.

Congratulations! You can now play your game, or reprogram it however you wish!
Try to win, try to lose, try to last for exactly 3 turns, try to cheat---use
your imagination!

### Alternative Turns

At the moment each of your pokemon takes the exact same turn every time. Try to
make it so that your pokemon instead alternates between two turns, or perhaps
takes a different turn depending on how much HP and/or strength it has

### Pokemon memory

Using registers to hold all the game state doesn't really scale past two
pokemon. We've just started (in the week 3 lectures) to look at how we can
load and store data in **memory** rather than just in registers.

If you're up for a challenge, try refactoring your Pokemon program to
include a [`.data`
section](https://sourceware.org/binutils/docs/as/Data.html#Data) to store some
data in your microbit's memory (perhaps with some `.word`s). Then you can load
and store the game data (e.g. HP and mana) using the `ldr` and `str`
instructions.


