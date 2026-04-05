import { useMemo, useState } from "react"
import { Link } from "@inertiajs/react"
import { Receipt } from "lucide-react"
import { motion } from "motion/react"
import AppLayout from "@/components/layout/AppLayout"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs"

type Voucher = {
  id: number; merchant_name: string; amount: number; status: string
  order_id: string; placed_on: string; date_display: string; time_display: string
}

const STATUS_VARIANT: Record<string, any> = { completed: "success", pending: "warning", refunded: "destructive" }
const cardStyle = { background: "#fff", borderColor: "hsl(36,14%,85%)", boxShadow: "0 1px 3px rgba(0,0,0,0.04)" }

const MONTH_NAMES = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

function relativeDate(iso: string): string {
  const d = new Date(iso)
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  const target = new Date(d)
  target.setHours(0, 0, 0, 0)
  const diff = Math.round((today.getTime() - target.getTime()) / 86400000)
  if (diff === 0) return "Today"
  if (diff === 1) return "Yesterday"
  return `${MONTH_NAMES[d.getMonth()]} ${d.getDate()}`
}

function monthKey(iso: string): string {
  const d = new Date(iso)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}`
}

function monthLabel(key: string): string {
  const [y, m] = key.split("-")
  const names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  return `${names[parseInt(m) - 1]} ${y}`
}

export default function VouchersIndex({ vouchers }: { vouchers: Voucher[]; consumer_name: string }) {
  const months = useMemo(() => {
    const keys = [...new Set(vouchers.map(v => monthKey(v.placed_on)))]
    return keys.sort().reverse()
  }, [vouchers])

  const [activeMonth, setActiveMonth] = useState(months[0] || "")

  const grouped = useMemo(() => {
    const filtered = vouchers.filter(v => monthKey(v.placed_on) === activeMonth)
    const groups: { label: string; vouchers: Voucher[] }[] = []
    for (const v of filtered) {
      const label = relativeDate(v.placed_on)
      const existing = groups.find(g => g.label === label)
      if (existing) existing.vouchers.push(v)
      else groups.push({ label, vouchers: [v] })
    }
    return groups
  }, [vouchers, activeMonth])

  const monthTotal = useMemo(() =>
    vouchers.filter(v => monthKey(v.placed_on) === activeMonth).reduce((s, v) => s + v.amount, 0),
    [vouchers, activeMonth]
  )

  return (
    <AppLayout currentPath="/external/vouchers">
      <div className="p-4 sm:p-7">
        <div className="mb-5">
          <h1 className="font-semibold" style={{ fontSize: 22, color: "hsl(220,15%,12%)", letterSpacing: "-0.02em", fontFamily: "'Fraunces', serif" }}>
            Voucher History
          </h1>
          <p className="text-sm mt-1" style={{ color: "hsl(220,8%,48%)" }}>
            Browse your transactions by month.
          </p>
        </div>

        {months.length === 0 ? (
          <Card style={cardStyle}>
            <CardContent className="py-16 text-center">
              <Receipt className="h-10 w-10 mx-auto mb-3" style={{ color: "hsl(220,8%,75%)" }} />
              <p className="font-medium text-sm" style={{ color: "hsl(220,12%,35%)" }}>No vouchers yet</p>
            </CardContent>
          </Card>
        ) : (
          <>
            {/* Month summary */}
            <motion.div className="mb-5 p-4 rounded-xl border" style={{ background: "hsl(220,38%,26%,0.04)", borderColor: "hsl(220,38%,26%,0.12)" }}
              initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.3 }}>
              <p className="text-xs" style={{ color: "hsl(220,8%,50%)" }}>{monthLabel(activeMonth)} total</p>
              <p className="font-semibold mt-0.5" style={{ fontSize: 22, fontFamily: "'Fraunces', serif", color: "hsl(220,15%,12%)", letterSpacing: "-0.02em" }}>
                SAR {monthTotal.toFixed(2)}
              </p>
            </motion.div>

            {/* Month tabs */}
            <div className="flex gap-2 flex-wrap mb-5 overflow-x-auto pb-1">
              {months.map(m => (
                <button
                  key={m}
                  onClick={() => setActiveMonth(m)}
                  className="px-3 py-1.5 rounded-full text-xs font-medium transition-colors shrink-0"
                  style={{
                    background: m === activeMonth ? "hsl(220,38%,26%)" : "#fff",
                    color: m === activeMonth ? "#fff" : "hsl(220,8%,45%)",
                    border: `1px solid ${m === activeMonth ? "hsl(220,38%,26%)" : "hsl(36,14%,85%)"}`,
                  }}
                >
                  {monthLabel(m)}
                </button>
              ))}
            </div>

            {/* Grouped vouchers */}
            {grouped.map((group, gi) => (
              <div key={group.label} className="mb-5">
                <p className="text-xs font-semibold uppercase tracking-wider mb-2 px-1"
                  style={{ color: "hsl(220,8%,55%)", letterSpacing: "0.06em" }}>
                  {group.label}
                </p>
                <div className="space-y-2">
                  {group.vouchers.map((v, vi) => (
                    <motion.div key={v.id}
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: gi * 0.08 + vi * 0.04, duration: 0.3 }}
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
                                <p className="text-xs mt-0.5" style={{ color: "hsl(220,8%,55%)" }}>{v.order_id}</p>
                              </div>
                            </div>
                            <div className="flex items-center gap-3 shrink-0 ml-3">
                              <span className="font-semibold text-sm" style={{ color: "hsl(220,15%,12%)", fontFamily: "'Fraunces', serif" }}>
                                SAR {v.amount.toFixed(2)}
                              </span>
                              <Badge variant={STATUS_VARIANT[v.status]} className="text-[10px] capitalize hidden sm:inline-flex">{v.status}</Badge>
                            </div>
                          </CardContent>
                        </Card>
                      </Link>
                    </motion.div>
                  ))}
                </div>
              </div>
            ))}

            {grouped.length === 0 && (
              <Card style={cardStyle}>
                <CardContent className="py-12 text-center">
                  <p className="text-sm" style={{ color: "hsl(220,8%,55%)" }}>No vouchers in {monthLabel(activeMonth)}</p>
                </CardContent>
              </Card>
            )}
          </>
        )}
      </div>
    </AppLayout>
  )
}
