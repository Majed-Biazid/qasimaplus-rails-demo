import { useState } from "react"
import { usePage } from "@inertiajs/react"
import { Check, Mail, Phone, Calendar, Shield } from "lucide-react"
import { motion } from "motion/react"
import AppLayout from "@/components/layout/AppLayout"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"

type Consumer = {
  id: number; name: string; email: string; phone: string; initials: string
  plan: string; joined_on: string; member_since: string
  total_spent: number; voucher_count: number
}

const PLAN_VARIANT: Record<string, any> = { free: "secondary", starter: "default", pro: "success", enterprise: "warning" }
const cardStyle = { background: "#fff", borderColor: "hsl(36,14%,85%)", boxShadow: "0 1px 3px rgba(0,0,0,0.04)" }

export default function ProfileIndex({ consumer }: { consumer: Consumer }) {
  const [editing, setEditing] = useState(false)
  const [saved, setSaved] = useState(false)
  const [form, setForm] = useState({ name: consumer.name, email: consumer.email })

  function handleSave() {
    setEditing(false)
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  return (
    <AppLayout currentPath="/external/profile">
      <div className="p-4 sm:p-7 max-w-lg mx-auto">
        <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.35 }}>
          {/* Avatar + name */}
          <div className="text-center mb-6">
            <div className="w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-3"
              style={{ background: "hsl(220,38%,26%)", color: "#fff", fontSize: 24, fontWeight: 600, fontFamily: "'Fraunces', serif" }}>
              {consumer.initials}
            </div>
            <h1 className="font-semibold" style={{ fontSize: 22, color: "hsl(220,15%,12%)", fontFamily: "'Fraunces', serif", letterSpacing: "-0.02em" }}>
              {consumer.name}
            </h1>
            <div className="flex items-center justify-center gap-2 mt-1">
              <Badge variant={PLAN_VARIANT[consumer.plan]} className="text-[10px] capitalize">{consumer.plan}</Badge>
            </div>
          </div>

          {/* Stats row */}
          <div className="grid grid-cols-2 gap-3 mb-6">
            <Card style={cardStyle}>
              <CardContent className="p-4 text-center">
                <p className="font-semibold" style={{ fontSize: 20, color: "hsl(220,15%,12%)", fontFamily: "'Fraunces', serif" }}>{consumer.voucher_count}</p>
                <p className="text-xs mt-0.5" style={{ color: "hsl(220,8%,55%)" }}>Vouchers</p>
              </CardContent>
            </Card>
            <Card style={cardStyle}>
              <CardContent className="p-4 text-center">
                <p className="font-semibold" style={{ fontSize: 20, color: "hsl(220,15%,12%)", fontFamily: "'Fraunces', serif" }}>SAR {consumer.total_spent.toFixed(0)}</p>
                <p className="text-xs mt-0.5" style={{ color: "hsl(220,8%,55%)" }}>Total Spent</p>
              </CardContent>
            </Card>
          </div>
        </motion.div>

        {/* Profile info */}
        <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15, duration: 0.35 }}>
          <Card style={cardStyle}>
            <CardHeader className="flex flex-row items-center justify-between pb-3">
              <CardTitle className="text-sm">Profile Information</CardTitle>
              {!editing && (
                <Button variant="outline" size="sm" className="text-xs" onClick={() => setEditing(true)}>Edit</Button>
              )}
            </CardHeader>
            <CardContent>
              {editing ? (
                <div className="space-y-4">
                  <div>
                    <label className="text-xs font-medium block mb-1.5" style={{ color: "hsl(220,8%,45%)" }}>Full Name</label>
                    <Input value={form.name} onChange={e => setForm({ ...form, name: e.target.value })} />
                  </div>
                  <div>
                    <label className="text-xs font-medium block mb-1.5" style={{ color: "hsl(220,8%,45%)" }}>Email</label>
                    <Input type="email" value={form.email} onChange={e => setForm({ ...form, email: e.target.value })} />
                  </div>
                  <div className="flex gap-2 pt-1">
                    <Button onClick={handleSave} className="gap-1.5 text-xs flex-1">
                      {saved ? <><Check className="h-3 w-3" /> Saved</> : "Save Changes"}
                    </Button>
                    <Button variant="outline" onClick={() => setEditing(false)} className="text-xs">Cancel</Button>
                  </div>
                </div>
              ) : (
                <div className="space-y-4">
                  {[
                    { icon: Mail,     label: "Email",        value: consumer.email },
                    { icon: Phone,    label: "Phone",        value: consumer.phone || "Not set" },
                    { icon: Calendar, label: "Member Since",  value: consumer.member_since },
                    { icon: Shield,   label: "Plan",         value: consumer.plan.charAt(0).toUpperCase() + consumer.plan.slice(1) },
                  ].map(({ icon: Icon, label, value }) => (
                    <div key={label} className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-lg flex items-center justify-center shrink-0" style={{ background: "hsl(36,14%,93%)" }}>
                        <Icon size={14} style={{ color: "hsl(220,38%,36%)" }} />
                      </div>
                      <div>
                        <p className="text-[10px] font-medium uppercase tracking-wider" style={{ color: "hsl(220,8%,55%)", letterSpacing: "0.06em" }}>{label}</p>
                        <p className="text-sm font-medium" style={{ color: "hsl(220,15%,12%)" }}>{value}</p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        </motion.div>
      </div>
    </AppLayout>
  )
}
