---
title: Lectures
permalink: /lectures/
hidden: True
layout: page
show_collection: true
show_toc: true
---

## Lecture Videos

All lectures for this course are available as a playlist [here on YouTube](https://www.youtube.com/playlist?list=PLnRoOVbpGXfaXa0zY9N3dkCdN4Clcyxod)

<iframe width="560" height="315" src="https://www.youtube.com/embed/videoseries?si=TgBCkWWDXe5a2TIq&amp;list=PLnRoOVbpGXfaXa0zY9N3dkCdN4Clcyxod" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Lecture Slides

The lecture slides are all available below as web pages.

{% comment %}
{% include page-cards.html cards=site.lectures %}
{% endcomment %}

{% comment %}
{% include cardlist.html cards=site.lectures %}
{% endcomment %}

<ol>

{% for lecture in site.lectures %}
{% unless lecture.hidden %}
{% if lecture.title contains ":" %}
  {% assign tag = lecture.title | split: ":" | first %}
{% endif %}
{% assign title = lecture.title %}
{% assign link_url = lecture.url | prepend: site.baseurl %}
{% assign image_url = page.image %}
{% assign image_url = image_url | relative_url %}
{% assign text = lecture.summary | strip_html %}

<li><a href="{{ link_url }}">{{ title }}</a> {{ text }} </li>

{% endunless %}
{% endfor %}

</ol>

{% comment %}
<h4><a href="{{ link_url }}">{{ title }}</a></h4>
{% if image_url %}
  <div class="card__image"><img src="{{ image_url }}"> </div>
{% endif %}
<p>{{ text }} <a href="{{ link_url }}">(link)</a></p>
{% endcomment %}