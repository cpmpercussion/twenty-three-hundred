---
title: Assessments
tagline: "Assignments, Exams, Quizzes, and Lab Tasks"
permalink: /assessments/
hidden: True
show_collection: true
show_toc: true
layout: page
---

{% for item in site.assessments %}
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
{% if image_url %}
  <div class="card__image"><img src="{{ image_url }}"> </div>
{% endif %}
<p>{{ text }} <a href="{{ link_url }}">(link)</a></p>

{% endunless %}
{% endfor %}
