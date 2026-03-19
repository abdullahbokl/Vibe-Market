# AGENTS.md

# VibeMarket — Project Rules for Codex

## Project Overview
VibeMarket is a premium **social marketplace** designed around "Drop Culture".

The platform combines:
- social product discovery
- limited-time flash sales
- real-time user engagement
- fast checkout and fulfillment

Users discover products through a **vertical social feed**, semantic search, and real-time social interactions.

Core experience pillars:
- Semantic product discovery
- Social product feed
- Limited-time drops
- Fast and trusted checkout

Codex must respect these product principles when generating features or architecture.

---

# Technical Architecture

## Clean Architecture (Mandatory)

The Flutter project follows strict clean architecture.

Folder structure:

lib/
  core/
  features/
    feature_name/
      data/
      domain/
      presentation/

Rules:

core/
- shared widgets
- network clients
- theme
- error handling

features/
- each feature must be isolated

data layer:
- models
- datasource
- repository implementation

domain layer:
- entities
- repository interfaces
- use cases

presentation layer:
- cubit / bloc
- ui pages
- widgets

Never mix layers.

---

# State Management

Use Bloc architecture.

Rules:

Use Cubit for:
- simple UI states
- view states
- loading/error states

Use Bloc for:
- complex event-driven logic
- real-time systems
- ordering logic
- bidding logic

All repository responses must return:

Either<Failure, T>

Use the dartz package.

---

# Dependency Injection

Use:

get_it

Rules:
- no manual singleton creation
- all services must be registered in DI

---

# Backend Stack

Backend uses Supabase + PostgreSQL.

Auth:
- Supabase Auth
- Google login
- Email login

Database:
- PostgreSQL
- Row Level Security MUST be enabled on all tables

Search:
- semantic search using pgvector

Realtime:

Use Broadcast for:
- reactions
- live viewers
- ephemeral events

Use CDC for:
- orders
- inventory
- stock updates

---

# Feature Requirements

## AI Semantic Search

Search must use OpenAI embeddings.

Embedding model:
text-embedding-3-small

Flow:

1 user enters query
2 edge function generates embedding
3 query products table using cosine similarity
4 return ranked results

---

## Social Feed

Feed is vertical like TikTok.

Requirements:

- high quality product media
- smooth scrolling

Performance rule:

Images must use:

CachedNetworkImage

with optimized memCacheWidth.

Feed must maintain 60fps scrolling.

---

## Flash Sales

Products may include:

sale_end_time

Rules:

- countdown timers must update live
- inventory updates must be realtime

Use Supabase Realtime CDC for:

inventory_count updates

All clients must receive updates instantly.

---

## Secure Checkout

Stripe integration required.

Transactions must include:

idempotency_key

Format:

user_id + product_id + timestamp

Purpose:
prevent duplicate charges.

Database automation:

A Postgres trigger must listen for:

order_status = 'paid'

Trigger must call an Edge Function that:

- notifies warehouse
- notifies user

---

# Coding Standards

Follow:

SOLID principles
DRY principles

Rules:

- no duplicated logic
- shared widgets go in core/common_widgets

Null Safety:

Never use the ! operator.

Use:
- null checks
- ??
- safe patterns

Naming:

Always use descriptive names.

Example:

ProductPriceUpdateSubscription

Never use short names like:

pUpdate

---

# UI Design

Theme style:

Premium Dark Theme

Color palette:

Primary:
Black
Deep Gray

Accent:
Gold

UI should feel premium and minimal.