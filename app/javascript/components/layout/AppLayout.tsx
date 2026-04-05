import React, { useState } from "react"
import { Link } from "@inertiajs/react"
import { Home, Receipt, UserCircle, Zap, Menu, X } from "lucide-react"
import { motion, AnimatePresence } from "motion/react"
import { cn } from "@/lib/utils"

type Props = { children: React.ReactNode; currentPath?: string }

const navGroups = [
  {
    label: "Main",
    items: [
      { label: "Home",     href: "/external/home",     icon: Home },
      { label: "Vouchers", href: "/external/vouchers", icon: Receipt },
    ],
  },
  {
    label: "Account",
    items: [
      { label: "Profile", href: "/external/profile", icon: UserCircle },
    ],
  },
]

export default function AppLayout({ children, currentPath }: Props) {
  const [open, setOpen] = useState(false)

  const sidebar = (
    <>
      <div className="flex items-center gap-2.5 px-5 py-5 border-b" style={{ borderColor: "hsl(36,14%,85%)" }}>
        <div className="flex items-center justify-center rounded-lg shrink-0"
          style={{ width: 30, height: 30, background: "hsl(220,38%,26%)" }}>
          <Zap size={14} color="#fff" strokeWidth={2.5} />
        </div>
        <div>
          <p className="font-semibold leading-tight" style={{ fontSize: 13.5, color: "hsl(220,15%,12%)", letterSpacing: "-0.01em" }}>
            Autobia
          </p>
          <p style={{ fontSize: 10, color: "hsl(220,8%,55%)", marginTop: 1 }}>Consumer Portal</p>
        </div>
      </div>

      <nav className="flex-1 overflow-y-auto py-3 px-2.5">
        {navGroups.map(group => (
          <div key={group.label} className="mb-4">
            <p className="px-2.5 pb-1.5 font-semibold uppercase"
              style={{ fontSize: 9.5, letterSpacing: "0.07em", color: "hsl(220,8%,62%)" }}>
              {group.label}
            </p>
            {group.items.map(({ label, href, icon: Icon }) => {
              const active = currentPath?.startsWith(href)
              return (
                <Link
                  key={href}
                  href={href}
                  onClick={() => setOpen(false)}
                  className={cn(
                    "flex items-center gap-2.5 px-2.5 py-2 rounded-md mb-0.5 transition-colors",
                    active
                      ? "font-medium"
                      : "text-[hsl(220,8%,50%)] hover:bg-[hsl(36,14%,93%)] hover:text-[hsl(220,15%,20%)]"
                  )}
                  style={{
                    fontSize: 13,
                    color: active ? "hsl(220,38%,26%)" : undefined,
                    background: active ? "hsl(220,38%,26%,0.07)" : undefined,
                  }}
                >
                  <Icon size={14} strokeWidth={active ? 2.5 : 1.8} />
                  {label}
                </Link>
              )
            })}
          </div>
        ))}
      </nav>

      <div className="px-4 py-3 border-t" style={{ borderColor: "hsl(36,14%,85%)", fontSize: 10, color: "hsl(220,8%,62%)", lineHeight: 1.9 }}>
        React · Inertia · ShadCN<br />
        Tailwind · Rails 7
      </div>
    </>
  )

  return (
    <div className="flex h-screen overflow-hidden" style={{ background: "hsl(40,22%,96%)", fontFamily: "'DM Sans', system-ui, sans-serif" }}>
      <aside className="hidden md:flex flex-col border-r shrink-0" style={{ width: 220, background: "#fff", borderColor: "hsl(36,14%,85%)" }}>
        {sidebar}
      </aside>

      <AnimatePresence>
        {open && (
          <div className="fixed inset-0 z-40 md:hidden">
            <motion.div className="absolute inset-0 bg-black/30" initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} transition={{ duration: 0.2 }} onClick={() => setOpen(false)} />
            <motion.aside className="absolute left-0 top-0 bottom-0 flex flex-col z-50" style={{ width: 260, background: "#fff", boxShadow: "4px 0 24px rgba(0,0,0,0.12)" }}
              initial={{ x: -260 }} animate={{ x: 0 }} exit={{ x: -260 }} transition={{ type: "spring", damping: 28, stiffness: 300 }}>
              <button onClick={() => setOpen(false)} className="absolute top-4 right-4 p-1" style={{ color: "hsl(220,8%,50%)" }}><X size={18} /></button>
              {sidebar}
            </motion.aside>
          </div>
        )}
      </AnimatePresence>

      <main className="flex-1 overflow-y-auto" style={{ background: "hsl(40,22%,96%)" }}>
        <div className="flex md:hidden items-center gap-3 px-4 py-3 border-b" style={{ background: "#fff", borderColor: "hsl(36,14%,85%)" }}>
          <button onClick={() => setOpen(true)} style={{ color: "hsl(220,15%,12%)" }}><Menu size={20} /></button>
          <span className="font-semibold" style={{ fontSize: 14, color: "hsl(220,15%,12%)" }}>Autobia</span>
        </div>
        <motion.div key={currentPath} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.3, ease: "easeOut" }}>
          {children}
        </motion.div>
      </main>
    </div>
  )
}
