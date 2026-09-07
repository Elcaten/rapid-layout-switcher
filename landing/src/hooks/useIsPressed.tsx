import { useEffect, useState } from 'react'

export const useIsPressed = ({ code }: { code: string }) => {
  const [isPressed, setIsPressed] = useState(false)

  useEffect(() => {
    const keyDownListener = (event: KeyboardEvent) => {
      if (isPressed || event.code !== code) {
        return
      }
      setIsPressed(true)
    }
    const keyUpListener = (event: KeyboardEvent) => {
      if (event.code !== code) {
        return
      }
      setIsPressed(false)
    }

    window.addEventListener('keydown', keyDownListener)
    window.addEventListener('keyup', keyUpListener)

    return () => {
      window.removeEventListener('keydown', keyDownListener)
      window.removeEventListener('keyup', keyUpListener)
    }
  }, [isPressed, code])

  return isPressed
}
