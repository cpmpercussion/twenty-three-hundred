---
title: Real-Time Musical Devices
summary: Using a real-time OS for music making
permalink: /lectures/rtos-music/
image: assets/lectures/bela/Sonami_Laetitia_LadysGLove.jpg
---

{% include slides/title.html %}

<!-- music topic -->

{:.center}
# Extra Topic: Real-Time Musical Devices

{% include slides/impact.html %}

New Interfaces for Musical Expression

{% include slides/background-image.html
           image="lectures/bela/arduino-heartbeat.jpg"  %}

{% include slides/background-image.html
           image="lectures/bela/arduino-actor-interface.jpg"  %}
           
{% include slides/background-image.html
           image="lectures/bela/arduino-looper.jpg"  %}
           
{% include slides/background-image.html
           image="lectures/bela/arduino-vernier.jpg"  %}

{% include slides/background-image.html
           image="lectures/bela/Sonami_Laetitia_LadysGLove.jpg"  %}

{% include slides/background-image.html
           image="lectures/bela/satellite-ccrma.jpg"  %}
           
{% include slides/background-image.html
           image="lectures/bela/HEADER_Reshaping_Excellence_Imogen_Heap.jpg" %}
Image Copyright SENNHEISER / PHILIP PEINE
           
{% include slides/background-image.html
           image="lectures/bela/mad_interface.jpg"  %}
           
## The [NIME community](https://nime.org)

- ...new kinds of musical instruments... 
- ...new kinds of musicianship...
- ...and new kinds of music?

![lectures/bela/nime.jpg]({% link assets/lectures/bela/nime.jpg %})

## Typical NIME workflow...

![lectures/bela/nime-workflow.jpg]({% link assets/lectures/bela/nime-workflow.jpg %})

## Sound and Latency

- Digital (and analogue) instruments always have a latency between
  action and sound.
- Strings, fingers, keys, and electrons take time to move.
- Sound takes time to move...
- Computers buffer sound (a little bit) to make sure it has enough to
  send to the DAC.
- More steps, more buffers, more latency...

## How fast is fast enough?

- Common wisdom is to aim for latency <10ms (Wessel & Wright, 2002).
- Musicians adjust (unconciously) and can handle latency up to 55ms
  (Dahl & Bresin, 2001)
- Different gestures, and sounds, could have different perceptual
  effects.

![lectures/bela/wesselwrightrig.jpg]({% link assets/lectures/bela/wesselwrightrig.jpg %})

## Are the tools good enough?

![lectures/bela/nime-test.jpg]({% link assets/lectures/bela/nime-test.jpg %})

**No** - according to McPherson, Jack, & Moro, "Action-Sound Latency: Are Our Tools Fast Enough?" (2016).

## So what about a Real-Time Operating System?

- Linux kernel and OS (by itself), not good enough for real-time!
- Normal drivers can't preempt the kernel...

![lectures/bela/satellite-ccrma.jpg]({% link assets/lectures/bela/satellite-ccrma.jpg %})

## Bela: Low-Latency Sensor and Audio Platform

![lectures/bela/bela-design.jpg]({% link assets/lectures/bela/bela-design.jpg %})

- Specifically designed to solve this problem!
- Realtime Linux (Xenomai)
- Programmable Real-time unit (PRU)

<!-- Bela Overview -->
{% include slides/youtube.html id="Os2ljj1cIog" %}
<!-- https://youtu.be/Os2ljj1cIog -->

## Xenomai: Linux with Real-time extensions

- [Xenomai](https://xenomai.org): Add two extra [micro-kernels to linux](lectures/bela/satellite-ccrma.jpg), which can preempt the normal kernel.
- "Adeos" is a nano-kernel just to switch between Linux and Xenomai.

![lectures/bela/xenomai-microkernel.jpg]({% link assets/lectures/bela/xenomai-microkernel.jpg %})

## PRU (Programmable Real-Time Unit)

- [Extra microcontroller](https://beagleboard.org/pru) (200MHz, 32bit)
  as part of a processor.
-  [Beaglebone PRU](https://www.embeddedrelated.com/showarticle/586.php)
- Hackaday [PRU](https://hackaday.com/2014/06/22/an-introduction-to-the-beaglebone-pru/)

![lectures/bela/beaglebone-pru.jpg]({% link assets/lectures/bela/beaglebone-pru.jpg %})

## Does this work?

**Yes!**

![lectures/bela/bela-latency-results.jpg]({% link assets/lectures/bela/bela-latency-results.jpg %})
o
<!-- Guitars -->

{% include slides/background-image.html
           image="lectures/bela/bela-guitars.jpg"  %}
       
{% include slides/background-image.html
           image="lectures/bela/bela-guitars2.jpg"  %}

{% include slides/youtube.html id="fhTuI3AhZL0" %}

<!-- Stillness under Tension -->

{% include slides/background-image.html
           image="lectures/bela/bela-3.jpg"  %}

{% include slides/background-image.html
           image="lectures/bela/stillness-under-tension.jpg"  %}

{% include slides/youtube.html id="tDkJqoFpnF8" %}

{% include slides/background-image.html
           image="lectures/all/all-reading.jpg"
           heading="Further Watching"  %}

Sverm Resonans: https://youtu.be/fhTuI3AhZL0

Percussive Table: https://vimeo.com/264852700

Kalichord Strum: https://www.youtube.com/watch?v=mZksorXIOxM

Stillness Under Tension: https://youtu.be/tDkJqoFpnF8

{% include slides/background-image.html
           image="lectures/all/all-questions.jpg"
           heading="Questions"  %}