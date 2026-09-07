import FAQ from '@/components/FAQ'
import Footer from '@/components/Footer'
import Hero from '@/components/Hero'
import PrimaryFeatures from '@/components/PrimaryFeatures'

export default function Home() {
  return (
    <>
      <main>
        <Hero />
        <PrimaryFeatures />
        <FAQ />
      </main>
      <Footer />
    </>
  )
}
