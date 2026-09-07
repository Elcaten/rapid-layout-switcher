import clsx from 'clsx'
import { LetterButton, ModifierButton } from './KeyboardButton'

export function KeyboardModel({
  className,
  onLangChange,
}: {
  className?: string
  onLangChange: (lang: 'EN' | 'RU') => void
}) {
  return (
    <div
      className={clsx(
        'rounded-xl bg-[#d4d5d6] p-4 pt-5 dark:bg-[#202126]',
        className,
      )}
    >
      <div className="template grid grid-cols-[repeat(7,55px)] grid-rows-[repeat(3,51px)] gap-x-2 gap-y-3">
        <>
          <LetterButton code="KeyA"> </LetterButton>
          <LetterButton code="KeyS"> </LetterButton>
          <LetterButton code="KeyD"> </LetterButton>
          <LetterButton code="KeyH"> </LetterButton>
          <LetterButton code="KeyJ"> </LetterButton>
          <LetterButton code="KeyK"> </LetterButton>
          <LetterButton code="KeyL"> </LetterButton>
        </>
        <>
          <LetterButton code="KeyZ"> </LetterButton>
          <LetterButton code="KeyX"> </LetterButton>
          <LetterButton code="KeyC"> </LetterButton>
          <LetterButton code="KeyN"> </LetterButton>
          <LetterButton code="KeyM"> </LetterButton>
          <LetterButton code="Comma"> </LetterButton>
          <LetterButton code="Period"> </LetterButton>
        </>
        <>
          <ModifierButton
            code="AltLeft"
            variant="prominent"
            onTrigger={() => onLangChange('EN')}
          />
          <ModifierButton
            code="MetaLeft"
            variant="prominent"
            onTrigger={() => onLangChange('EN')}
          />
          <LetterButton code="Space" aria-label="Space" className="col-span-3">
            {' '}
            &nbsp;
          </LetterButton>
          <ModifierButton
            code="MetaRight"
            variant="prominent"
            onTrigger={() => onLangChange('RU')}
          />
          <ModifierButton
            code="AltRight"
            variant="prominent"
            onTrigger={() => onLangChange('RU')}
          />
        </>
      </div>
      <div className="mx-auto mt-4 h-18 w-48 rounded-t-xl border-x border-t border-[#b5b7ba] bg-linear-to-b from-[#d5d6d7] to-transparent sm:w-64 dark:border-[#383a42] dark:from-[#1a1b1e]" />
    </div>
  )
}
