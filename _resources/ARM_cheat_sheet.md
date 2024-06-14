---
title: ARM Assembly Cheat Sheet
summary: ARM Assembly Cheat Sheet
published: true
show_toc: true
---

{% include table/table-styles.html %}

## Instructions {#instructions}

<style>
  table.instructions td {
    padding: 0.15em;
  }

  table.instructions {
    border-collapse: collapse;
  }

  table.instructions .category {
    vertical-align: middle;
    text-align: center;
    font-weight: 600;
    font-size: 1.2em;
  }

  table.instructions .category-start {
    border-top: 1px solid black;
  }

  table.instructions .operation {
    border-top: 1px solid black;
    font-weight: 600;
    vertical-align: middle;
    text-align: right;
    padding-right: 0.5em;
  }

  table.instructions .syntax,
  table.instructions .semantic {
    font-family: monospace;
    border: none;
    text-align: left;
    vertical-align: top;
    white-space: nowrap;
    padding-right: 0.5em;
  }

  table.instructions .flag {
    padding-left: 5px;
  }

  table.instructions .name {
    font-weight: 600;
    color: #3395FF;
  }

  table.instructions .optional {
    opacity: 0.6;
  }
</style>

<style>
  /* Based on https://jekyllcodex.org/without-plugin/accordion/ */
  ul.jekyllcodex_accordion {
    position: relative;
    border-bottom: 1px solid rgba(0,0,0,0.25);
    padding-bottom: 0;
  }

  ul.jekyllcodex_accordion > li {
    list-style: none;
    margin-left: 0;
  }

  ul.jekyllcodex_accordion > li input {
    display: none;
  }

  ul.jekyllcodex_accordion > li label {
    display: block;
    cursor: pointer;
    padding: 0.75rem 2.4rem 0.75rem 0;
  }

  ul.jekyllcodex_accordion > li div {
    display: none;
    padding-bottom: 1.2rem;
  }

  ul.jekyllcodex_accordion > li input:checked + label {
    font-weight: bold;
  }

  ul.jekyllcodex_accordion > li input:checked + label + div {
    display: block;
  }

  ul.jekyllcodex_accordion > li label::before {
    content: "+";
    font-weight: normal;
    font-size: 130%;
    line-height: 1.1rem;
    padding: 0;
    position: absolute;
    right: 0.5rem;
    transition: all 0.15s ease-in-out;
  }

  ul.jekyllcodex_accordion > li input:checked + label::before {
    transform: rotate(-45deg);
  }
</style>

<script>
  // TODO: Generalise this to Jekyll template stuff?
  function expandAccordion(id) {
    const element = document.getElementById(id);
    if (!element) {
      return;
    }

    if (typeof element.checked === "boolean" && !element.checked) {
      element.click();
    }
  }

  function expandInstructionTarget() {
    if (window.location.hash.length === 0) {
      return;
    }

    const menus = [
      "arithmetic",
      "logic",
      "moves",
      "load-store",
      "branches",
      "sync",
    ];

    const target = window.location.hash.slice(1);

    if (target === "instructions") {
      for (const li of menus) {
        expandAccordion(`${li}-check`);
      }
    }

    if (menus.indexOf(target) < 0) {
      return;
    }

    expandAccordion(`${target}-check`);
  }

  window.addEventListener("load", () => expandInstructionTarget());
</script>

<ul class="jekyllcodex_accordion">
  <li id="arithmetic">
    <input id="arithmetic-check" type="checkbox" />
    <label for="arithmetic-check">Arithmetic</label>
    <div>
      <table class="instructions">
        <tr>
          <th>Operation</th>
          <th>Syntax</th>
          <th>Semantic</th>
          <th>Flags</th>
        </tr>
        <tr class="category-start">
          <td class="operation" id="operations-addition" rowspan="5">Addition</td>
          <td class="syntax"><span class="name">add</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rd(n) &colone; Rn + Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">adc</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rd(n) &colone; Rn + Rm<sub>shifted</sub> + C</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">add</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, #const</td>
          <td class="semantic">Rd(n) &colone; Rn + const</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">adc</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, #const</td>
          <td class="semantic">Rd(n) &colone; Rn + const + C</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">qadd</span> <span class="optional">{Rd,}</span> Rn, Rm</td>
          <td class="semantic">Rd(n) &colone; saturated(Rn + Rm)</td>
          <td class="flag">Q</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-subtraction" rowspan="7">Subtraction</td>
          <td class="syntax"><span class="name">sub</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rd(n) &colone; Rn &minus; Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">sbc</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rd(n) &colone; Rn &minus; Rm<sub>shifted</sub> + C</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">rsb</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rd(n) &colone; Rm<sub>shifted</sub> &minus; Rn</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">sub</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, #const</td>
          <td class="semantic">Rd(n) &colone; Rn &minus; const</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">sbc</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, #const</td>
          <td class="semantic">Rd(n) &colone; Rn &minus; const + C</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">rsb</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, #const</td>
          <td class="semantic">Rd(n) &colone; const &minus; Rn</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">qsub</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm</td>
          <td class="semantic">Rd(n) &colone; saturated(Rn &minus; Rm)</td>
          <td class="flag">Q</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-multiplication" rowspan="7">Multiplication</td>
          <td class="syntax"><span class="name">mul</span> <span class="optional">{Rd,}</span> Rn, Rm</td>
          <td class="semantic">Rd(n) &colone; Rn &times; Rm</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">mla</span> Rd, Rn, Rm, Ra</td>
          <td class="semantic">Rd &colone; Ra + (Rn &times; Rm)</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">mls</span> Rd, Rn, Rm, Ra</td>
          <td class="semantic">Rd &colone; Ra - (Rn &times; Rm)</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">umull</span> RdLo, RdHi, Rn, Rm</td>
          <td class="semantic">RdHi:RdLo &colone; (uint64) Rn &times; Rm</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">umlal</span> RdLo, RdHi, Rn, Rm</td>
          <td class="semantic">RdHi:RdLo &colone; (uint64) RdHi:RdLo + (Rn &times; Rm)</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">smull</span> RdLo, RdHi, Rn, Rm</td>
          <td class="semantic">RdHi:RdLo &colone; (int64) Rn &times; Rm</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">smlal</span> RdLo, RdHi, Rn, Rm</td>
          <td class="semantic">RdHi:RdLo &colone; (int64) RdHi:RdLo + (Rn &times; Rm)</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-division" rowspan="2">Division</td>
          <td class="syntax"><span class="name">udiv</span> Rd, Rn, Rm</td>
          <td class="semantic">Rd &colone; (uint32) Rn &div; Rm (rounded to 0)</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">sdiv</span> Rd, Rn, Rm</td>
          <td class="semantic">Rd &colone; (int32) Rn &div; Rm (rounded to 0)</td>
          <td class="flag">-</td>
        </tr>
      </table>
    </div>
  </li>
  <li id="logic">
    <input id="logic-check" type="checkbox" />
    <label for="logic-check">Logic &amp; Tests</label>
    <div>
      <table class="instructions">
        <tr>
          <th>Operation</th>
          <th>Syntax</th>
          <th>Semantic</th>
          <th>Flags</th>
        </tr>
        <tr class="category-start">
          <td class="operation" id="instructions-logic" rowspan="10">Logic</td>
          <td class="syntax"><span class="name">and</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rd(n) &colone; Rn &and; Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">bic</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rd(n) &colone; Rn &and; &not;Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">orr</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rd(n) &colone; Rn &or; Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">orn</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rd(n) &colone; Rn &or; &not;Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">eor</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rd(n) &colone; Rn &oplus; Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">and</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, #const</td>
          <td class="semantic">Rd(n) &colone; Rn &and; const</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">bic</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, #const</td>
          <td class="semantic">Rd(n) &colone; Rn &and; &not;const</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">orr</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, #const</td>
          <td class="semantic">Rd(n) &colone; Rn &or; const</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">orn</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, #const</td>
          <td class="semantic">Rd(n) &colone; Rn &or; &not;const</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">eor</span><span class="optional">{s}</span> <span class="optional">{Rd,}</span> Rn, #const</td>
          <td class="semantic">Rd(n) &colone; Rn &oplus; const</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-tests" rowspan="8">Test</td>
          <td class="syntax"><span class="name">cmp</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rn &minus; Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">cmn</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rn + Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">tst</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rn &and; Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">teq</span> Rn, Rm <span class="optional">{, shift}</span></td>
          <td class="semantic">Rn &oplus; Rm<sub>shifted</sub></td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">cmp</span> Rn, #const</td>
          <td class="semantic">Rn &minus; const</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">cmn</span> Rn, #const</td>
          <td class="semantic">Rn + const</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">tst</span> Rn, #const</td>
          <td class="semantic">Rn &and; const</td>
          <td class="flag">NZCV</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">teq</span> Rn, #const</td>
          <td class="semantic">Rn &oplus; const</td>
          <td class="flag">NZCV</td>
        </tr>
      </table>
    </div>
  </li>
  <li id="moves">
    <input id="moves-check" type="checkbox" />
    <label for="moves-check">Moves &amp; Shifts</label>
    <div>
      <table class="instructions">
        <tr>
          <th>Operation</th>
          <th>Syntax</th>
          <th>Semantic</th>
          <th>Flags</th>
        </tr>
        <tr class="category-start">
          <td class="operation" id="instructions-move" rowspan="2">Move</td>
          <td class="syntax"><span class="name">mov</span><span class="optional">{s}</span> Rd, Rm</td>
          <td class="semantic">Rd &colone; Rm</td>
          <td class="flag">NZ</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">mov</span><span class="optional">{s}</span> Rd, #const</td>
          <td class="semantic">Rd &colone; const</td>
          <td class="flag">NZC</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-shifts" rowspan="9">Shift/Rotate</td>
          <td class="syntax"><span class="name">lsl</span><span class="optional">{s}</span> Rd, Rm, Rs</td>
          <td class="semantic">Rd &colone; Rm &lt;&lt; Rs</td>
          <td class="flag">NZC</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">lsr</span><span class="optional">{s}</span> Rd, Rm, Rs</td>
          <td class="semantic">Rd &colone; (uint32) Rm >> Rs</td>
          <td class="flag">NZC</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">asr</span><span class="optional">{s}</span> Rd, Rm, Rs</td>
          <td class="semantic">Rd &colone; (int32) Rm >> Rs</td>
          <td class="flag">NZC</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">ror</span><span class="optional">{s}</span> Rd, Rm, Rs</td>
          <td class="semantic">Rd &colone; Rm &lt;&lt; (32 &minus; Rs) &or; Rm >> Rs </td>
          <td class="flag">NZC</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">lsl</span><span class="optional">{s}</span> Rd, Rm, #const</td>
          <td class="semantic">Rd &colone; Rm &lt;&lt; const</td>
          <td class="flag">NZC</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">lsr</span><span class="optional">{s}</span> Rd, Rm, #const</td>
          <td class="semantic">Rd &colone; (uint32) Rm >> const</td>
          <td class="flag">NZC</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">asr</span><span class="optional">{s}</span> Rd, Rm, #const</td>
          <td class="semantic">Rd &colone; (int32) Rm >> const</td>
          <td class="flag">NZC</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">ror</span><span class="optional">{s}</span> Rd, Rm, #const</td>
          <td class="semantic">Rd &colone; Rm &lt;&lt; (32 - const) &or; Rm >> const </td>
          <td class="flag">NZC</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">rrx</span><span class="optional">{s}</span> Rd, Rm</td>
          <td class="semantic">Rd &colone; C &lt;&lt; 31 &or; Rm >> 1</td>
          <td class="flag">NZC</td>
        </tr>
      </table>
      For the difference between ASR and LSR see the <a href="#shifts">shifts</a> with the same names.
    </div>
  </li>
  <li id="load-store">
    <input id="load-store-check" type="checkbox" />
    <label for="load-store-check">Loads &amp; Stores</label>
    <div>
      <table class="instructions">
        <tr>
          <th>Operation</th>
          <th>Syntax</th>
          <th>Semantic</th>
          <th>Flags</th>
        </tr>
        <tr class="category-start">
          <td class="operation" id="instructions-ldr-str-offset" rowspan="2">Offset</td>
          <td class="syntax"><span class="name">ldr</span> Rd, [Rb <span class="optional">{, #const}</span>]</td>
          <td class="semantic">Rd &colone; [Rb + const]</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">str</span> Rs, [Rb <span class="optional">{, #const}</span>]</td>
          <td class="semantic">[Rb + const] &colone; Rs</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-ldr-str-pre-offset" rowspan="2">Pre-offset</td>
          <td class="syntax"><span class="name">ldr</span> Rd, [Rb <span class="optional">{, #const}</span>]!</td>
          <td class="semantic">Rb += const; Rd &colone; [Rb]</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">str</span> Rs, [Rb <span class="optional">{, #const}</span>]!</td>
          <td class="semantic">Rb += const; [Rb] &colone; Rs</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-ldr-str-post-offset" rowspan="2">Post-offset</td>
          <td class="syntax"><span class="name">ldr</span> Rd, [Rb], #const</td>
          <td class="semantic">Rd &colone; [Rb]; Rb += const</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">str</span> Rs, [Rb], #const</td>
          <td class="semantic">[Rb] &colone; Rs; Rb += const</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="operation" rowspan="2">Indexed</td>
          <td class="syntax"><span class="name">ldr</span> Rd, [Rb, Ri <span class="optional">{, LSL n}</span>]</td>
          <td class="semantic">Rd &colone; [Rb + (Ri &lt;&lt; n)]</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">str</span> Rs, [Rb, Ri <span class="optional">{, LSL n}</span>]</td>
          <td class="semantic">[Rb + (Ri &lt;&lt; n)] &colone; Rs</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-ldr-literal" rowspan="2">Literal</td>
          <td class="syntax"><span class="name">ldr</span> Rd, label</td>
          <td class="semantic">Rd &colone; [label]</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">ldr</span> Rd, [PC, #offset]</td>
          <td class="semantic">Rd &colone; [PC + offset]</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-pos-stack" rowspan="2">Positive stack</td>
          <td class="syntax"><span class="name">stmia</span> Rs!, registers</td>
          <td class="semantic">for Ri in registers do [Rs] &colone; Ri; Rs += 4</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">ldmdb</span> Rs!, registers</td>
          <td class="semantic">for Ri in rev(registers) do Rs -= 4; Ri &colone; [Rs]</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-neg-stack" rowspan="2">Negative stack</td>
          <td class="syntax"><span class="name">stmdb</span> Rs!, registers</td>
          <td class="semantic">for Ri in rev(registers) do Rs -= 4; [Rs] &colone; Ri</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">ldmia</span> Rs!, registers</td>
          <td class="semantic">for Ri in registers do Ri &colone; [Rs]; Rs += 4</td>
          <td class="flag">-</td>
        </tr>
      </table>
    </div>
  </li>
  <li id="branches">
    <input id="branches-check" type="checkbox" />
    <label for="branches-check">Branches</label>
    <div>
      <table class="instructions">
        <tr>
          <th>Operation</th>
          <th>Syntax</th>
          <th>Semantic</th>
          <th>Flags</th>
        </tr>
        <tr class="category-start">
          <td class="operation" id="instructions-branch-general" rowspan="4">General</td>
          <td class="syntax"><span class="name">b</span><a href="#conditions">&lt;c></a> label</td>
          <td class="semantic">if <it>c</it> then PC &colone; label</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">bl</span> label</td>
          <td class="semantic">LR &colone; PC<sub>next</sub>; PC &colone; label</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">bx</span> Rm</td>
          <td class="semantic">PC &colone; Rm</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">blx</span> Rm</td>
          <td class="semantic">LR &colone; PC<sub>next</sub>; PC &colone; Rm</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-branch-test" rowspan="2">Test &amp; branch</td>
          <td class="syntax"><span class="name">cbz</span> Rn, label</td>
          <td class="semantic">if Rn = 0 then PC &colone; label</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">cbnz</span> Rn, label</td>
          <td class="semantic">if Rn &ne; 0 then PC &colone; label</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="operation" id="instructions-branch-table" rowspan="2">Table based</td>
          <td class="syntax"><span class="name">tbb</span> [Rn, Rm]</td>
          <td class="semantic">PC += (byte) [PC + Rm]</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">tbh</span> [Rn, Rm <span class="optional">{, LSL 1}</span>]</td>
          <td class="semantic">PC += (hword) [PC + Rm &lt;&lt; shift]</td>
          <td class="flag">-</td>
        </tr>
      </table>
      <code>&lt;c></code> denotes a <a href="#conditions">condition suffix</a>.
      For example, use <code>beq</code> to branch only when the <a href="#flags">zero flag</a> is set.
    </div>
  </li>
  <li id="sync">
    <input id="sync-check" type="checkbox" />
    <label for="sync-check">Synchronisation</label>
    <div>
      <table class="instructions">
        <tr>
          <th>Syntax</th>
          <th>Semantic</th>
          <th>Flags</th>
        </tr>
        <tr class="category-start">
          <td class="syntax"><span class="name">ldrex</span> Rd, [Rn <span class="optional">{, #const}</span>]</td>
          <td class="semantic">Rd &colone; [Rn + const]; EX=True</td>
          <td class="flag">-</td>
        </tr>
        <tr>
          <td class="syntax"><span class="name">strex</span> Rt, Rs, [Rn <span class="optional">{, #const}</span>]</td>
          <td class="semantic">if EX then [Rn + const] &colone; Rs; Rd &colone; 0 else Rd &colone; 1</td>
          <td class="flag">-</td>
        </tr>
      </table>
      <p>
        The synchronisation instructions work with a special "exclusive monitor"
        (denoted EX in the table) that tracks the "exclusive state" of the CPU.
        <ul>
          <li>
            Every LDREX instruction will succeed and set the exclusive state to true.
          </li>
          <li>
            An STREX instruction will check the exclusive state, and if true,
            will execute the store, write 0 to Rd, and set the state to false. If the state
            was already false, the store is not executed and Rd is set to 1. This entire
            sequence is done atomically.
          </li>
          <li>
            A context switch (such as an interrupt) will set the exclusive state to false.
          </li>
        </ul>
        The end effect is that only the first STREX performed after the latest LDREX
        with no context switches in between will execute its store.
      </p>
    </div>
  </li>
</ul>

- Instructions with an optional `s` suffix will only change [the flags](#flags) if this suffix is added.
- Optional constants and shifts default to 0 / no shift.
- Square brackets such as in `[Rd]` denote the memory stored at the given address,
  in this case the address held in Rd.


## Shifts {#shifts}

<style>
  table.shifts td {
    text-align: left;
  }

  table.shifts td:first-child {
    font-family: monospace;
    white-space: nowrap;
  }

  table.shifts td:nth-child(2) {
    white-space: nowrap;
  }
</style>

<table class="shifts">
  <tr>
    <th>Shift</th>
    <th>Meaning</th>
    <th>Description</th>
  </tr>
  <tr id="shift-lsl">
    <td>LSL n</td>
    <td>Logical shift left</td>
    <td>Shift the bits left by \(n\), discarding the higher bits and filling the lower ones with 0</td>
  </tr>
  <tr id="shift-lsr">
    <td>LSR n</td>
    <td>Logical shift right</td>
    <td>Shift the bits right by \(n\), filling the higher bits with 0 and discarding the lower ones</td>
  </tr>
  <tr id="shift-asr">
    <td>ASR n</td>
    <td>Arithmetic shift right</td>
    <td>Shift the bits right by \(n\), filling the higher bits with copies of bit 15 and discarding the lower ones. This preserves the sign of a signed number</td>
  </tr>
  <tr id="shift-ror">
    <td>ROR n</td>
    <td>Rotate right</td>
    <td>Rotate the bits right by \(n\), filling the higher bits with the lower bits being shifted out</td>
  </tr>
  <tr id="shift-rrx">
    <td>RRX</td>
    <td>Rotate right with carry</td>
    <td>Rotate the bits right by 1, filling bit 15 with the carry flag and discarding bit 0</td>
  </tr>
</table>

## Flags {#flags}

<style>
  table.flags td {
    text-align: left;
  }

  table.flags td:first-child {
    text-align: center;
  }
</style>

<table class="flags">
  <tr>
    <th>Flag</th>
    <th>Meaning</th>
    <th>Description</th>
  </tr>
  <tr id="flag-n">
    <td>N</td>
    <td>Negative</td>
    <td>The result, viewed as a two's complement signed number, is negative</td>
  </tr>
  <tr id="flag-z">
    <td>Z</td>
    <td>Zero</td>
    <td>The result equals 0</td>
  </tr>
  <tr id="flag-c">
    <td>C</td>
    <td>Carry</td>
    <td>Instruction dependent. For addition, the result wrapped past 2<sup>32</sup></td>
  </tr>
  <tr id="flag-v">
    <td>V</td>
    <td>Overflow</td>
    <td>Instruction dependent. For addition, the inputs have the same sign that is different than the results</td>
  </tr>
  <tr id="flag-q">
    <td>Q</td>
    <td>Saturated</td>
    <td>Signed overflow (result saturated)</td>
  </tr>
</table>


## Conditions {#conditions}

<style>
  table.conditions td {
    text-align: left;
  }

  table.conditions td:first-child {
    font-family: monospace;
    text-align: center;
  }

  table.conditions td:nth-child(3) {
    font-family: monospace;
  }
</style>

<table class="conditions">
  <tr>
    <th>Condition</th>
    <th>Meaning</th>
    <th>Flags</th>
  </tr>
  <tr id="cond-eq">
    <td>eq</td>
    <td>Equal</td>
    <td>Z = 1</td>
  </tr>
  <tr id="cond-ne">
    <td>ne</td>
    <td>Not equal</td>
    <td>Z = 0</td>
  </tr>
  <tr id="cond-cs-hs">
    <td>cs, hs</td>
    <td>Carry set, unsigned higher or same</td>
    <td>C = 1</td>
  </tr>
  <tr id="cond-cc-lo">
    <td>cc, lo</td>
    <td>Carry clear, unsigned lower</td>
    <td>C = 0</td>
  </tr>
  <tr id="cond-mi">
    <td>mi</td>
    <td>Minus, negative</td>
    <td>N = 1</td>
  </tr>
  <tr id="cond-pl">
    <td>pl</td>
    <td>Plus, positive or zero</td>
    <td>N = 0</td>
  </tr>
  <tr id="cond-vs">
    <td>vs</td>
    <td>Overflow set</td>
    <td>V = 1</td>
  </tr>
  <tr id="cond-vc">
    <td>vc</td>
    <td>Overflow clear</td>
    <td>V = 0</td>
  </tr>
  <tr id="cond-hi">
    <td>hi</td>
    <td>Unsigned higher</td>
    <td>C = 1 &and; Z = 0</td>
  </tr>
  <tr id="cond-ls">
    <td>ls</td>
    <td>Unsigned lower or same</td>
    <td>C = 0 &or; Z = 1</td>
  </tr>
  <tr id="cond-ge">
    <td>ge</td>
    <td>Signed greater or equal</td>
    <td>N = V</td>
  </tr>
  <tr id="cond-lt">
    <td>lt</td>
    <td>Signed less</td>
    <td>N &ne; V</td>
  </tr>
  <tr id="cond-gt">
    <td>gt</td>
    <td>Signed greater</td>
    <td>Z = 0 &and; N = V</td>
  </tr>
  <tr id="cond-le">
    <td>le</td>
    <td>Signed less or equal</td>
    <td>Z = 1 &or; N &ne; V</td>
  </tr>
  <tr id="cond-al">
    <td>al, &lt;omit></td>
    <td>Always</td>
    <td>any</td>
  </tr>
</table>


## Width {#width}

<style>
  table.width td {
    text-align: left;
  }

  table.width td:first-child {
    font-family: monospace;
    text-align: center;
  }
</style>

<table class="width">
  <tr>
    <th>Suffix</th>
    <th>Meaning</th>
    <th>Opcode width</th>
  </tr>
  <tr id="width-n">
    <td>.n</td>
    <td>Narrow</td>
    <td>16 bits</td>
  </tr>
  <tr id="width-w">
    <td>.w</td>
    <td>Wide</td>
    <td>32 bits</td>
  </tr>
  <tr id="width-omit">
    <td>&lt;omit></td>
    <td>Unset</td>
    <td>Assembler decides</td>
  </tr>
</table>

The width is an optional suffix on the instruction name (after any condition).

{% comment %}

Cheatsheet instructions that have both narrow and wide encodings are as follows. Note that specifying the width may allow you to use only subset of the instructions capabilities (e.g., narrow encodings may only support smaller immediate value constants or registers below R7).

<ul style="column-count:4;font-family:monospace">
  <li>adc (reg)</li>
  <li>add (imm)</li>
  <li>add (reg)</li>
  <li>and (reg)</li>
  <li>asr (imm)</li>
  <li>asr (reg)</li>
  <li>b</li>
  <li>cmp (imm)</li>
  <li>cmp (reg)</li>
  <li>cmn (reg)</li>
  <li>eor (reg)</li>
  <li>ldmia</li>
  <li>ldr (imm)</li>
  <li>ldr (lit)</li>
  <li>ldr (reg)</li>
  <li>lsl (imm)</li>
  <li>lsl (reg)</li>
  <li>lsr (imm)</li>
  <li>lsr (reg)</li>
  <li>mov (imm)</li>
  <li>mov (reg)</li>
  <li>mul</li>
  <li>orr (reg)</li>
  <li>qadd</li>
  <li>qsub</li>
  <li>ror (reg)</li>
  <li>rsb (imm)</li>
  <li>sbc (reg)</li>
  <li>stmia</li>
  <li>str (imm)</li>
  <li>str (reg)</li>
  <li>sub (imm)</li>
  <li>sub (reg)</li>
  <li>tst (reg)</li>
</ul>

{% endcomment %}
