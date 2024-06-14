---
title: Writing a great design document
summary: "tips on writing your design document for each assignment"
permalink: /resources/design-document/
show_toc: true
image: assets/resources/christopher-gower-m_HRfLhgABo-unsplash.jpg
image_alt: Photo by Christopher Gower on Unsplash 
---

<div class="info-box" markdown="1">

Here's the [**TL;DR**](https://www.lifewire.com/what-is-tldr-2483633)

- you document should answer the ["what", "how", and "why"](#what-how-why) questions from the specification; the reader should understand not just *what* you did, but *how* it works, and *why* you did it that way
- this is a formal piece of academic writing---treat it professionally and with respect (and don't hack something together at the last minute)
- **do not explain your code line-by-line**
- Read through your design document on Gitlab after you have submitted it to make sure it looks how you expected.

</div>

## Rules

- Your design document must be **a maximum** of 600 words (not counting references)
- Your design document must be a markdown file called `design-document.md`.
- Any text or images reproduced from other sources (e.g., Wikipedia) should [be clearly quoted and cited in a references section in your design document](https://www.anu.edu.au/students/academic-skills/academic-integrity/using-sources/quoting). Reproducing text without citation is considered [plagiarism](https://www.anu.edu.au/students/academic-skills/academic-integrity/plagiarism).

This document is to help you write *great* design documents for COMP2300/6300. It is aimed at all assessment items. This is _not_ a step-by-step guide (or template) for getting the "right answer" for the DD part of the assignment. It is a guide for writing clearly, and communicating the important information.

## What, How and Why {#what-how-why}

The assignment specifications ask you to answer these questions in your design document.

- **what** your design is (and how it meets the assignment specification)
- **how** you accomplished it
- **why** your design choices were appropriate for the task

There are many ways to structure your document to address these questions. You may choose to use these questions as headings in your design document. You could answer the _what_ question in one or two sentences and then answer _how_ and _why_ for each important part of your program. As long as this critical information is in your design document, you will have met the specification.

## Style Guide

The first thing the reader sees is the _style_ of your document, both in terms of layout, and expression. Style is important, get it right:

- Use headings and sections to arrange your work.
- Use diagrams/images if it helps to describe your design.
- Correct spelling and grammar is essential.
- Writing style should be concise and clear. All important aspects must be explained without unnecessary low-level descriptions.
- Your design document should be in correct markdown syntax (i.e., links and images should work when viewed in "markdown preview", code snippets should appear as code, not text).

For help with markdown syntax, see the [syntax](#syntax) section below.

### Structure

You can use whatever structure you want, but a good place to start would be:

- **Design**: _What_ have you created? What do you expect your program to do? It should be crystal clear to the assessor what you have done and what is expected. If they have to read your code to find out, your explanation isn't good enough. The first sentence of your design document should summarise what you have done.
- **Implementation**: _How_ have you implemented your design? This is your chance to explain control flow and structure behind your program. Provide enough detail such that the reader could reproduce your implementation without seeing your code. But make sure you don't provide "unnecessary low level detail" (see below).
- **Analysis**: _Why_ is your implementation correct and appropriate for your task? Why should we consider your solution to be successful? Why did you choose this design and implementation approach? Make sure you analyse what your final design does well and not-so-well, don't just provide a journal of your programming process.

### Finding a balance between high- and low-level explanations.

You need to explain your implementation in enough detail so that the reader could implement it without seeing your code. For example, in Assignment 1, just writing "I generated an LED pattern" is not sufficient: it is too high-level. You need to explain precisely what the pattern is, and how your program generates it.

Similarly, you should avoid "low-level details". E.g., if you explain how to do basic arithmetic and which registers are used ("r1 (array index) and r2 (element size) are multiplied using the `mul` instruction"), this is too low level. You could more clearly write "the memory offset is calculated from the array index and element size (16 bytes)". Writing a line-by-line explanation of your code doesn't help answer the "what, how, why" questions.

A sophisticated submission would express how control flow and program structure is required to create your program: e.g., "I used a _for loop_ to iterate through my pattern, in every iteration, I load part of the pattern from the _array stored in memory_." This explanation clearly describes what is going on, but does not go through each line of the code to do so.

### Analysing and Evaluating your design

When you are explaining your design, you need to motivate and explain the choices you have made. We need to know "what" your program does, and "how", and also "why" this approach works. This means you need to analyse your design and evaluate it in terms of what you set out to create.

For example, if you chose to use an array to store data, rather using static variables, we need to know why you made that decision, and what this decision means in terms of your program's functionality. When you explain this, make sure you back up your explanation with facts and evidence to form valid arguments. 

Your analysis should absolutely *not* explain your code line-by-line. It should definitely be focussed on higher level design choices.

### Clear and concise communication

Clear and concise communication and expression are part of the marking criteria. If your communication is unclear, we cannot be sure of what you really understand about how your design works.

If you explained some of your code as follows:

> This function is very important.

We might wonder why you have drawn this conclusion. What does "important" mean? Why is it more important than other functions? 

A better approach would give a precise, but concise, explanation of the role of this function.

> The `additive_mixer` function is important to this design, because it sums the current samples while ensuring that the output does not overflow.

This approach says which function is important, what it is important for, and why.

### Examples

We have some [examples of design documents from previous versions of COMP2300](https://cloudstor.aarnet.edu.au/plus/s/hoIUtVtDBYoLxfC) kindly donated by tutors.

Note that the requirements for design documents and the assignments were different, but these give you some clues about expected style, and the "level" of explanations.

## Markdown Syntax {#syntax}

Your design document is in _markdown_ format. Markdown is an easy-to-read and easy-to-write plain text format that is designed to be easily converted into documents in HTML format. You can read about the [basic syntax here (link)](https://www.markdownguide.org/basic-syntax/).

Markdown supports all kinds of formatting, here's some examples (and links to documentation) to help you get started:

- [headings](https://www.markdownguide.org/basic-syntax/#headings) (we prefer the hash `#` symbol syntax)
- [bold and italic text](https://www.markdownguide.org/basic-syntax/#emphasis)
- [lists](https://www.markdownguide.org/basic-syntax/#lists-1)
- [code (inline and blocks)](https://www.markdownguide.org/basic-syntax/#code)

We expect you to use correct markdown syntax when creating your design document so that when converted to HTML it looks **great**.

### Pictures, graphs & diagrams

Pictures graphs & diagrams are encouraged, but should be used to support your design document text. In particular, your text should refer to them explicitly (e.g., "Figure 1 shows a plot of the first note and its envelope shape.").

To include a picture (e.g., `image-1.png`) in your design document:

1. commit and push `image-1.png` to the `assets` folder in your assignment repository (the `assets` folder is provided to store pictures for the design doc neatly).
2. use the [markdown image syntax (link)](https://www.markdownguide.org/basic-syntax/#images-1), e.g., `![Description of the image](assets/image-1.png)`
3. when done correctly, the image should show up in "Markdown Preview" in VSCode, and when you view your design document online.

{:.warn-box}
**Images of code** are absolutely unacceptable in your design doc. Include any code snippet as text in your document as shown below. Do not include screenshots or photos of your code.

### Code snippets

In general, code snippets aren't always necessary as the reader will have access to all of your code already. You should only include a code snippet if you have a good reason to explain some code. Good reasons might include:

- It's code from a "previous version" of your program that you want to discuss.
- It's an "alternative implementation" used to demonstrate an improvement in your program.

If you do include code, make sure you use either [inline or block code markdown syntax](https://www.markdownguide.org/basic-syntax/#code)

### Viewing your design document

So you're writing in markdown, but how can you view a nice "rendered" version of your document? Quite easily as it turns out!

- If you are writing your design document in Visual Studio Code, you can access a "preview" using the `Markdown: Open Preview` command. This will let you see that your syntax is correct and that your images are in the right place.

- Once you have committed and pushed your design doc to GitLab, try viewing it on the gitlab website. Again you will see the "processed" version of your markdown document including images.

- If you want to get an _even prettier_ version of your design doc, one of the Gitlab CI jobs generates a self-contained HTML file of your document and uploads it as an artifact attached to that job. Have a look at your CI jobs to download it.

- If you want to generate a _pretty_ HTML or PDF version of your design doc, have a look at [pandoc](https://pandoc.org)

## Help on Academic Writing, Editing, and Style

If you need help with your writing, have a look at the [Academic Skills Writing Centre](https://www.anu.edu.au/students/academic-skills).

This centre provides some great resources, for everybody at ANU (even lecturers!). I particularly like their hints for Editing and Polishing work:

- [ANU Advice on Editing and Polishing your work](https://www.anu.edu.au/students/academic-skills/writing-assessment/editing-and-polishing-your-work)
- [Syle and Authorial Voice](https://www.anu.edu.au/students/academic-skills/writing-assessment/editing-and-polishing-your-work/style-and-authorial)
- [Flow](https://www.anu.edu.au/students/academic-skills/writing-assessment/editing-and-polishing-your-work/flow)
- [Cohesion](https://www.anu.edu.au/students/academic-skills/writing-assessment/editing-and-polishing-your-work/cohesion)
