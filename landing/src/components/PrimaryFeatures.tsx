'use client'
import { useState } from 'react'
import DisplayModel from './DisplayModel'
import { Kbd } from './Kbd'
import { KeyboardModel } from './KeyboardModel'

export default function PrimaryFeatures() {
  const [langCode, setLangCode] = useState<'EN' | 'RU'>('EN')

  return (
    <div className="bg-white pb-24 sm:pb-32 dark:bg-gray-900">
      <div className="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8">
        <div className="flex flex-col items-center gap-4">
          <h2 className="text-center text-2xl font-semibold tracking-tight text-balance text-gray-900 sm:text-4xl dark:text-white">
            Interactive Live Demo
          </h2>
          <p className="text-gray-900 dark:text-white">
            Click the Command keys below or press{' '}
            <Kbd variant="roze">Left ⌘</Kbd> / <Kbd variant="roze">Right ⌘</Kbd>{' '}
            on your physical Mac keyboard!
          </p>
        </div>

        <div className="mt-10 grid grid-cols-1 gap-4 sm:mt-16 lg:grid-cols-6 lg:grid-rows-1">
          <div className="relative flex justify-end lg:col-span-3">
            <div className="overflow-hidden rounded-xl bg-white shadow-md dark:bg-gray-800/50 dark:shadow-none dark:outline dark:-outline-offset-1 dark:outline-white/10">
              <KeyboardModel onLangChange={setLangCode} />
            </div>
          </div>
          <div className="relative flex lg:col-span-3">
            <div className="overflow-hidden rounded-xl rounded-tr-4xl bg-white shadow-md dark:bg-gray-800/50 dark:shadow-none dark:outline dark:-outline-offset-1 dark:outline-white/10">
              <DisplayModel langCode={langCode} />
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
