import { Link, usePage } from "@inertiajs/react"
import { ArrowRight, Receipt, Wallet } from "lucide-react"
import { motion } from "motion/react"
import AppLayout from "@/components/layout/AppLayout"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"

type Voucher = {
  id: number; merchant_name: string; amount: number; status: string
  order_id: string; placed_on: string; date_display: string; time_display: string
}

type Props = {
  consumer: { name: string; initials: string }
  recent_vouchers: Voucher[]
  summary: { total_spent: number; voucher_count: number }
}

const STATUS_VARIANT: Record<string, any> = { completed: "success", pending: "warning", refunded: "destructive" }
const cardStyle = { background: "#fff", borderColor: "hsl(36,14%,85%)", boxShadow: "0 1px 3px rgba(0,0,0,0.04)" }

export default function HomeIndex({ consumer, recent_vouchers, summary }: Props) {
  return (
    <AppLayout currentPath="/external/home">
      <div className="p-4 sm:p-7">
        {/* Greeting */}
        <motion.div className="mb-6" initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.35 }}>
          <h1 className="font-semibold" style={{ fontSize: 24, color: "hsl(220,15%,12%)", letterSpacing: "-0.02em", fontFamily: "'Fraunces', serif" }}>
            Welcome back, {consumer.name.split(" ")[0]}
          </h1>
          <p className="text-sm mt-1" style={{ color: "hsl(220,8%,48%)" }}>
            Here's your spending overview and recent vouchers.
          </p>
        </motion.div>

        {/* Summary cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-7">
          {[
            { label: "Total Spent", value: `SAR ${summary.total_spent.toFixed(2)}`, icon: Wallet, color: "hsl(220,38%,26%)" },
            { label: "Vouchers", value: summary.voucher_count, icon: Receipt, color: "#1a7a55" },
          ].map(({ label, value, icon: Icon, color }, i) => (
            <motion.div key={label} initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 + i * 0.08, duration: 0.35 }}>
              <Card style={cardStyle}>
                <CardContent className="flex items-center gap-4 p-5">
                  <div className="w-10 h-10 rounded-lg flex items-center justify-center shrink-0" style={{ background: `${color}12` }}>
                    <Icon size={18} style={{ color }} />
                  </div>
                  <div>
                    <p className="font-semibold" style={{ fontSize: 24, color: "hsl(220,15%,12%)", fontFamily: "'Fraunces', serif", letterSpacing: "-0.02em" }}>
                      {value}
                    </p>
                    <p className="text-xs" style={{ color: "hsl(220,8%,55%)" }}>{label}</p>
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>

        {/* Recent vouchers */}
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-semibold" style={{ fontSize: 16, color: "hsl(220,15%,12%)" }}>Recent Vouchers</h2>
          <Link href="/external/vouchers" className="flex items-center gap-1 text-xs font-medium" style={{ color: "hsl(220,38%,26%)", textDecoration: "none" }}>
            View all <ArrowRight size={12} />
          </Link>
        </div>

        <div className="space-y-3">
          {recent_vouchers.map((v, i) => (
            <motion.div key={v.id} initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.25 + i * 0.06, duration: 0.3 }}
              whileHover={{ y: -1, transition: { duration: 0.12 } }}>
              <Link href={`/external/vouchers/${v.id}`} style={{ textDecoration: "none" }}>
                <Card className="transition-shadow hover:shadow-md" style={cardStyle}>
                  <CardContent className="flex items-center justify-between p-4">
                    <div className="flex items-center gap-3 min-w-0">
                      <div className="w-10 h-10 rounded-full flex items-center justify-center font-semibold text-xs shrink-0"
                        style={{ background: "hsl(220,38%,26%,0.08)", color: "hsl(220,38%,32%)" }}>
                        {v.merchant_name[0]}
                      </div>
                      <div className="min-w-0">
                        <p className="text-sm font-medium truncate" style={{ color: "hsl(220,15%,12%)" }}>{v.merchant_name}</p>
                        <p className="text-xs mt-0.5" style={{ color: "hsl(220,8%,55%)" }}>{v.date_display}</p>
                      </div>
                    </div>
                    <div className="flex items-center gap-3 shrink-0 ml-3">
                      <span className="font-semibold text-sm" style={{ color: "hsl(220,15%,12%)", fontFamily: "'Fraunces', serif" }}>
                        SAR {v.amount.toFixed(2)}
                      </span>
                      <Badge variant={STATUS_VARIANT[v.status]} className="text-[10px] capitalize">{v.status}</Badge>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            </motion.div>
          ))}
        </div>

        {recent_vouchers.length === 0 && (
          <Card style={cardStyle}>
            <CardContent className="py-16 text-center">
              <Receipt className="h-10 w-10 mx-auto mb-3" style={{ color: "hsl(220,8%,75%)" }} />
              <p className="font-medium text-sm" style={{ color: "hsl(220,12%,35%)" }}>No vouchers yet</p>
              <p className="text-xs mt-1" style={{ color: "hsl(220,8%,55%)" }}>Your vouchers will appear here once you make purchases.</p>
            </CardContent>
          </Card>
        )}
      </div>
    </AppLayout>
  )
}
