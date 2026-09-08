import { Kbd } from './Kbd'

const faqs = [
  {
    id: 1,
    question: 'Why does macOS show a security warning?',
    answer: (
      <>
        Rapid Layout Switcher is built with a free Apple developer account and
        cannot be notarized, so macOS displays a security warning the first time
        you open it. Follow the{' '}
        <a
          href="https://github.com/Elcaten/rapid-layout-switcher/blob/main/README.md#first-launch-on-macos"
          target="_blank"
          rel="noreferrer"
          className="font-medium text-rose-600 underline decoration-rose-600/30 underline-offset-4 hover:text-rose-700 dark:text-rose-400 dark:decoration-rose-400/30 dark:hover:text-rose-300"
        >
          first-launch instructions
        </a>{' '}
        to open the app safely.
      </>
    ),
  },
  {
    id: 2,
    question: 'Can I customize the shortcuts?',
    answer: (
      <>
        Yes. In Settings, choose <Kbd variant="roze">Left ⌘</Kbd> /{' '}
        <Kbd variant="roze">Right ⌘</Kbd>, <Kbd variant="roze">Left ⌥</Kbd> /{' '}
        <Kbd variant="roze">Right ⌥</Kbd>, or <Kbd variant="roze">Left ⌃</Kbd> /{' '}
        <Kbd variant="roze">Right ⌃</Kbd>. Standard multi-key shortcuts such as{' '}
        <Kbd variant="roze">⌘ + C</Kbd> and <Kbd variant="roze">⌘ + V</Kbd>{' '}
        continue to work normally.
      </>
    ),
  },
  {
    id: 3,
    question: 'Is Rapid Layout Switcher private and secure?',
    answer: (
      <>
        Yes. It is a lightweight Universal Binary under 4 MB that runs 100%
        offline, with no network requests or analytics tracking. It does not
        require Accessibility permission; the only permission it needs is Input
        Monitoring, which is necessary to detect standalone modifier-key taps.
      </>
    ),
  },
]

export default function FAQ() {
  return (
    <div className="bg-white dark:bg-gray-900">
      <div className="mx-auto max-w-7xl px-6 py-16 sm:py-24 lg:px-8">
        <h2 className="text-center text-2xl font-semibold tracking-tight text-gray-900 sm:text-4xl dark:text-white">
          Frequently asked questions
        </h2>

        <div className="mt-20">
          <dl className="space-y-16 sm:grid sm:grid-cols-2 sm:space-y-0 sm:gap-x-6 sm:gap-y-16 lg:grid-cols-3 lg:gap-x-10">
            {faqs.map((faq) => (
              <div key={faq.id}>
                <dt className="text-base/7 font-semibold text-gray-900 dark:text-white">
                  {faq.question}
                </dt>
                <dd className="mt-2 text-base/7 text-gray-600 dark:text-gray-400">
                  {faq.answer}
                </dd>
              </div>
            ))}
          </dl>
        </div>
      </div>
    </div>
  )
}
