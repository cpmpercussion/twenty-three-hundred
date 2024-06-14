---
title: "Lab Tasks"
tagline: "Weekly tasks in your lab."
show_toc: true
image: "assets/assessments/marvin-meyer-SYTO3xs06fU-unsplash.jpg"
image_alt: "Photo by Marvin Meyer on Unsplash"
---

{:.lead}
The labs  are the most important learning activity in this course. In each lab
you will complete a number of tasks that involve creating and testing small
programs on your micro:bit. Some of these tasks are required parts of the
course (**lab tasks**) and some are not required but provided to challenge your
knowledge and understanding (**extra tasks**).

Your lab tasks will be marked periodically during the semester, ideally you
will complete your lab tasks during each lab or shortly after. Each lab will be
worth 0.5 marks for a total of 6 marks over the semester. To receive a mark for
a lab you must have completed lab tasks by the next marking deadline. 

You are encouraged and required to collaborate in labs, but you should note the
details of your collaborations in your GitLab repository and each student must
upload their work individually.

To obtain the full 0.5 marks for each lab, you must have completed all of the
lab tasks, as noted in each lab page and uploaded your solutions to GitLab.
Extra tasks are not marked.

## Outline {#outline}

- **Due:** 
  - **Labs 1-3**: Tuesday 15/3/2022 08:00 Canberra Time (start of week 4)
  - **Labs 4-6**: Tuesday 19/4/2022 08:00 Canberra Time (start of week 7)
  - **Labs 7-9**: Monday 9/5/2022 23:59 Canberra Time (start of week 10)
  - **Labs 10-12**: Wednesday 1/6/2022 23:59 Canberra Time (day before exam period)
- **Mark weighting:** 0.5 marks per week, 1.5 marks per lab-pack. A total of 6 marks over the semester (worth 6% of final grade)
- **Submission:** Follow the instructions in your lab each week and don't forget to commit and push to GitLab.
- **Marking:**  your submissions will be checked automatically and/or by your tutor ([details below](#how-will-it-be-marked))
- **Policies:** Late submissions are not accepted without an extension.

### Process {#process}

0. Each lab contains "**Lab Tasks**" (which are required to achieve full marks)
   and "**Extra Tasks**" (which are not required but give you a chance to
   continue your learning).

1. During your lab, your tutor will check in with you to make sure that you are
   making progress towards your **lab tasks**.

2. During your lab, you can get feedback from your tutor about what "completed"
   means for particular tasks if it is confusing.

3. Most **lab tasks** will involve copying your code from `main.S` into a numbered
   task file (e.g., `tasks/task-6.S`). The code you put into the task file is
   counted as your submission for that task.

4. The GitLab CI job in each lab repository will help you keep track of tasks
   that you have completed.

5. Ideally **lab tasks** are completed in your lab time but you will have the
   opportunity after your lab to finish off any tasks you couldn't complete. 

6. At the marking deadline, your lab repositories will be checked to see that
   you have completed the tasks.

7. You'll get a partial mark for getting started, and full marks for completing
   the tasks.

### Rubric {#rubric}

| Mark | Standard                                                               |
|------|------------------------------------------------------------------------|
| 0.5  | Forked/cloned lab template and completed all lab tasks.                |
| 0.25 | Forked/cloned lab template and completed some lab tasks.               |
| 0    | Lab template was not forked/cloned and/or no lab tasks were completed. |

Each lab pack consists of three labs so "full marks" for one lab pack is 1.5 marks.

## FAQ

### How will it be marked? {#how-will-it-be-marked}

- After each due date, your lab repositories will be checked to see that you have
completed the tasks.

- Most of these checks will happen automatically, and some may be done by your
tutor.

- Your mark will be available on [streams](https://comp.anu.edu.au/streams/) after
marking is completed.

- You won't get written feedback on your lab tasks. You will get verbal feedback
from your tutor during each lab on your progress.

### What does this have to do with the CI jobs in the labs?

The CI jobs are used as an automatic check that you have completed each task in
the labs. These check that you have submitted a working program in
each task file.

If you are seeing all green ticks in the CI jobs for your lab, and the code you
have submitted is a genuine attempt at the lab task, you can feel assured that
you have completed that lab.

### What if my lab task isn't quite right?

If you have made an honest attempt at the lab task, and your submission passes
the CI check, it will count as "completed".

If any of your lab-tasks do not pass the CI check it will count as "not
completed"

Don't submit code that is **not** an honest attempt at the lab task. This would
be dishonest, counter-productive to your learning, and a breach of academic
intgrity at ANU.  

### I can't attend a lab session---what should I do? {#missed-a-lab-session}

You can complete your lab tasks outside of labs. For tasks that require
collaboration you might like to meet another student to work through the task.

You should be able to complete the tasks but you won't have access to
feedback from your tutor which is only available during labs.

### I need more time to do my lab tasks, but the deadline is today! {#more-time}

The course policy on [extensions]({% link 01-policies.md %}#extensions) applies
here.

### Oh no! I didn't submit anything for a lab. What should I do? {#oh-no-no-submission}

Whatever you do, you shouldn't panic (remember that each lab is worth 0.5
marks). Try to get your lab tasks done for next week.

### How long should I spend on this every week?

You should be able to complete lab tasks within your lab time for the week.

We expect that most students will have enough time left over to at least
_consider_ working on some of the "extra tasks".

### Do the usual academic integrity rules apply? {#do-the-usual-academic-integrity-rules-apply}

Yes. You are encouraged to collaborate in your lab, but you should document and
acknowledge your collaborators and any resources used to complete your lab
tasks. 

If you want to use a quote from somewhere (e.g., Wikipedia, a book, somewhere
online) make sure it is obviously a quote (in quotation marks) and that you
have linked or cited the source.

If you attempt to pass off text or code that you did not write as you own, [it is
plagiarism](https://www.anu.edu.au/students/academic-skills/academic-integrity/plagiarism).

If you submit code that is not a genuine attempt at the lab task it is also a
breach of academic integrity (at least dishonest and at most an attempt to cheat).

### Why are some of the due dates on a Tuesday?

There are a couple of Monday public holidays this semester and I don't like putting deadlines on weekends, holidays, or the mid-semester break.

I have set the deadlines to be before any later labs as this work needs to be submitted to avoid distraction in the subsequent week's work :-)
