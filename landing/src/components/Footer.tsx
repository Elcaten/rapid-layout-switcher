import { GitHubLogo } from './GitHubLogo'

export default function Footer() {
  return (
    <footer className="bg-white dark:bg-gray-900">
      <div className="mx-auto max-w-7xl px-6 py-12 md:flex md:items-center md:justify-between lg:px-8">
        <div className="flex justify-center md:order-2">
          <a
            href="https://github.com/Elcaten/rapid-layout-switcher"
            target="_blank"
            rel="noreferrer"
            className="text-gray-600 hover:text-gray-800 dark:text-gray-400 dark:hover:text-white"
          >
            <span className="sr-only">GitHub</span>
            <GitHubLogo className="size-6" />
          </a>
        </div>
        <p className="mt-8 text-center text-sm/6 text-gray-600 md:order-1 md:mt-0 dark:text-gray-400">
          &copy; {new Date().getFullYear()} Andrei Lineishchikov. All Rights
          Reserved.
        </p>
      </div>
    </footer>
  )
}
