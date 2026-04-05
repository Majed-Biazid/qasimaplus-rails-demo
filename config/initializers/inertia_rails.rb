InertiaRails.configure do |config|
  config.use_script_element_for_initial_page = true
  config.ssr_enabled = ENV.fetch("INERTIA_SSR", "false") == "true"
  config.ssr_url = ENV.fetch("INERTIA_SSR_URL", "http://localhost:13714")
end
