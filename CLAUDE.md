# Rollodex — CLAUDE.md

## What this app is

Rollodex is a BJJ (Brazilian Jiu-Jitsu) technique and learning resource tracker built by a coach who also teaches a kids class. It organizes techniques, positions, and learning resources (YouTube videos, instructionals, articles) so coaches can plan curriculum and students can explore material.

This is a real app used by the developer — not a portfolio toy. Design decisions should reflect genuine coaching workflows.

---

## Tech Stack

- **Ruby on Rails 8.1** — server-rendered views, Rails conventions throughout
- **PostgreSQL 18** — primary database
- **Hotwire (Turbo + Stimulus)** — live interactions without a JS framework
- **Tailwind CSS** — utility-first styling, no custom CSS files
- **pg_trgm** — PostgreSQL trigram extension for fuzzy full-text search
- **Bullet** — N+1 query detection in development
- **annotaterb** — auto-annotates model files with schema info after migrations

---

## Domain Vocabulary (Ubiquitous Language)

These terms have specific meanings in this codebase. Use them consistently:

**Position** — a family of related situations (Side Control, Mount, Ashi Garami). NOT a specific orientation.

**PositionVariant** — a specific orientation within a position (Side Control Top, Side Control Bottom). Has a `role` enum: `attacker`, `defender`, `neutral`, `mutual`.

**Why `role` instead of `top/bottom`** — top/bottom breaks down for leg entanglements (Ashi Garami has no meaningful top/bottom, only attacker/defender). Guard positions invert the attacker (bottom player attacks). `mutual` covers genuinely symmetric situations like the hand fight in neutral standing.

**Technique** — a specific move (Armbar, Scissor Sweep, Hip Escape). Has a `technique_type` enum and `gi_nogi` enum.

**Resource** — a learning material (YouTube video, instructional series, article, match footage, personal note). Can be linked to multiple techniques AND multiple positions.

**Foundational** — a boolean on Resource. When true, the resource appears on ALL position pages where its linked techniques appear, not just explicitly linked positions. Example: a "short leg triangle finish" video linked to the Triangle Choke technique with `foundational: true` will appear on Closed Guard, Mount, and any other position where Triangle starts.

**Alias** — an alternative name for a Position, PositionVariant, or Technique. "Cross Side" and "Side Mount" are aliases for Side Control. Implemented as a polymorphic model.

**Tag** — a label on a Technique. Examples: "fundamental", "kids-class", "competition", "no-gi-only".

---

## Architecture Decisions

### Two join tables for technique positions (not one)

`TechniqueStartingPositionVariant` and `TechniqueEndingPositionVariant` are intentionally separate tables — NOT one table with a `side` column. Starting and ending positions are genuinely different concepts. An armbar starts from guard/mount/back and ends when submitted (no ending position). A scissor sweep starts from closed guard bottom and ends at mount top.

This gives clean Rails associations:
```ruby
technique.starting_position_variants
technique.ending_position_variants
```

Both return `PositionVariant` objects but through different join tables. Both need `source: :position_variant` because the association names don't match the model name.

### Polymorphic Alias model

One `Alias` model with `aliasable_type` and `aliasable_id` serves Position, PositionVariant, and Technique. Adding aliases to new models requires only `has_many :aliases, as: :aliasable` — no new tables.

Tradeoff: no database-level foreign key constraints on polymorphic associations.

### Resource associations (two join tables)

`ResourceTechnique` — links resources to techniques
`ResourcePosition` — links resources to positions explicitly

A resource can be linked to both. The `foundational` boolean on Resource determines whether it propagates to related positions automatically.

### Search uses pg_trgm word similarity

Both Position and Technique have a `search` scope using PostgreSQL's trigram extension with a GIN index. Queries under 5 characters use ILIKE (precise substring), longer queries use `word_similarity > 0.35` (fuzzy). This is a deliberate precision/recall tradeoff — tuned to avoid noise while catching near-matches.

---

## Models Overview

Position
has_many :variants (PositionVariant), dependent: :destroy
has_many :aliases, as: :aliasable
has_many :resource_positions
has_many :resources, through: :resource_positions
PositionVariant
belongs_to :position
has_many :technique_starting_position_variants
has_many :available_techniques, through: :technique_starting_position_variants, source: :technique
has_many :aliases, as: :aliasable
role enum: attacker(0), defender(1), neutral(2), mutual(3)
Technique
has_many :technique_starting_position_variants
has_many :starting_position_variants, through: ..., source: :position_variant
has_many :technique_ending_position_variants
has_many :ending_position_variants, through: ..., source: :position_variant
has_many :taggings → has_many :tags
has_many :aliases, as: :aliasable
has_many :resource_techniques → has_many :resources
technique_type enum: submission/sweep/pass/escape/takedown/transition/control/recovery
gi_nogi enum: both/gi_only/nogi_only
Resource
has_many :resource_techniques → has_many :techniques
has_many :resource_positions → has_many :positions
foundational: boolean (default false)
resource_type enum: video/instructional_series/article/match_footage/personal_note
youtube_id method: extracts YouTube video ID from url
Tag
has_many :taggings → has_many :techniques
Alias (polymorphic)
belongs_to :aliasable (Position, PositionVariant, or Technique)

---

## Controllers

All controllers follow Rails conventions:
- `before_action :set_[model]` for show/edit/update/destroy
- Strong params with explicit permit lists
- `render :new, status: :unprocessable_entity` on create failure
- `render :edit, status: :unprocessable_entity` on update failure
- `redirect_to @[model]` on success

Eager loading is critical — always use `includes` to avoid N+1 queries. Example:
```ruby
@technique = Technique.includes(
  :aliases, :tags, :resources,
  starting_position_variants: :position,
  ending_position_variants: :position
).find(params[:id])
```

---

## Views

- Tailwind CSS only — no custom CSS
- Shared search partial: `render "shared/search", url: [path], placeholder: "..."`
- Card grid pattern: `grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4`
- Cards: `bg-white rounded-2xl border border-gray-100 shadow-sm hover:shadow-lg`
- Color-coded category dots on position cards
- Color-coded type badges on technique cards
- Back links use chevron SVG pattern
- Tom Select for multi-select associations (loaded via CDN in form partials)

---

## Routes

```ruby
root "positions#index"
resources :positions
resources :techniques
resources :resources
```

Note: The generated `get "resources/index"` etc. routes at the top of routes.rb are stale — they should be removed. Only `resources :resources` is needed.

---

## Database Conventions

- All boolean columns: `null: false, default: [value]`
- All string/integer columns used in queries: indexed
- Join tables: composite unique index on both foreign keys
- Long index names use explicit `name:` to avoid PostgreSQL 63-char limit
- Foreign key constraints on all `references` columns
- pg_trgm GIN indexes on searchable string columns

---

## What NOT to do

- **Do not add a `difficulty_level` column to Technique** — deliberately omitted. Audience targeting is handled via Tags and a planned `TrainingGroup` model.
- **Do not use `position.top` or `position.bottom`** — use `role: :attacker` / `role: :defender` instead
- **Do not use string concatenation with `+=` in loops** — use `<<` or collect into array then join
- **Do not use `.count` in views after eager loading** — use `.size` to avoid extra queries
- **Do not generate a single join table for starting and ending positions** — they must remain separate tables
- **Do not remove the `source:` option** from `starting_position_variants` or `ending_position_variants` associations

---

## Seed Data

Run `bin/rails db:seed` to populate development data. The seed file:
- Destroys in reverse dependency order (children before parents)
- Creates 7 positions with 12 variants
- Creates 8 techniques with starting/ending position associations
- Creates tags, taggings, aliases, and resources

---

## Phase 2 Roadmap (not yet implemented)

- **TrainingGroup model** — associate techniques/resources with specific class audiences (young kids 5-11, older kids 12-16, adult gi, adult no-gi)
- **Alias-aware search** — currently search only matches on name, not aliases
- **Class Plans / Lesson sequences** — ordered sequences of techniques for a specific class session
- **Student sharing** — multi-user access so coaches can share libraries with students