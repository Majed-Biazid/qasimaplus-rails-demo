# ── Jobs (Turbo Streams demo) ─────────────────────────────────────
jobs = [
  { title: "Sync invoices from Stripe",        status: "done",    priority: "high"   },
  { title: "Send weekly digest emails",         status: "done",    priority: "medium" },
  { title: "Process refund #REF-4821",          status: "running", priority: "high"   },
  { title: "Generate monthly PDF report",       status: "running", priority: "medium" },
  { title: "Import new merchant CSV",           status: "pending", priority: "high"   },
  { title: "Cleanup expired sessions",          status: "pending", priority: "low"    },
  { title: "Reindex search catalogue",          status: "pending", priority: "medium" },
  { title: "Push notifications batch #7",       status: "pending", priority: "low"    },
  { title: "Recalculate loyalty points",        status: "failed",  priority: "high"   },
  { title: "Archive Q1 transactions",           status: "pending", priority: "low"    },
]
jobs.each { |j| Job.find_or_create_by!(title: j[:title]) { |r| r.status = j[:status]; r.priority = j[:priority] } }
puts "✓ #{Job.count} jobs"

# ── Merchants (Product model repurposed) ─────────────────────────
merchants = [
  { name: "Jarir Bookstore",   description: "Olaya Street, Riyadh",       price: 85.00,  category: "Retail",        in_stock: true },
  { name: "Panda Supermarket", description: "Al Malqa, Riyadh",           price: 120.00, category: "Grocery",       in_stock: true },
  { name: "Starbucks",         description: "Kingdom Centre, Riyadh",     price: 32.00,  category: "F&B",           in_stock: true },
  { name: "STC Pay",           description: "Online",                     price: 200.00, category: "Services",      in_stock: true },
  { name: "IKEA",              description: "Dhahran Mall, Dammam",       price: 450.00, category: "Retail",        in_stock: true },
  { name: "Noon",              description: "Online Marketplace",         price: 175.00, category: "Electronics",   in_stock: true },
  { name: "Al Baik",           description: "Tahlia Street, Jeddah",      price: 45.00,  category: "F&B",           in_stock: true },
  { name: "Careem",            description: "Ride Service",               price: 65.00,  category: "Services",      in_stock: true },
  { name: "Extra Electronics", description: "Panorama Mall, Riyadh",      price: 350.00, category: "Electronics",   in_stock: true },
  { name: "Kudu",              description: "King Fahd Road, Riyadh",     price: 38.00,  category: "F&B",           in_stock: true },
  { name: "Tamimi Markets",    description: "Al Nakheel, Riyadh",         price: 95.00,  category: "Grocery",       in_stock: true },
  { name: "VOX Cinemas",       description: "Riyadh Park",                price: 55.00,  category: "Entertainment", in_stock: true },
]
Product.destroy_all
merchants.each { |m| Product.create!(m) }
puts "✓ #{Product.count} merchants"

# ── Consumers (Customer model) ────────────────────────────────────
consumers = [
  { name: "Majed Biazid",    email: "majed@autobia.com",  plan: "pro",        company: "+966 50 123 4567", joined_on: "2024-03-15" },
  { name: "Sara Al-Rashid",  email: "sara@example.com",   plan: "starter",    company: "+966 55 234 5678", joined_on: "2024-06-01" },
  { name: "Ahmed Hassan",    email: "ahmed@example.com",  plan: "enterprise", company: "+966 50 345 6789", joined_on: "2023-11-20" },
  { name: "Noura Al-Otaibi", email: "noura@example.com",  plan: "pro",        company: "+966 54 456 7890", joined_on: "2025-01-10" },
  { name: "Omar Farouk",     email: "omar@example.com",   plan: "free",       company: "+966 56 567 8901", joined_on: "2025-04-22" },
  { name: "Lina Khalil",     email: "lina@example.com",   plan: "starter",    company: "+966 50 678 9012", joined_on: "2024-09-05" },
]
Customer.destroy_all
consumers.each { |c| Customer.create!(c) }
puts "✓ #{Customer.count} consumers"

# ── Vouchers (Order model) ────────────────────────────────────────
# Consumer 1 (Majed) gets the most vouchers — he is the simulated auth user
today = Date.today
vouchers = [
  # Majed (consumer 1) — 10 vouchers across months
  { consumer: "Majed Biazid",    product_name: "Starbucks",         amount: 28.50,  status: "paid",     placed_on: today },
  { consumer: "Majed Biazid",    product_name: "Jarir Bookstore",   amount: 156.00, status: "paid",     placed_on: today },
  { consumer: "Majed Biazid",    product_name: "Panda Supermarket", amount: 89.75,  status: "paid",     placed_on: today - 1 },
  { consumer: "Majed Biazid",    product_name: "Noon",              amount: 249.00, status: "paid",     placed_on: today - 3 },
  { consumer: "Majed Biazid",    product_name: "Careem",            amount: 42.00,  status: "pending",  placed_on: today - 5 },
  { consumer: "Majed Biazid",    product_name: "Al Baik",           amount: 67.00,  status: "paid",     placed_on: today - 12 },
  { consumer: "Majed Biazid",    product_name: "IKEA",              amount: 1240.00, status: "paid",    placed_on: today - 35 },
  { consumer: "Majed Biazid",    product_name: "Extra Electronics", amount: 899.00, status: "paid",     placed_on: today - 45 },
  { consumer: "Majed Biazid",    product_name: "VOX Cinemas",       amount: 55.00,  status: "paid",     placed_on: today - 60 },
  { consumer: "Majed Biazid",    product_name: "STC Pay",           amount: 200.00, status: "refunded", placed_on: today - 90 },

  # Sara — 4 vouchers
  { consumer: "Sara Al-Rashid",  product_name: "Starbucks",         amount: 34.00,  status: "paid",     placed_on: today - 2 },
  { consumer: "Sara Al-Rashid",  product_name: "Tamimi Markets",    amount: 175.50, status: "paid",     placed_on: today - 8 },
  { consumer: "Sara Al-Rashid",  product_name: "Kudu",              amount: 52.00,  status: "paid",     placed_on: today - 20 },
  { consumer: "Sara Al-Rashid",  product_name: "Noon",              amount: 320.00, status: "pending",  placed_on: today - 1 },

  # Ahmed — 3 vouchers
  { consumer: "Ahmed Hassan",    product_name: "Extra Electronics", amount: 1599.00, status: "paid",    placed_on: today - 4 },
  { consumer: "Ahmed Hassan",    product_name: "Jarir Bookstore",   amount: 245.00, status: "paid",     placed_on: today - 15 },
  { consumer: "Ahmed Hassan",    product_name: "IKEA",              amount: 780.00, status: "paid",     placed_on: today - 40 },

  # Noura — 3 vouchers
  { consumer: "Noura Al-Otaibi", product_name: "Panda Supermarket", amount: 132.00, status: "paid",     placed_on: today - 1 },
  { consumer: "Noura Al-Otaibi", product_name: "Careem",            amount: 38.00,  status: "paid",     placed_on: today - 7 },
  { consumer: "Noura Al-Otaibi", product_name: "Al Baik",           amount: 45.00,  status: "paid",     placed_on: today - 25 },

  # Omar — 2 vouchers
  { consumer: "Omar Farouk",     product_name: "Kudu",              amount: 29.00,  status: "paid",     placed_on: today - 3 },
  { consumer: "Omar Farouk",     product_name: "VOX Cinemas",       amount: 85.00,  status: "pending",  placed_on: today },

  # Lina — 2 vouchers
  { consumer: "Lina Khalil",     product_name: "Starbucks",         amount: 22.50,  status: "paid",     placed_on: today - 6 },
  { consumer: "Lina Khalil",     product_name: "STC Pay",           amount: 150.00, status: "paid",     placed_on: today - 30 },
]

Order.destroy_all
vouchers.each do |v|
  customer = Customer.find_by!(name: v[:consumer])
  customer.orders.create!(v.except(:consumer))
end
puts "✓ #{Order.count} vouchers"
