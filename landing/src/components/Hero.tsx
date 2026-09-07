import Link from 'next/link'
import { GitHubLogo } from './GitHubLogo'
import { Kbd } from './Kbd'

export default function Hero() {
  return (
    <div className="bg-white dark:bg-gray-900">
      <header className="absolute inset-x-0 top-0 z-50">
        <nav
          aria-label="Global"
          className="flex items-center justify-between p-6 lg:px-8"
        >
          <Link
            href="/"
            className="-m-1.5 p-1.5 font-medium text-gray-900 dark:text-white"
          >
            ⌘ Rapid Layout Switcher
          </Link>
          <Link
            href="https://github.com/Elcaten/rapid-layout-switcher"
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-1 text-sm/6 font-semibold text-gray-900 dark:text-white"
          >
            <GitHubLogo className="size-5" />
            GitHub
          </Link>
        </nav>
      </header>

      <div className="relative isolate px-6 pt-14 lg:px-8">
        <div
          aria-hidden="true"
          className="absolute inset-x-0 -top-40 -z-10 transform-gpu overflow-hidden blur-3xl sm:-top-80"
        >
          <div
            style={{
              clipPath:
                'polygon(74.1% 44.1%, 100% 61.6%, 97.5% 26.9%, 85.5% 0.1%, 80.7% 2%, 72.5% 32.5%, 60.2% 62.4%, 52.4% 68.1%, 47.5% 58.3%, 45.2% 34.5%, 27.5% 76.7%, 0.1% 64.9%, 17.9% 100%, 27.6% 76.8%, 76.1% 97.7%, 74.1% 44.1%)',
            }}
            className="relative left-[calc(50%-11rem)] aspect-1155/678 w-144.5 -translate-x-1/2 rotate-30 bg-linear-to-tr from-[#ff80b5] to-[#9089fc] opacity-30 sm:left-[calc(50%-30rem)] sm:w-288.75"
          />
        </div>
        <div className="mx-auto max-w-3xl py-32 sm:py-48">
          <div className="text-center">
            <h1 className="text-5xl font-semibold tracking-tight text-balance text-gray-900 sm:text-7xl dark:text-white">
              One key tap
              <br />
              <span className="bg-linear-to-r from-emerald-700 via-teal-700 to-sky-700 bg-clip-text text-transparent dark:from-emerald-400 dark:via-teal-400 dark:to-sky-400">
                Instant layout change
              </span>
            </h1>
            <p className="mt-4 text-sm text-pretty text-gray-900 sm:text-base dark:text-white">
              Say goodbye to awkward <Kbd variant="zinc">⌃ + Space</Kbd> or{' '}
              <Kbd variant="zinc">⌥ + Shift</Kbd> combinations.
              <br />
              Tap <Kbd variant="roze">Left ⌘</Kbd> for English, tap{' '}
              <Kbd variant="roze">Right ⌘</Kbd> for your secondary layout.
            </p>
            <div className="mt-10">
              <a
                href="https://github.com/Elcaten/rapid-layout-switcher/releases/latest/download/Rapid-Layout-Switcher.dmg"
                className="inline-flex items-center justify-center gap-2 rounded-full bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600 active:bg-blue-800"
              >
                <span aria-hidden="true"></span>
                Download for macOS
              </a>
            </div>
            <div className="mt-2 text-xs text-slate-400">
              Free · macOS 15.7+ · Apple silicon and Intel
            </div>
          </div>
        </div>
        <div
          aria-hidden="true"
          className="absolute inset-x-0 top-[calc(100%-13rem)] -z-10 transform-gpu overflow-hidden blur-3xl sm:top-[calc(100%-30rem)]"
        >
          <div
            style={{
              clipPath:
                'polygon(74.1% 44.1%, 100% 61.6%, 97.5% 26.9%, 85.5% 0.1%, 80.7% 2%, 72.5% 32.5%, 60.2% 62.4%, 52.4% 68.1%, 47.5% 58.3%, 45.2% 34.5%, 27.5% 76.7%, 0.1% 64.9%, 17.9% 100%, 27.6% 76.8%, 76.1% 97.7%, 74.1% 44.1%)',
            }}
            className="relative left-[calc(50%+3rem)] aspect-1155/678 w-144.5 -translate-x-1/2 bg-linear-to-tr from-[#ff80b5] to-[#9089fc] opacity-30 sm:left-[calc(50%+36rem)] sm:w-288.75"
          />
        </div>
      </div>
    </div>
  )
}
