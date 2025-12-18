import type { Metadata } from 'next'
import './globals.css'
import Providers from './providers'


export const metadata: Metadata = {
  title: 'ベースを弾く。',
  description: 'Youtube動画一覧',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="ja">
      <body className="bg-black text-white">
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  )
}
