# ACNH Critterpedia Tracker, a UX Case Study

**Role:** UX Design, iOS Development (solo project)
**Timeline:** 1 weekend, 2026
**Stack:** SwiftUI, offline JSON dataset, UserDefaults
**Platform:** iPhone and iPad

---

## Overview

Animal Crossing: New Horizons rewards players for completing collections of fish, bugs and sea creatures, but the game itself gives almost no support for tracking progress in a practical way. I designed and built a companion iOS app that turns collection tracking into a fast, offline checklist with the catching knowledge built into every entry.

The app was designed for one real user, my sister, which allowed me to work with direct and honest feedback during the whole process.

## The Problem

My sister plays ACNH casually and wanted to complete her Critterpedia, but she kept running into the same frustrations.

1. **No memory of what was missing.** The in-game Critterpedia only shows caught species clearly while playing. Away from that screen, she could not remember which fish or bugs she still needed, so she often spent time and bait catching duplicates.
2. **No knowledge of how to catch each one.** Every critter appears only in specific months, hours and locations. That information is not visible in the game at the moment of playing, it lives in external wikis. Looking it up meant leaving the game, opening a browser, and scrolling through dense wiki tables.
3. **Loss of motivation.** The combination of duplicates and hidden requirements made completing each collection feel like homework. She simply stopped trying.

Framed as a design problem: **the cost of knowing what to do next was higher than the fun of doing it.**

## Users and Context

- Primary user: a casual player who plays in short sessions, usually with the Switch in one hand and her phone nearby.
- Context of use: the app is a second screen companion. It is consulted in short glances during play, so speed matters more than depth.
- Constraint: the game catalog is static since 2021, there are no new critters, which opened the door to a fully offline design.

## Design Goals

1. Answer "what am I missing" in under five seconds.
2. Answer "how do I catch this one" without leaving the app.
3. Make marking a catch feel instant and satisfying.
4. Work offline, since the user should not depend on a connection while playing.

## The Solution

### Familiar mental model

The app mirrors the visual language players already know from the in-game Critterpedia, a grid of critter cards organized by category. Each category, fish, bugs and sea creatures, has its own theme color for instant orientation. Reusing the game's mental model meant zero learning curve for the target user.

### Progress at a glance

The home screen shows one card per category with a progress bar and a caught counter, for example 34 of 80. This answers the motivational question, how far am I, before the user even opens a list.

### Caught state that is impossible to miss

Caught critters appear struck through, dimmed and badged with a checkmark directly in the grid. Missing critters stay at full opacity. The visual contrast makes scanning for gaps effortless, which directly attacks the duplicate catching problem.

### Catching knowledge inside the card

Tapping any critter opens a detail card with the three pieces of information that determine catchability, active months shown as twelve chips with the valid ones highlighted, active hours, and location. A live badge, Available right now, appears when the critter can be caught at the current month and hour in the Northern Hemisphere, removing all mental math.

### Filters that match real questions

The filter menu maps to the questions a player actually asks. All, Caught, Missing, and Available now. The last one became the most used filter in practice, since it converts the app from a passive checklist into an active guide, show me what I can go catch right now.

### Marking a catch in one gesture

A long press on any grid cell toggles the caught state with haptic feedback, no navigation required. This interaction was discovered accidentally by my sister and she described it as the best part of the app, which reinforced a classic lesson, low friction on the most frequent action pays off more than any visual polish.

### Offline by design

Since the catalog never changes, the full dataset, 200 critters with months, hours, locations and prices, ships inside the app as bundled JSON sourced from the open source community dataset. There are no loading states, no errors and no API dependency. The app opens instantly, which matters for an app that is consulted mid-game.

## Key Design Decisions and Tradeoffs

| Decision | Alternative considered | Why |
|---|---|---|
| Bundled offline data | Live API (Nookipedia) | Catalog is static, offline removes latency, errors and an API key requirement |
| Long press to toggle caught | Button inside the detail card only | The most frequent action must be the cheapest one, the card button stays as a discoverable fallback |
| Northern Hemisphere only | Hemisphere switcher | The target user plays in the north, cutting scope kept the interface clean, the data model already supports adding south later |
| Grid over list | Table rows | The game uses a grid, images carry more recognition value than names for this domain |

## Outcome

- My sister completed collections she had abandoned, and reported zero duplicate catches since using the app.
- The Available now filter changed her behavior, she now opens the app to decide what to hunt instead of wandering.
- Session flow: open app, filter Available now, catch, long press, back to the game, under ten seconds of phone time per catch.

## What I Learned

1. **Designing for one real user beats designing for an imaginary average.** Direct feedback surfaced the long press discovery and the value of the Available now filter, neither of which I had prioritized initially.
2. **The best loading state is no loading state.** Choosing bundled data over a live API was the single highest impact UX decision in the project, and it came from questioning a technical default, apps fetch data, rather than from a screen design.
3. **Companion apps compete with the primary activity for attention.** Every second the user spends in the app is a second away from the game, so the design metric that mattered was time to answer, not time in app.

## Possible Features

- Southern Hemisphere toggle for broader use.
- Fossils, art and villagers as new categories, the architecture already supports it.
- A widget showing what is available right now without opening the app.
