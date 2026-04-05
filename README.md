# QasimaPlus Rails Demo

A fullstack reference implementation exploring two frontend paradigms — **React (SPA)** and **Hotwire (MPA)** — within a single Rails backend. Inspired by [QasimaPlus](https://qasimaplus.com), Autobia's consumer loyalty platform.

This project demonstrates how to ship a consumer-facing portal and an internal admin panel from one codebase, sharing models, database, and asset pipeline — while each frontend follows its own rendering strategy, state management pattern, and interaction model.

---

## Why Two Frontends?

Modern teams often debate between SPA and server-rendered approaches. This project doesn't pick a side — it runs both, side by side, so you can evaluate the tradeoffs in real code:

| | Consumer Portal (`/external`) | Admin Panel (`/internal`) |
|-|-------------------------------|--------------------------|
| **Rendering** | Inertia.js — server-driven SPA. No API, no fetch. Controller sends props, React renders. | Turbo Drive — server renders HTML, Turbo swaps the `<body>` without full reload. |
| **Components** | React 19 + ShadCN UI (Radix primitives composed with Tailwind) | ERB + ViewComponent (testable Ruby components with paired templates) |
| **State** | React hooks (`useState`, `useMemo`). All filtering, tabs, and forms are client-side. | Server-side. Turbo Streams push DOM patches over WebSocket — no client JS needed. |
| **Animations** | Motion (Framer Motion) — page transitions, staggered reveals, spring-physics drawer | CSS `@keyframes` + transitions. No JS animation library. |
| **Styling** | Tailwind CSS v4 with CSS variables (ShadCN theming) | Scoped CSS in layout `<style>` block (`ops-*` namespace) — zero Tailwind dependency |
| **Mobile** | Responsive via Tailwind (`sm:`, `md:`, `lg:`) + animated sidebar drawer | CSS media queries + vanilla JS drawer toggle |
| **Data flow** | Controller → Inertia props → `usePage().props` in any component | Controller `@instance_vars` → ERB templates directly |

Both share: **Rails 7.2 backend**, **Vite 8 asset pipeline**, **SQLite database**, **same models and validations**.

---

## Pages

### Consumer Portal (React + Inertia + Motion)

| Route | What it does |
|-------|-------------|
| `/external/home` | Greeting with consumer name, spending summary (SAR total + voucher count), 5 recent voucher cards with staggered fade-in |
| `/external/vouchers` | Monthly pill-tab filter (client-side), vouchers grouped by relative date — "Today", "Yesterday", "Apr 2" — each clickable |
| `/external/vouchers/:id` | Receipt-style detail: large SAR amount, status badge, merchant/location, copyable order ID, date/time, payment method, consumer name, VAT 15% breakdown |
| `/external/profile` | Initials avatar, stats row (voucher count + total spent), profile info with inline edit mode |

### Admin Panel (Hotwire + ERB + ViewComponent)

| Route | What it does |
|-------|-------------|
| `/internal/dashboard` | Voucher stats (total, consumers, revenue, pending) + recent vouchers feed + live Job Queue via Turbo Streams |
| `/internal/jobs` | Add/run/complete/delete jobs — every action returns a Turbo Stream array that updates the row + refreshes stats, no page reload |
| `/internal/customers` | Consumer list with voucher counts and SAR totals, Turbo Drive navigation |
| `/internal/customers/:id` | Consumer profile card + full voucher history with merchant names and status badges |

---

## How It Works

### Inertia.js — The Bridge (External)

Inertia replaces the traditional API + SPA client pattern. The flow:

1. **Controller** renders props (plain Ruby hashes) — no JSON serializer, no API endpoint
2. **Inertia middleware** wraps the props into a page object and sends it to the client
3. **React** receives props via `usePage().props` and renders components

```ruby
# Controller — looks like normal Rails
render inertia: "External/Vouchers/Show", props: {
  voucher: serialize_voucher_detail(order),
}
```

```tsx
// React — receives props directly, no fetch
export default function VouchersShow({ voucher }: { voucher: Voucher }) {
  return <div>SAR {voucher.amount}</div>
}
```

Shared data (auth, flash) is injected via `inertia_share` in `BaseController` — available on every page without explicit passing.

### Turbo Streams — Live DOM Patching (Internal)

When a job is created, updated, or deleted, the controller returns an array of Turbo Stream actions:

```ruby
render turbo_stream: [
  turbo_stream.replace(@job, partial: "jobs/job", locals: { job: @job }),
  turbo_stream.replace("stats_row", partial: "dashboard/stats_row"),
]
```

Turbo intercepts the form submission, parses the `<turbo-stream>` response, and patches the DOM — replacing the job row and refreshing the stats counter in one response, zero JavaScript.

### Vite — One Pipeline, Two Entrypoints

```
entrypoints/
  internal.js    → Hotwire (Turbo + Stimulus)
  external.jsx   → Inertia + React + ShadCN
  application.css → Shared Tailwind + CSS variables
```

Each layout loads its own entrypoint. Vite serves both through `vite-plugin-ruby`, with HMR for React and CSS hot-reload for ERB pages.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Ruby 3.3 · Rails 8.0 (Solid Cable, Solid Queue, Solid Cache) |
| Consumer Frontend | React 19 · Inertia.js 3 (SSR ready) · ShadCN UI · Radix UI |
| Admin Frontend | Hotwire (Turbo Streams + Turbo Drive) · Stimulus · ViewComponent |
| Real-time | Turbo Streams + Solid Cable (no Redis needed) |
| Animations | Motion (Framer Motion) for React · CSS @keyframes for ERB |
| Styling | Tailwind CSS v4 · ShadCN CSS variables |
| Dev Server | Vite 8 via vite-plugin-ruby (no build step in development) |
| Database | SQLite (zero config) |
| Deployment | Docker multi-stage build · GCP Cloud Run ready |

---

## Prerequisites

- **Ruby 3.3+** — [install via rbenv](https://github.com/rbenv/rbenv) or asdf
- **Node 22+** — [install via nvm](https://github.com/nvm-sh/nvm) or fnm
- **Bundler** — `gem install bundler` (comes with Ruby)

---

## Setup

```bash
# 1. Clone
git clone https://github.com/Majed-Biazid/qasimaplus-rails-demo.git
cd qasimaplus-rails-demo

# 2. Install dependencies
bundle install    # Ruby gems (Rails, Inertia, ViewComponent...)
npm install       # Node packages (React, ShadCN, Motion, Tailwind...)

# 3. Create database and load sample data
bin/rails db:setup    # Creates DB + runs migrations + seeds

# 4. Start the app (two processes needed)
bin/vite dev &        # Vite dev server on :3036 (serves React + Tailwind with HMR)
bin/rails s -p 3000   # Rails server on :3000
```

Open in your browser:

- **Consumer Portal** → http://localhost:3000/external — React voucher app (home, history, receipt detail, profile)
- **Admin Panel** → http://localhost:3000/internal — Hotwire dashboard (voucher stats, live job queue, consumer management)

> **Note:** Both processes are required in development. Vite serves the React/Tailwind assets with hot-reload. Rails serves everything else. In production (Docker), Vite assets are precompiled — only Rails runs.

### Docker (production mode, no Vite process needed)

```bash
docker build -t qasimaplus-demo .
docker run -p 3000:3000 -e SECRET_KEY_BASE=$(openssl rand -hex 64) qasimaplus-demo
# Open http://localhost:3000 — everything works from one container
```

> The container auto-creates the database, runs migrations, and seeds on first start. No manual setup needed.

### Tests

```bash
bin/rails test    # 41 tests, 66 assertions — models, controllers, integration
```

---

## Data Model

All data lives in the database — zero hardcoded values. Models are repurposed for the voucher domain without custom migrations:

| Model | Domain Role | Key Fields |
|-------|------------|------------|
| `Customer` | Consumer | name, email, phone, plan (free/starter/pro/enterprise), joined_on |
| `Order` | Voucher | merchant_name, amount, status (paid→completed, pending, refunded), placed_on |
| `Product` | Merchant | name, location, category (Retail, F&B, Electronics, Services, Grocery, Entertainment) |
| `Job` | Background Job | title, status (pending/running/done/failed), priority |

Display helpers on models (`display_status`, `tax_amount`, `initials`, `voucher_count`) keep controllers thin and views clean.

**Seed data**: 6 Saudi consumers, 12 merchants (Jarir, Starbucks, IKEA, Noon, Al Baik, Careem, STC Pay...), 24 vouchers with dates including today and yesterday for realistic grouping, 10 background jobs.

---

## Project Structure

```
app/
  controllers/
    external/                    # Inertia controllers
      base_controller.rb         #   inertia_share (auth), serializers
      home_controller.rb         #   consumer home + recent vouchers
      vouchers_controller.rb     #   voucher list + receipt detail
      profile_controller.rb      #   consumer profile
    internal/                    # Hotwire controllers
      dashboard_controller.rb    #   stats + recent vouchers + jobs
      jobs_controller.rb         #   CRUD with turbo_stream responses
      customers_controller.rb    #   consumer list + detail
  javascript/
    entrypoints/
      external.jsx               # Inertia + React entrypoint
      internal.js                # Hotwire + Stimulus entrypoint
      application.css            # Tailwind + ShadCN CSS variables
    components/
      layout/AppLayout.tsx       # React sidebar layout (Motion drawer)
      ui/                        # ShadCN components (Button, Card, Badge, Tabs, Input, Select, Switch)
    pages/External/
      Home/Index.tsx             # Greeting + summary + recent vouchers
      Vouchers/Index.tsx         # Monthly tabs + date-grouped voucher list
      Vouchers/Show.tsx          # Receipt detail + copy-to-clipboard + VAT breakdown
      Profile/Index.tsx          # Avatar + stats + editable profile form
  views/
    layouts/
      external.html.erb          # Inertia layout (Vite + React preamble)
      internal.html.erb          # Admin layout (scoped CSS + mobile drawer)
    internal/                    # ERB templates
    dashboard/, jobs/            # Shared partials (_stats_row, _job, _form)
  components/                    # ViewComponent (stat_card, badge)
  models/
    customer.rb                  # initials, phone, total_spent, voucher_count
    order.rb                     # merchant_name, display_status, tax_amount
    product.rb                   # location, merchant_type
    job.rb                       # validations + recent scope
config/
  routes.rb                      # /internal + /external namespaces
  initializers/inertia_rails.rb  # Inertia v3 script element mode
vite.config.ts                   # Vite + React + Tailwind + Ruby plugin
Dockerfile                       # Multi-stage production build
test/                            # 41 tests (models, controllers, integration)
```

---

## License

MIT
