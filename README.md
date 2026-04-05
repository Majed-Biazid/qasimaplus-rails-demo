# QasimaPlus Rails Demo

A Rails 7 fullstack demo inspired by [QasimaPlus](https://qasimaplus.com) — Autobia's consumer loyalty platform. Demonstrates two frontend paradigms in a single codebase: a **consumer voucher portal** (React) and an **admin panel** (Hotwire).

## Architecture

| Aspect | Admin (`/internal`) | Consumer Portal (`/external`) |
|--------|----------------------|-------------------------------|
| **Frontend** | Hotwire (Turbo Streams + Turbo Drive) | Inertia.js + React 19 |
| **Templates** | ERB + ViewComponent | TSX (ShadCN / Radix UI) |
| **Styling** | Scoped CSS (`ops-*` classes) | Tailwind CSS v4 + CSS variables |
| **Animations** | CSS @keyframes + transitions | Motion (Framer Motion) |
| **Data flow** | Controller `@vars` → ERB | Controller → Inertia props → `usePage()` |
| **Real-time** | Turbo Streams (WebSocket) | Client-side state (React hooks) |
| **Mobile** | CSS media queries + drawer | Tailwind responsive + animated drawer |

Both sides share the same database, models, and Vite asset pipeline.

## Pages

### Consumer Portal (React + Inertia)

| Route | Page | Description |
|-------|------|-------------|
| `/external/home` | Home | Greeting, spending summary, 5 recent voucher cards |
| `/external/vouchers` | Voucher History | Monthly pill tabs, vouchers grouped by date (Today/Yesterday/date) |
| `/external/vouchers/:id` | Voucher Detail | Receipt layout — SAR amount, status, merchant, order ID (copyable), VAT breakdown |
| `/external/profile` | Profile | Initials avatar, stats, editable profile form |

### Admin Panel (Hotwire + ERB)

| Route | Page | Description |
|-------|------|-------------|
| `/internal/dashboard` | Dashboard | Voucher stats, recent vouchers feed, live Job Queue (Turbo Streams) |
| `/internal/jobs` | Job Queue | Add/run/complete/delete jobs — broadcasts to all tabs instantly |
| `/internal/customers` | Consumers | Consumer list with voucher counts and SAR revenue |
| `/internal/customers/:id` | Consumer Detail | Profile card + voucher history |

## Tech Stack

- **Ruby 3.3** / **Rails 7.2** — backend framework
- **Vite 8** via `vite-plugin-ruby` — serves both Hotwire JS and React JSX
- **Inertia Rails 3.20** — server-driven SPA, no API layer needed
- **React 19** + **ShadCN UI** (Radix primitives + Tailwind)
- **Motion** (Framer Motion) — page transitions, staggered reveals, spring drawer
- **Hotwire** — Turbo Streams, Turbo Drive, Stimulus
- **ViewComponent** — testable Ruby components with ERB templates
- **Tailwind CSS v4** — utility-first styling
- **SQLite** — zero-config database

## Setup

```bash
git clone https://github.com/Majed-Biazid/qasimaplus-rails-demo.git
cd qasimaplus-rails-demo

# Install dependencies
bundle install
npm install

# Create and seed database
bin/rails db:prepare
bin/rails db:seed

# Start both servers (Vite required for React HMR)
bin/vite dev &
bin/rails s -p 3000
```

Then visit:
- **Consumer Portal** — http://localhost:3000/external
- **Admin Panel** — http://localhost:3000/internal

## Docker

Single container with all assets compiled inside. Targets GCP Cloud Run.

```bash
# Build
docker build -t qasimaplus-demo .

# Run locally
docker run -p 3000:3000 qasimaplus-demo

# Deploy to Cloud Run
gcloud run deploy qasimaplus-demo --source . --region us-central1 --allow-unauthenticated
```

## Data Model

Existing Rails models repurposed for the voucher domain — no custom migrations:

| Model | Role | Key Fields |
|-------|------|------------|
| `Customer` | Consumer | name, email, phone (via company), plan, joined_on |
| `Order` | Voucher | merchant (via product_name), amount, status, placed_on |
| `Product` | Merchant | name, location (via description), category |
| `Job` | Background Job | title, status, priority (Turbo Streams demo) |

Seed data: 6 Saudi consumers, 12 merchants (Jarir, Starbucks, IKEA, Noon, Al Baik, Careem...), 24 vouchers with today/yesterday dates.

## Project Structure

```
app/
  controllers/
    internal/                # Hotwire controllers (dashboard, jobs, consumers)
    external/                # Inertia controllers (home, vouchers, profile)
  javascript/
    entrypoints/
      internal.js            # Hotwire + Stimulus
      external.jsx           # Inertia + React
      application.css        # Tailwind + ShadCN CSS variables
    components/
      layout/AppLayout.tsx   # React sidebar (mobile drawer with Motion)
      ui/                    # ShadCN components (Button, Card, Badge, Tabs...)
    pages/
      External/
        Home/Index.tsx       # Consumer home — greeting + recent vouchers
        Vouchers/Index.tsx   # Monthly history with date grouping
        Vouchers/Show.tsx    # Receipt detail with copy-to-clipboard
        Profile/Index.tsx    # Consumer profile with edit mode
  views/
    layouts/
      internal.html.erb     # Admin layout (scoped CSS + mobile drawer)
      external.html.erb     # Inertia layout (Vite + React)
    internal/               # ERB templates (dashboard, consumers, jobs)
  components/               # ViewComponent Ruby components
config/
  routes.rb                 # Namespaced: /internal + /external
  initializers/
    inertia_rails.rb        # Inertia v3 script element mode
vite.config.ts              # Vite + React plugin + Tailwind + Ruby plugin
Dockerfile                  # Multi-stage production build
```

## License

MIT
