import { useState } from "react"
import { Link, usePage } from "@inertiajs/react"
import { ArrowLeft, Copy, Check } from "lucide-react"
import { motion } from "motion/react"
import AppLayout from "@/components/layout/AppLayout"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"

type Voucher = {
  id: number; merchant_name: string; amount: number; status: string
  order_id: string; placed_on: string; date_display: string; time_display: string
  location: string; merchant_type: string; payment_method: string
  consumer_name: string; consumer_email: string
  tax_amount: number; pre_tax_amount: number
}

const STATUS_VARIANT: Record<string, any> = { completed: "success", pending: "warning", refunded: "destructive" }
const cardStyle = { background: "#fff", borderColor: "hsl(36,14%,85%)", boxShadow: "0 1px 3px rgba(0,0,0,0.04)" }

function Row({ label, value, mono }: { label: string; value: string; mono?: boolean }) {
  return (
    <div className="flex items-center justify-between py-3 border-b last:border-0" style={{ borderColor: "hsl(36,14%,92%)" }}>
      <span className="text-xs font-medium" style={{ color: "hsl(220,8%,50%)" }}>{label}</span>
      <span className={`text-sm font-medium ${mono ? "font-mono" : ""}`} style={{ color: "hsl(220,15%,12%)" }}>{value}</span>
    </div>
  )
}

export default function VouchersShow({ voucher }: { voucher: Voucher }) {
  const [copied, setCopied] = useState(false)

  function copyOrderId() {
    navigator.clipboard.writeText(voucher.order_id).then(() => {
      setCopied(true)
      setTimeout(() => setCopied(false), 2000)
    })
  }

  return (
    <AppLayout currentPath="/external/vouchers">
      <div className="p-4 sm:p-7 max-w-lg mx-auto">
        <Link href="/external/vouchers">
          <Button variant="ghost" size="sm" className="gap-1.5 mb-5 -ml-2" style={{ color: "hsl(220,8%,50%)" }}>
            <ArrowLeft className="h-3.5 w-3.5" /> Back to Vouchers
          </Button>
        </Link>

        <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.4 }}>
          <Card style={cardStyle}>
            <CardContent className="p-0">
              {/* Amount hero */}
              <div className="text-center py-8 border-b" style={{ borderColor: "hsl(36,14%,90%)" }}>
                <motion.p
                  className="font-semibold"
                  style={{ fontSize: 36, color: "hsl(220,15%,12%)", fontFamily: "'Fraunces', serif", letterSpacing: "-0.02em" }}
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: 0.15, duration: 0.35 }}
                >
                  SAR {voucher.amount.toFixed(2)}
                </motion.p>
                <div className="mt-2">
                  <Badge variant={STATUS_VARIANT[voucher.status]} className="text-xs capitalize px-3 py-1">
                    {voucher.status}
                  </Badge>
                </div>
              </div>

              {/* Receipt details */}
              <div className="px-5 sm:px-6">
                <Row label="Merchant" value={voucher.merchant_name} />
                <Row label="Location" value={voucher.location} />

                {/* Order ID with copy */}
                <div className="flex items-center justify-between py-3 border-b" style={{ borderColor: "hsl(36,14%,92%)" }}>
                  <span className="text-xs font-medium" style={{ color: "hsl(220,8%,50%)" }}>Order ID</span>
                  <button onClick={copyOrderId} className="flex items-center gap-1.5 text-sm font-medium font-mono transition-colors"
                    style={{ color: "hsl(220,38%,26%)", background: "none", border: "none", cursor: "pointer" }}>
                    {voucher.order_id}
                    {copied ? <Check size={12} className="text-green-600" /> : <Copy size={12} />}
                  </button>
                </div>

                <Row label="Date" value={voucher.date_display} />
                <Row label="Time" value={voucher.time_display} />
                <Row label="Payment" value={voucher.payment_method} />
                <Row label="Consumer" value={voucher.consumer_name} />
              </div>

              {/* Amount breakdown */}
              <div className="px-5 sm:px-6 pt-2 pb-5 border-t mt-1" style={{ borderColor: "hsl(36,14%,88%)" }}>
                <p className="text-xs font-semibold uppercase tracking-wider mb-2 mt-3" style={{ color: "hsl(220,8%,55%)", letterSpacing: "0.06em" }}>
                  Breakdown
                </p>
                <div className="flex items-center justify-between py-1.5">
                  <span className="text-xs" style={{ color: "hsl(220,8%,50%)" }}>Subtotal</span>
                  <span className="text-sm font-mono" style={{ color: "hsl(220,15%,20%)" }}>SAR {voucher.pre_tax_amount.toFixed(2)}</span>
                </div>
                <div className="flex items-center justify-between py-1.5">
                  <span className="text-xs" style={{ color: "hsl(220,8%,50%)" }}>VAT (15%)</span>
                  <span className="text-sm font-mono" style={{ color: "hsl(220,15%,20%)" }}>SAR {voucher.tax_amount.toFixed(2)}</span>
                </div>
                <div className="flex items-center justify-between py-2 border-t mt-1" style={{ borderColor: "hsl(36,14%,90%)" }}>
                  <span className="text-sm font-semibold" style={{ color: "hsl(220,15%,12%)" }}>Total</span>
                  <span className="font-semibold" style={{ fontSize: 16, color: "hsl(220,15%,12%)", fontFamily: "'Fraunces', serif" }}>
                    SAR {voucher.amount.toFixed(2)}
                  </span>
                </div>
              </div>
            </CardContent>
          </Card>
        </motion.div>
      </div>
    </AppLayout>
  )
}
