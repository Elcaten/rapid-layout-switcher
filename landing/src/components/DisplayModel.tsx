import clsx from 'clsx'

export default function DisplayModel({
  className,
  langCode,
}: {
  className?: string
  langCode: string
}) {
  return (
    <div
      aria-hidden="true"
      className={clsx(
        'h-full w-112 overflow-hidden rounded-tr-4xl bg-[#d4d5d6] pt-10 pr-10 dark:bg-black',
        className,
      )}
    >
      <div className="h-full overflow-hidden rounded-tr-xl bg-linear-to-br from-sky-300 via-violet-400 to-rose-300 dark:from-indigo-950 dark:via-violet-900 dark:to-rose-950">
        <div className="flex h-10 items-center justify-end gap-4 bg-white/75 px-6 text-slate-900 dark:bg-[#202126] dark:text-slate-100">
          <span className="inline-flex items-center gap-x-1.5 rounded-md border bg-slate-900 px-1.5 py-0.5 text-sm/5 font-bold text-white dark:bg-slate-200 dark:text-black forced-colors:outline">
            {langCode}
          </span>
          <svg
            viewBox="0 0 28 14"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            className="h-4 w-8"
          >
            <rect x="1" y="1" width="23" height="12" rx="2" />
            <path d="M26 5v4M4 4h10v6H4z" fill="currentColor" stroke="none" />
          </svg>
          <span className="text-sm font-medium">{today}</span>
        </div>
      </div>
    </div>
  )
}

const formatter = new Intl.DateTimeFormat(undefined, {
  weekday: 'short',
  month: 'short',
  day: 'numeric',
})
const today = formatter.format(new Date())
