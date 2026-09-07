import clsx from 'clsx'
import type { PropsWithChildren } from 'react'

type Variant = 'zinc' | 'roze'

const variantStyles: Record<Variant, string> = {
  zinc: 'border-zinc-300 bg-zinc-200 text-zinc-800 dark:border-zinc-700 dark:bg-zinc-800 dark:text-zinc-200',
  roze: 'border-rose-300/40 bg-rose-300/60 text-rose-700 dark:border-rose-700/50 dark:bg-rose-900/50 dark:text-rose-200',
}

type KbdProps = PropsWithChildren<{
  variant: Variant
}>

export function Kbd({ children, variant }: KbdProps) {
  return (
    <kbd
      className={clsx(
        'kbd-chip rounded border px-1.5 py-0.5 font-mono text-xs whitespace-nowrap',
        variantStyles[variant],
      )}
    >
      {children}
    </kbd>
  )
}
