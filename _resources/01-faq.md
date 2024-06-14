---
title: FAQ
summary: Some questions which come up, well... frequently
permalink: /resources/faq/
show_toc: true
---

In addition to this FAQ page, this course has a dedicated [help
page]({% link 03-getting-help.md %}).

## Getting started {#getting-started}

### What do I need to do to *start* the course? {#course-start-checklist}

Here's a checklist:

1. get a Microbit v2

2. do the [software setup]({% link _resources/02-software-setup.md %})

3. [read or watch the lectures]({% link _lectures/index.md %})

4. [complete the labs]({% link _labs/index.md %})

5. [complete the assessment projects]({% link _assessments/index.md %})

### Is there a textbook?

There's no physical textbook for this course, but there's a list of good online
resources on the [books and links]({% link
_resources/04-books-links.md %}) page.

## Microbit {#microbit}

This course requires a BBC micro:bit v2 to complete the learning activities and assessments.

### How do I get a microbit?

If you are taking this as a paid university course, you will get one from the course teachers. Otherwise, you will have to buy one yourself. See the [microbit page]({% link _resources/05-microbit.md %}) for details.

## Software {#software}

### Can I use my own laptop/desktop machine?

Yep, you can, head over to the [software setup
page]({% link _resources/02-software-setup.md %}).

### I'm having trouble getting everything working on my own computer---can I bring it to the labs for help? {#can-I-bring-my-laptop-to-labs}

Labs aren't necessarily for troubleshooting, please ask on [the COMP2300
forum]({{ site.forum_url }}).

## git {#git}

### What *is* git? {#what-is-git}

[git](https://git-scm.com) is a version control program, which means that its
job is to help you take "snapshots" of your files as you work on them and store these on another computer. 
In COMP2300, the other computer is our gitlab server, and you share your code with us so that we can mark it :-D

### Am I expected to know how to use git for this course? {#am-i-expected-to-know-how-to-use-git}

Yes---git & GitLab have been covered in the course pre-requisites, these are
vital skills for computing courses and professional life.
If you are unsure about the details, you need to start learning about it from week 1.
Set yourself a goal of being a git-wizard by the end of this course.

### How do I open a terminal window? {#opening-a-terminal}

- On a **Mac**, the terminal program is called **Terminal.app**. It's in your
`Applications > Utilities` folder.
- On **Linux** (like in the CSIT labs) the program is also called **Terminal**, an
you can find it by going to the menu in the top left hand corner of the
screen---it's in `System Tools > Terminal`.
- On **Windows** the easiest way is to open the explorer, right-click the folder
you want to work in and select the `Git Bash Here` menu item.

The [GitLab help
page](https://gitlab.cecs.anu.edu.au/help/gitlab-basics/start-using-git.md#open-a-shell)
has some more info if you get stuck (it uses the term *shell*, which is just
another name for terminal).

### What's the difference between git & GitLab?

[git](https://git-scm.com) is a program (like Microsoft Word) for keeping track
of files (see [what *is* git?](#what-is-git) above). The [GitLab server]({{
site.gitlab_url }}) is a website (running on a computer at the ANU) which uses
git to keep track of your snapshots somewhere other than your own computer. The
GitLab server never adds any new files to your snapshots, it just keeps track of
the changes (commits) you've made once you push them to the server.

So git is the program, and GitLab is the website, although you can interact with
the website both directly (e.g. with a `git push`) or indirectly (through the
GitLab user interface in the web browser).

### How do I install git?

You *might* already have it. [Open up the terminal
window](#opening-up-a-terminal) and type

    git --version

and if it prints something like (the exact version number doesn't matter)

    git version 2.20.1

then you're good to go.

If you don't have git installed (or your terminal can't find the `git` program)
then instead you'll see something like

    -bash: git: command not found

Never fear, the internet is full of instructions on how to install git on your
machine: [here's
one](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) which you
might find useful (but other ways are ok as well).

### I cloned the "template" repository by mistake instead of my own fork---what do I do?

It's ok. You just need to change the remote (the repository on the GitLab server
which your local copy of the files "points" to when it tries to push them back
up to the server).

### Do I have to type in my password all the time? {#setting-up-ssh-keys}

No, if you set up SSH keys then you can do all the git stuff without having to
put in your password. This step isn't necessary, but it is super-handy.

The basic idea is this: when you have trusted friends, you leave a key out for
them so that they can get in to your house when you're not home. git allows you
to do *sortof* the same thing.

This is so that the GitLab server knows that it's you (you don't want someone
else submitting something on your behalf). Added bonus: no more passwords.

- [SSH key generation (Git*Hub* docs, but still useful)](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
- [GitLab SSH key setup](https://docs.gitlab.com/ce/ci/ssh_keys/README.html)

### I've borked my git repo somehow, how do I fix it?

There are lots of things which could have gone wrong, and without knowing what
the exact error message is it's hard to say how to fix it.

Ask a question on [the COMP2300 forum]({{site.forum_url}})
clearly stating what the situation is, what behaviour you *expect*, and what
behaviour you *see* (including any error messages).

### Where can I learn more about git?

Here's a list (in no particular order) of git help resources on the web---if you
find another page which is helpful then let me know and I can add it here:

- [main git docs page](https://git-scm.com/doc): always a good place to find
  things (there are even some videos)

- a general list of [tips for dealing with git
  problems](https://sethrobertson.github.io/GitFixUm/fixup.html): useful if
  you've got intro trouble and you want a one-liner fix to get you out (although
  copy-pasting git commands you don't understand will sometimes fix things, and
  sometimes make it worse)

- [Using Version Control in VS
  Code](https://code.visualstudio.com/Docs/editor/versioncontrol): not
  git-specific, but it gives specific advice on using version control in VSCode
  (there's a [video
  version](https://code.visualstudio.com/docs/introvideos/versioncontrol) if
  you're into that sort of thing)

- using [git reset](https://stackoverflow.com/a/2530073): sometimes useful for
  "undoing" git stuff you don't actually want

- [Five Key Git Concepts Explained the Hard
  Way](https://zwischenzugs.com/2018/03/14/five-key-git-concepts-explained-the-hard-way/):
  this has some detailed explanations, so it won't make sense if you've never
  seen git before, but understanding this stuff in depth will really help you
  become a git master

## Markdown {#markdown}

### What's markdown?

From the [commonmark website](http://commonmark.org/help/):

> Markdown is a simple way to format text that looks great on any device. It
> doesn’t do anything fancy like change the font size, color, or type — just the
> essentials, using keyboard symbols you already know.

### How do I write markdown?

Anytime you open a file in [VSCode]({% link
_resources/02-software-setup.md %}#vscode) with a `.md` or `.markdown` file
extension it'll automatically detect that it's a markdown file, and give you
special highlighting of bold/italics/headings etc. You just write it and save it
(and [commit it](#what-is-git) to Git) just like any other file.

We have specific markdown information about markdown on the ["how to write a design document"]({% link _resources/design-document.md %}) page.

## Academic integrity {#academic-integrity}

### Can I use code I didn't write myself in my assignment submission?

Yes, unless the assignment page forbids it. But you **must** reference it in
your [statement of
originality](#how-do-i-fill-out-my-statement-of-originality)---if you don't,
that's academic misconduct.

## Statement of originality (SoO) {#statement-of-originality}

### How do I fill out my `statement-of-originality.md`? {#how-do-i-fill-out-my-statement-of-originality}

For every assignment you must submit a
**statement of originality** (SoO) in the form of a [markdown file](#markdown) called
`statement-of-originality.md` in your submission repo. There will be a
"template" file in the assignment repo, you just need to add your own
information (and [commit and push it up](#is-it-pushed)).

You must:

- read the file so that you know what it means
- sign your name and UID in the `statement-of-originality.md` file in order for it to pass the CI job checks (this is an assignment requirement!)
- list any collaborations with any of your classmates
- list details of any code used in the assignment obtained from your classmates, the labs, the internet, [StackOverflow](https://stackoverflow.com/) or **any other place**
- list details of any assets (files/images/data) included in your assignment that you did not create (e.g., images or sound file from a website)

Anything which isn't explicitly listed
there is assumed to be your own work, and if it turns out that's not true, the
usual [academic integrity](#academic-integrity) rules apply.

### Can I see an example of a completed SoO? {#soo-example}

Yes:

```markdown
---
declaration: >-
  I declare that everything I have submitted in this assignment is entirely my
  own work, with the following exceptions:

# sign *your* name and uid here
name: Gustav Gustavsson
uid: u1234567
---

# Collaboration

### name: 
Alice McGuffin

### comment: 
Alice and I discussed stragegies for dealing with overflow in the signal value, but we never saw each other's code

# Code

### comment: 
the if/else statement at labelX is based on an answer from StackOverflow

### url: 
https://stackoverflow.com/questions/30086526/if-else-or-statement-in-assembly
```
