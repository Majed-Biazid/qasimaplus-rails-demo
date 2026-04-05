Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # ── Internal: Hotwire + ERB + ViewComponent ──────────────────────
  namespace :internal do
    root to: "dashboard#index"
    get  "dashboard", to: "dashboard#index", as: :dashboard
    resources :jobs,      only: %i[index create update destroy]
    resources :customers, only: %i[index show]
  end

  # ── External: Inertia + React — Consumer Portal ─────────────────
  namespace :external do
    root to: "home#index"
    get "home", to: "home#index"
    resources :vouchers, only: %i[index show]
    get "profile", to: "profile#index"
  end

  root to: redirect("/internal")
end
