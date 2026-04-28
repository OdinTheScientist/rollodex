# Rollodex

> A BJJ technique and learning resource tracker built by a coach, for coaches.

---

## What it is

Rollodex is a personal knowledge base for Brazilian Jiu-Jitsu practitioners and coaches to organize techniques, positions, and learning resources. Instead of scattered YouTube bookmarks and mental notes, Rollodex gives you a structured library where techniques are connected to the positions they start and end in, tagged by audience and context, and linked to videos, instructionals, and match footage.

Built by a BJJ coach who also teaches a kids class, the app reflects real domain knowledge — the data model distinguishes between attacker and defender roles within positions, handles leg entanglements where top/bottom orientation breaks down, and supports aliases so "cross side" and "side mount" both find Side Control.

---

## Why it exists

Two reasons.

**First, a genuine personal need.** As a coach managing curriculum for multiple age groups (young kids, older kids, adult gi, adult no-gi), keeping track of techniques, appropriate resources, and class planning in my head wasn't scaling.

**Second, as a deliberate exercise in domain-driven design.** I've been reading Eric Evans' *Domain-Driven Design* and wanted to apply its principles to a real problem I understood deeply. The data model emerged from genuine domain conversations rather than generic CRUD thinking — the role enum on `PositionVariant` (`attacker/defender/neutral/mutual`) exists because top/bottom breaks down for leg entanglements like Ashi Garami. "Mutual" exists because the hand fight in neutral standing is genuinely symmetric — both players have the same goal until someone commits to a takedown attempt.

---

## Tech stack

| Layer | Technology |
|---|---|
| Backend | Ruby on Rails 8 |
| Database | PostgreSQL 18 |
| Frontend | Hotwire (Turbo + Stimulus) — live search and partial page updates without a JS framework |
| Styling | Tailwind CSS |
| Search | pg_trgm — PostgreSQL trigram extension for fuzzy full-text search |
| Dev tooling | Bullet — N+1 query detection in development |

---

## Data model highlights

The schema was designed carefully before any code was written. A few decisions worth calling out:

### Position vs PositionVariant

Positions are families (Side Control, Mount, Ashi Garami). Variants are the specific orientations within a position. Each variant has a role enum: `attacker`, `defender`, `neutral`, or `mutual`. This handles the fact that "top/bottom" is a useful spatial shorthand for classical positions but breaks down entirely for leg entanglements and is actually misleading for guard positions where the bottom player is often the attacker.

### Double `has_many :through` on Technique

A technique has two separate join tables — one for starting position variants and one for ending position variants. This keeps them as distinct concepts rather than a single table with a `side` column that would require filtering. In Rails this means two separate `has_many :through` associations pointing at the same model (`PositionVariant`) via different join tables, each requiring a `source:` option because the association names don't match the model name.

### Polymorphic Alias model

Positions, `PositionVariants`, and Techniques all support alternative names through a single polymorphic `Alias` model. "Cross Side" and "Side Mount" alias Side Control. "Juji Gatame" aliases Armbar. One table, one model, works for any aliasable entity. The tradeoff: polymorphic associations can't have database-level foreign key constraints, so Rails is trusted to maintain referential integrity.

### Domain-Driven Design in Practice

The ubiquitous language emerged from genuine domain conversation. Terms like "attacker," "defender," and "mutual" were chosen because they're how coaches actually talk about positions — not because they mapped neatly to a database schema. The hand fight in neutral standing is "mutual" because both players genuinely have the same goal and role until someone commits. That's not a database abstraction, it's a real concept in the sport.

The alias system exists because BJJ has legitimate terminology conflicts across lineages. "Cross side" and "side mount" mean the same thing as "side control" to different coaches. Modeling this explicitly means search and navigation work regardless of which term a user knows.

---

## Technical highlights

### N+1 Query Elimination

The positions index initially ran 9 queries to render 7 positions — one to load positions, then one `COUNT(*)` per position for the variant count. Root cause: `.count` always hits the database regardless of whether the association is cached. Fix: switching to `.size`, which checks the in-memory cache first. Result: 2 queries, response time dropped from 811ms to 37ms.

The technique show page loads 6 associations (aliases, tags, resources, starting position variants, ending position variants, and their parent positions) in 10 queries with zero N+1 using nested eager loading:

```ruby
Technique.includes(
  :aliases,
  :tags,
  :resources,
  starting_position_variants: :position,
  ending_position_variants: :position
)
```

### pg_trgm Fuzzy Search

Search uses PostgreSQL's trigram extension rather than simple `ILIKE`. Trigrams are three-character fragments of strings — "armbar" breaks into `" ar"`, `"arm"`, `"rmb"`, `"mba"`, `"bar"`. PostgreSQL indexes these fragments using a GIN (Generalized Inverted Index) and measures similarity by counting overlapping trigrams between the search term and stored values.

GIN was chosen over B-tree because B-tree indexes are optimized for ordered scalar comparisons and can't efficiently support trigram set lookups. GIN maps values to records rather than records to values — "trigram `'arm'` appears in records [1, 4, 7]" — making lookups by trigram instant regardless of dataset size.

Threshold tuning required real debugging. The default word similarity threshold was discovered to be 0.6 — not 0.3 as assumed — by querying PostgreSQL directly:

```ruby
ActiveRecord::Base.connection.execute(
  "SHOW pg_trgm.word_similarity_threshold"
).first
# => {"pg_trgm.word_similarity_threshold" => "0.6"}
```

Additionally, the `%` similarity operator was replaced with the `word_similarity()` function directly, giving explicit control over the threshold rather than relying on the operator's session-level setting.

Lowering to 0.3 caused noise — "gard" matched both "Closed Guard" and "Ashi Garami" because both scored 0.4 similarity. The solution: queries under 5 characters use `ILIKE` substring matching (precise), longer queries use word similarity with a 0.4 threshold (fuzzy). This is a precision vs recall tradeoff — lower thresholds increase recall at the cost of result relevance.

---

## Setup

```bash
git clone https://github.com/OdinTheScientist/rollodex.git
cd rollodex
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

> Note: update `config/database.yml` with your local PostgreSQL credentials before running `db:create`.

---

## What's next

- **TrainingGroup model** — associate techniques with specific class audiences (young kids 5–11, older kids 12–16, adult gi, adult no-gi). Deferred to keep Phase 1 scope clean.
- **Resources UI** — currently resources are seed-only. Full CRUD for adding YouTube links and instructionals is the highest-priority Phase 2 feature.
- **Alias-aware search** — searching "juji" doesn't currently find Armbar. A known limitation worth solving.
- **Student sharing** — long-term vision is hosting publicly so coaches can share technique libraries with students.