import { useEffect, useRef, useState } from 'react'
import useSound from 'use-sound'

export function Trackpad() {
  const ref = useRef<HTMLDivElement>(null)
  const isPressed = useIsPressed({ ref })

  const [playTrackpadSound] = useSound(
    `${process.env.NEXT_PUBLIC_BASE_PATH ?? ''}/trackpad-click.mp3`,
  )

  const unpressedLight = 'from-[#c9cacb]'
  const pressedLight = 'from-[#bdbebf]'
  const fromLight = isPressed ? pressedLight : unpressedLight
  const unpressedDark = 'dark:from-[#1a1b1e]'
  const pressedDark = 'dark:from-[#10101b]'
  const fromDark = isPressed ? pressedDark : unpressedDark

  useEffect(() => {
    if (isPressed) {
      playTrackpadSound()
    }
  }, [isPressed, playTrackpadSound])

  return (
    <div
      ref={ref}
      className={`mx-auto mt-4 h-18 w-48 rounded-t-xl border-x border-t border-[#b5b7ba] bg-linear-to-b ${fromLight} ${fromDark} active:ease-in" to-transparent transition-colors duration-1400 ease-out active:duration-150 sm:w-64 dark:border-[#383a42]`}
    />
  )
}

const useIsPressed = ({
  ref,
}: {
  ref: React.RefObject<HTMLDivElement | null>
}) => {
  const [isPressed, setIsPressed] = useState(false)

  useEffect(() => {
    const mouseDownListener = (event: MouseEvent) => {
      if (isPressed || !ref?.current?.contains(event.target as Node)) {
        return
      }
      setIsPressed(true)
    }
    const mouseUpListener = (event: MouseEvent) => {
      if (!ref?.current?.contains(event.target as Node)) {
        return
      }
      setIsPressed(false)
    }

    window.addEventListener('mousedown', mouseDownListener)
    window.addEventListener('mouseup', mouseUpListener)

    return () => {
      window.removeEventListener('mousedown', mouseDownListener)
      window.removeEventListener('mouseup', mouseUpListener)
    }
  }, [isPressed])

  return isPressed
}
