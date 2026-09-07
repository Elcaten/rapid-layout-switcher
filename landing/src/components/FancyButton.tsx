import clsx from 'clsx'
import type { PropsWithChildren } from 'react'
import styles from './FancyButton.module.css'

type Variant = 'prominent' | 'regular'

const bgColors: Record<Variant, string> = {
  prominent: 'bg-rose-500 text-white dark:text-gray-900',
  regular: 'bg-[hsl(230_5%_16%)] text-[hsl(0_0%_88%)]',
}

const edgeColors: Record<Variant, string> = {
  prominent:
    'bg-[linear-gradient(to_left,hsl(340_100%_16%)_0%,hsl(340_100%_32%)_8%,hsl(340_100%_32%)_92%,hsl(340_100%_16%)_100%)]',
  regular:
    'bg-[linear-gradient(to_left,hsl(230_5%_5%)_0%,hsl(230_5%_11%)_8%,hsl(230_5%_11%)_92%,hsl(230_5%_5%)_100%)]',
}

const shadowColors: Record<Variant, string> = {
  prominent: 'bg-black/25 dark:bg-black/50',
  regular: 'bg-[hsl(230_5%_4%)]',
}

type FancyButtonProps = PropsWithChildren<{
  pressed?: boolean
  onMouseUp?: () => void
  onMouseDown?: () => void
  variant: Variant
  className?: string
}>

export function FancyButton({
  children,
  pressed,
  onMouseDown,
  onMouseUp,
  className,
  variant,
}: FancyButtonProps) {
  return (
    <button
      type="button"
      className={clsx(styles.pushable, pressed && styles.pressed, className)}
      onMouseDown={onMouseDown}
      onMouseUp={onMouseUp}
    >
      <span
        className={clsx(styles.shadow, shadowColors[variant], 'rounded-md')}
      />
      <span className={clsx(styles.edge, edgeColors[variant], 'rounded-md')} />
      <span className={clsx(styles.front, 'rounded-md', bgColors[variant])}>
        {children}
      </span>
    </button>
  )
}
