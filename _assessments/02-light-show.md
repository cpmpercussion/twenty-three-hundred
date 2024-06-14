---
title: "Assignment 1: Light Show"
permalink: /assessments/light-show/
tagline: "Create a light and sound show on your micro:bit"
image: "/assets/assessments/01-lightshow/arno-senoner-FDtJZDU8kws-unsplash.jpg"
image_alt: "Photo by Arno Senoner on Unsplash" 
template_repo: https://gitlab.cecs.anu.edu.au/comp2300/2022/comp2300-2022-assignment-1
show_toc: true
# hidden: true
---

{:.lead}
Digital media festivals like [Canberra's Enlighten
Festival](https://enlightencanberra.com/) and [Vivid
Sydney](https://www.vividsydney.com/) use huge projectors and LED arrays to
create a city-sized light (and sound) show for people to enjoy.
**Your task in this assignment is to create a _micro_ light show on your
micro:bit!**

You are going to write an ARM assembly program that uses the LED array on your
microbit to create a changing light  experience that engages a viewer. The
application for your show is an (imaginary) microbit festival where viewers
walk past and experience your show for a few minutes.

{: .warn-box} 
**N.B.:** There is a _pre-submission task_ associated with this assignment
which is due by the start of your Week 5 lab. This task will help you get
started in planning your assignment. See the [assignment pre-submission page
(link)]({% link _assessments/08-assignment-presubmissions.md %}) for the
details. 

## Outline

- **Deadline:** ~~2022-04-01 23:59~~ extended to: 2022-04-04 09:00 Canberra time.
- **Assignment template:** [link]({{ page.template_repo }})
- **Specification:** keep reading :-)

## Specification

Here's a technical specificiation for your assignment. 

Your program:

- must be written in **ARMv7 assembly** using the [assignment template (link)]({{ page.template_repo }})
- must use the LEDs to create a **light show** that **changes over time**
- must be **engaging** for a viewer for at least **30 seconds**
- must **never stop** (it can repeat or loop)
- must work when the microbit is **powered over USB** but not connected to a computer (that is, it works after you upload it and plug into a USB charger)
- _should_ use **memory** to help create an engaging show

To limit the scope, here's some **should nots**. Your program:

- should **not** use the buttons
- should **not** use the motion sensor
- should **not** use any input peripherals on the microbit

Finally, you program **must** be accompanied by a [design document]({% link _resources/design-document.md %}) (maximum: **600 words**). The design document must explain:

- **what** your design is (and how it meets the assignment specification)
- **how** you accomplished it
- **why** your design choices were appropriate for the task

{:warn-box}
You **must** follow the assignment specification for this project (both
**shoulds** and **should nots**). Our expectation is with the above limitations
every student will come up with a unique light show.

## Rules and Policies

- this is an individual assessment task

- [late submission]({% link 01-policies.md %}#late-submission) is not permitted without an [extension]({% link 01-policies.md %}#extensions)

## Marking Criteria

Your assignment will be evaluated on the following criteria:

1. Sophistication of your design and how it meets the assignment specification. (20%)
2. Sophistication of your implementation in ARM-v7 assembly language. (50%)
3. Sophistication of analysis and evaluation of why your implementation is correct and appropriate for your design and what limitations it might have. (20%) 
4. Sophistication of communication and expression. (10%)

Item 2 will be evaluated primarily through your program code. Items 1, 3, and 4
will be evaluated through your design document.

## Submission

Submission is through GitLab, the most recently pushed commit of your fork of
the [assignment template]({{ page.template_repo }}) before the deadline is
taken to be your assignment submission.

## Getting Started

0. read this assignment page **completely**
1. fork and clone the [assignment template]({{ page.template_repo }})
2. **complete the presubmission task** (see the [Assignment Pres-submission page]({% link _assessments/08-assignment-presubmissions.md %})): fill in your `design-proposal.md` file then commit and push it.
3. have a look at the "blinky" lab and think about how you can turn the other LEDs on and off
4. think about how you can add more sophisticated patterns of LEDs within the `main` loop of your program
5. try some LED patterns and see what you think is "engaging"
6. make a mistake or get stuck, then ask a good question on the [course forum]({{ site.course_forum }}).

## Ideas for Extensions

So you've made a basic light show and now you want to take it to the next
level? Here's some ideas for making a sophisticated idea:

- use persistence of vision to display images with the whole screen (not just a couple of pixels that can be independently addressed)
- use pulse width modulation to adjust the brightness of the LEDs
- write a program that creates patterns that continually change (i.e., a _generative_ pattern)
- implement a random number generator to make your show change each time you turn on the microbit
- use the speaker to create an interesting synthesised sound to go with your visualisation

These are only a couple of extension ideas, if you have any other great ideas
feel free to chat with us on the course forum [course forum]({{
site.course_forum }}).

## Checklist

- you have tested that your code works when "uploaded" to a microbit and when the microbit is plugged into a USB charger or power bank
- you have checked with at least one other person that your show is engaging for at least 30 seconds (show your family! good chance to show off what you're learning at uni!)
- you have committed and pushed your program code to your own fork of the [assignment template]({{ page.template_repo }})
- you have filled out, committed, and pushed `design-document.md` 
- you have filled out, committed, and pushed your statement of originality.
- you have check that the files in your fork of the template on the gitlab website are the correct versions of the files you intend to submit. 

## FAQ

### Do I have to write a design document?

Yes! 50% of the marks for this assignment are evaluated through the design
document. If you don't write one you will get zero for that half of the
assignment.

### How do I write a design document?

Have a look at the [design document]({% link _resources/design-document.md %})
page for advice. 

Make sure you are answering the questions in the specification and stay within
the word limit.

Writing a clear and concise document is a challenge, but we believe in you.

### What do you mean by "engaging for at least 30 seconds"?

We don't mean that you need to have an animation that lasts exactly 30 seconds.
We mean that your work has to be _interesting_ for at least 30 seconds.
Repeating or looping things can definitely be interesting. This is one you will
need to test to know, show a friend and see how long they spend looking at your
show. If it's only 5 seconds then maybe you have some work to do :-)

### I've done X, is that good enough to get Y marks?

We don't give out marks before assignments are completed, but it's fair to
wonder "How hard should I work on this?"

Realistically there are ways to complete this assignment with minor
modification of what you have done in labs. Those types of submissions will be
likely to get in the range of 50-59 indicating "satisfactory" performance, but
not what we would call "good". 

Putting in a normal amount of further effort to create a submission that is
"good" or "very good" will result in a mark between 60-79. Most students will
be in this category. Don't neglect your design document as **explaining** your
program is worth the same number of marks as the program itself.

Getting higher than 79 requires an "excellent" submission across all marking
criteria. This requires sophisticated engagement with the task and probably
some kind of extension.

For very high marks (90+): "we know it when we see it". Only a few students
will be in this category and they will have definitely put in a lot of effort
to create a sophisticated extension on the basics. They will also have written
an impeccable design document.

At the opposite end of the scale, if we see a submission that doesn't meet the
specification (e.g., it's only a static LED display, or there is a very weak
design document), then the mark will be below 50. Hopefully, there are only a
few students in this category.

Sorry that we can't be more specific than that.

### My program doesn't work, can I email you for help?

Sorry, you won't get help over email or Teams. We provide a [course forum]({{
site.course_forum }}) which is the **only** way we are able to help.

Forum posts related to your assignment submission **must** be "private to
instructors" (as for any individual assessment task).

### Do I have to use memory? It seems hard.

It's not required, but we seriously suggest that you do.

We've seen a lot of students avoid using memory because it's slightly more
complicated than using registers.

In the context of the course, this is a big mistake. Practicing how to `str`
and `ldr` in assignment 1 will make a big difference in your ability to
complete the later tasks in the course.

Realistically, there's a very limited number of registers on the microbit and
many tasks are made easier by using memory at the appropriate time.

### It's [5 minutes, 60 minutes, 12 hours] before the deadline and my CI Jobs aren't finishing!

Unfortunately on the day that an assignment is due, when many students are
pushing updates at once, the CI servers can't keep up. You may not see your CI
jobs finish before the deadline. You will just have to manually check that your
files have been submitted correctly.

If there's any issues with your git repository _after the deadline_. Please let
us know (after the deadline) through a private piazza post and there may be
something we can do.

### How do I know my assignment has been submitted?

If:

1.  the files in _your fork_ of the assignment are correct (i.e., the files you
    intend to submit) when checking on the gitlab website
2.  the time is before the deadline

then your assignment has been submitted (well done!).

Please don't ask us to "check", we would be just doing exactly the same thing
as the above steps which you can do yourself.
