'use client'

import clsx from 'clsx'
import { useEffect } from 'react'
import useSound from 'use-sound'
import { useIsPressed } from '../hooks/useIsPressed'
import { FancyButton } from './FancyButton'

function KeyboardButtonComponent({
  code,
  children,
  className,
  variant = 'regular',
  onTrigger,
}: {
  code: string
  children: React.ReactNode
  className?: string
  variant?: 'prominent' | 'regular'
  onTrigger?: () => void
}) {
  const pressed = useIsPressed({
    code,
  })

  const [playKeycapSound] = useSound(
    `${process.env.NEXT_PUBLIC_BASE_PATH ?? ''}/keycap-click.mp3`,
    {
      sprite: {
        keycapDown: [0, 100],
        keycapUp: [100, 300],
      },
    },
  )

  useEffect(() => {
    if (pressed) {
      playKeycapSound({ id: 'keycapDown' })
    } else {
      playKeycapSound({ id: 'keycapUp' })
      onTrigger?.()
    }
  }, [pressed])

  return (
    <FancyButton
      pressed={pressed}
      className={className}
      variant={variant}
      onMouseDown={() => playKeycapSound({ id: 'keycapDown' })}
      onMouseUp={() => {
        playKeycapSound({ id: 'keycapUp' })
        onTrigger?.()
      }}
    >
      {children}
    </FancyButton>
  )
}

export const LetterButton = ({
  code,
  children,
  className,
}: {
  code: string
  children: React.ReactNode
  className?: string
}) => {
  return (
    <KeyboardButtonComponent code={code} className={className}>
      <div className="flex h-full items-center justify-center text-[hsl(0_0%_50%)] dark:text-[hsl(0_0%_40%)]">
        {children}
      </div>
    </KeyboardButtonComponent>
  )
}

export const ModifierButton = ({
  code,
  variant,
  onTrigger,
}: {
  code: 'AltLeft' | 'AltRight' | 'MetaLeft' | 'MetaRight'
  variant?: 'prominent' | 'regular'
  onTrigger?: () => void
}) => {
  const isLeft = code.endsWith('Left')
  const symbol = code.startsWith('Alt') ? '⌥' : '⌘'

  return (
    <KeyboardButtonComponent
      code={code}
      variant={variant}
      onTrigger={onTrigger}
    >
      <div
        className={clsx(
          'flex h-full flex-col justify-between px-2',
          isLeft ? 'items-end' : 'items-start',
        )}
      >
        <div>{symbol}</div>
      </div>
    </KeyboardButtonComponent>
  )
}
