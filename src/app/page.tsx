import { auth } from '@/auth'
import DevButton from '@/components/dev-components/dev-button'
import { redirect } from 'next/navigation'
import React from 'react'
import { FaGithub } from 'react-icons/fa'
import { FaArrowRightLong } from 'react-icons/fa6'

const page = async() => {
  const session=await auth()
  if(session) redirect("/app")
  return (
    <section className='md:bg-[url("/assets/gemini-banner.png")] bg-[url("/assets/gemini-phone-banner.png")] bg-cover bg-no-repeat bg-center h-full w-full'>
      <DevButton target='_blank' href='https://github.com/devyanshyadav/dev-gemini-clone' variant='v3' size='lg' asIcon rounded='full' className="text-4xl fixed top-4 right-4 text-white">
        <FaGithub />
      </DevButton>
      <DevButton href='/app' size='lg' rounded='full' className="px-10 !text-white group text-xl !bg-accentBlue/70 fixed gap-3 -translate-x-1/2  left-1/2 bottom-10">
        Try Now<FaArrowRightLong className='group-hover:translate-x-3 transition-all' />
      </DevButton>
    </section>
  )
}

export default page