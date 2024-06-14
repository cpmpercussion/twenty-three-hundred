---
title: Digital Synthesis
summary: An introduction to making sound with code
permalink: /lectures/digital-synthesis/
image: assets/lectures/synth/electronics-toys.jpg
---

{% include slides/title.html %}

{:.center}
# Digital Synthesis for Computer Systems

{% include slides/impact.html %}

What do all these **synth** words mean?

{% include slides/background-image.html
           image="lectures/synth/stage.jpg"
           heading="Sounds?"  %}

How do we make interesting sounds with the microbits?

{% include slides/background-image.html
           image="lectures/synth/electronics-toys.jpg"
           heading="Digital Synthesis Approaches"  %}

- Additive synthesis
- Subtractive synthesis
- FM (frequency modulation) synthesis
- Envelopes and ADSR
- Drums: noise and non-pitched sounds
- Wavetable synthesis

## What's digital sound?

### Digital Sound

- Monty Montgomery: Digital Sampling [Youtube](https://xiph.org/video/vid2.shtml), [Direct Video Download](https://xiph.org/video/vid2.shtml)
- Technology Connections: Nyquist-Shannon [Youtube](https://youtu.be/pWjdWCePgvA)
- Computerphile: How Digital Audio Works [YouTube](https://youtu.be/1RIA9U5oXro)
<!-- ![]({{site.baseurl}}/assets/digital-synthesis/digital-sound.png) -->

![digital sound]({% link assets/lectures/synth/digital-sound.png %})

## What's an Oscillator?

- A **module** (physical or code) that outputs a **waveform**.
- In synth lingo, sometimes a VCO (voltage controlled oscillator).

## Additive Synthesis

![Adding two sine waves together]({% link assets/lectures/synth/additive-synth.png %})

- Take multiple oscillators and add them together!
- Some people are trying this in Assignments 1 & 2
- Need [lots of oscillators](https://www.youtube.com/watch?v=q45FHZLVz2U
) to make complex sound.

<!-- {:.stretch} -->

## Subtractive Synthesis

![Applying a low pass filter to a square wave]({% link assets/lectures/synth/subtractive-synth.png %})

- Use one oscillator and _take sound away_.
- We use a [filter to remove sound](https://ccrma.stanford.edu/~jos/filters/filters.html).
- One example of a digital filter is the [_n-sample moving average filter_](http://www.gaussianwaves.com/2010/11/moving-average-filter-ma-filter-2/).
- Subtractive synthesis is typical for analogue synthes (e.g., [Korg MS-20](https://en.wikipedia.org/wiki/Korg_MS-20)).

<!-- {:.stretch} -->

## FM synthesis

![An frequency modulated sound]({% link assets/lectures/synth/fm-synth.png %})

- "frequency modulation"
- Use one oscillator to control the frequency of another.
- [Cool sounds](https://youtu.be/fxSTjiE_5V0) with few oscillators (see [Yamaha DX7](https://en.wikipedia.org/wiki/Yamaha_DX7))

<!-- {:.stretch} -->

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Let's make some sounds!"  %}

{% include slides/talk.html %}

So far we've made "sounds", but we want to make "notes". 

How can we do that?

## Amplitude Envelope

![An enveloped sound]({% link assets/lectures/synth/envelope-sound.png %})

- **Amplitude** is the "volume" of our note.
- **Envelope** is the chunk of time for our note to exist in.
- We can change the amplitude over the envelope to give a note a sonic "shape".
- In synth lingo, an **EG (envelope generator)** makes envelopes.

<!-- {:.stretch} -->

## ADSR Envelope

![The ADSR Envelope]({% link assets/lectures/synth/adsr.png %})

- The **adsr** shape is often used for pitched sounds.
- ADSR: attack, decay, sustain, release

<!-- {:.stretch} -->

## Drums and Percussion

![Making a simple snare sound by enveloping noise.]({% link assets/lectures/synth/percussion-synth.png %})

- Are drums all "non-pitched" sounds?
- Start with noise, or combine inharmonic frequencies.
- Percussion envelope? Short attack, no sustain, moderate to long release.

<!-- {:.stretch} -->

{% include slides/background-image.html
           image="lectures/all/all-demo.jpg"
           heading="Let's make some notes!"  %}

## Wavetable Synthesis

![A wavetable synth in Pure Data]({% link assets/lectures/synth/wavetable.png %})

- Save the samples for a [single cycle of a waveform in an array](http://msp.ucsd.edu/techniques/v0.11/book-html/node33.html).
- Step through this array to over and over to play back the sound.
- How do you [change pitch](http://www.earlevel.com/main/category/digital-audio/oscillators/wavetable-oscillators/)?

{% include slides/background-image.html
           image="lectures/all/all-reading.jpg"
           heading="Further reading"  %}

- [VCVRack](https://vcvrack.com) - free "analogue" modular synthesis software.
- Powerful "digital" synthesis: [Pure Data](https://puredata.info)
- [ANU Laptop Ensemble](https://cs.anu.edu.au/courses/comp2710-lens/) (it's a real course!)
- How to get started with Pd ([Charles YouTube](https://youtu.be/AC7-MpwIZ8w)).
- Installing [Pd on your laptop](https://cs.anu.edu.au/courses/comp2710-lens/resources/tools/#pure-data).
- [Charles' computer music intro with Pd](https://github.com/cpmpercussion/ComputerMusicIntro)

{% include slides/background-image.html
           image="lectures/synth/electronics-toys.jpg"
           heading="More fun things"  %}

Too many oscillators: [Look Mum No Computer](https://www.youtube.com/watch?v=q45FHZLVz2U)

[How old school game music worked](https://youtu.be/q_3d1x2VPxk)

{% include slides/background-image.html
           image="lectures/all/all-questions.jpg"
           heading="Questions"  %}
