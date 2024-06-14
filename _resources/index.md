---
title: Resources
permalink: /resources/
hidden: True
toc: true
layout: page
---

Here's the various resources and documentation that we provide in COMP2300/6300.

{% for item in site.resources %}
{% unless item.hidden %}
{% if item.title contains ":" %}
  {% assign tag = item.title | split: ":" | first %}
{% endif %}
{% assign title = item.title %}
{% assign link_url = item.url | prepend: site.baseurl %}
{% assign image_url = item.image %}
{% assign image_url = image_url | relative_url %}
{% assign text = item.summary | default: item.excerpt | strip_html %}

<h2><a href="{{ link_url }}">{{ title }}</a></h2>
<p>{{ text }} <a href="{{ link_url }}">(link)</a></p>

{% endunless %}
{% endfor %}
