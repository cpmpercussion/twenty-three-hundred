---
title: Labs
permalink: /labs/
hidden: True
show_collection: true
show_toc: true
layout: page
---

Labs are the main learning activity for Twenty-Three Hundred.

## Lab Pages {#lab-content}

The labs are mostly self-directed, but include times for you to work with your classmates and tutors.

{% for lab in site.labs %}
{% unless lab.hidden %}
{% if lab.title contains ":" %}
  {% assign tag = lab.title | split: ":" | first %}
{% endif %}
{% assign title = lab.title %}
{% assign link_url = lab.url | prepend: site.baseurl %}
{% assign text = lab.summary | strip_html %}

1. [{{ title }}]({{ link_url }})

{% comment %}
{{ text }} [(link)]({{ link_url }})
{% endcomment %}

{% endunless %}
{% endfor %}
