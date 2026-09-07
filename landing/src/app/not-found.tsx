import Link from 'next/link'

export default function NotFound() {
  return (
    <main className="flex min-h-full flex-col items-center justify-center bg-white px-6 text-center dark:bg-gray-900">
      <p className="text-sm font-semibold text-blue-600 dark:text-blue-400">
        404
      </p>
      <h1 className="mt-3 text-3xl font-semibold tracking-tight text-gray-900 dark:text-white">
        Page not found
      </h1>
      <p className="mt-4 text-sm text-gray-600 dark:text-gray-400">
        Sorry, we couldn’t find the page you’re looking for.
      </p>
      <Link
        href="/"
        className="mt-8 rounded-full bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600"
      >
        Go back home
      </Link>
    </main>
  )
}
