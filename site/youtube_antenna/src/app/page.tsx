
"use client"

import './globals.css'
import { useEffect, useState } from 'react'
import getYoutube from './getYoutube'
import Image from 'next/image'
import Pagination from '@mui/material/Pagination'
import Stack from '@mui/material/Stack'
import Box from '@mui/material/Box'
import InputLabel from '@mui/material/InputLabel'
import MenuItem from '@mui/material/MenuItem'
import FormControl from '@mui/material/FormControl'
import Select, { SelectChangeEvent } from '@mui/material/Select'
import Loading from './loading'


interface items {
  id: string
  snippet: {
    title: string
    publishedAt: string
    description: string
    thumbnails: {
      high: {
        url: string
      }
    }
  }
  statistics: {
    viewCount: string
    likeCount: string
    commentCount: string 
  }
}


const dateDesc = 'dateDesc'
const dateAsc = 'dateAsc'
const viewDesc = 'viewDesc'
const viewAsc = 'viewAsc'
const likeDesc = 'likeDesc'
const likeAsc = 'likeAsc'
const commentDesc = 'commentDesc'
const commentAsc = 'commentAsc'


export default function Youtube() {

//1ページあたりの動画数
  const pageRecord = 8


//JSONファイルの取得
  const [videoData, setVideoData] = useState<items[]>([])

  const [loading, setLoading] = useState(true)

  useEffect(() =>{
    (async() => {
      try{
        const fetchData = await getYoutube()
        setVideoData(fetchData)
        setPageData(fetchData.slice(0, pageRecord))
        console.log(fetchData)
        setLoading(false)
      } catch (error) {
        console.error("Error Fetching Data:", error)
      }
    })()
  }, [])


//ソート
  const [sort, setSort] = useState('')

  const sortHandleChange = (event: SelectChangeEvent) => {
    setSort(event.target.value as string)

    switch (event.target.value) {

      case dateDesc:
        videoData.sort(
          (a, b) => (new Date(b.snippet.publishedAt) as any) - (new Date(a.snippet.publishedAt) as any)
        )
        break

      case dateAsc:
        videoData.sort(
          (a, b) => (new Date(a.snippet.publishedAt) as any) - (new Date(b.snippet.publishedAt) as any)
        )
        break

      case viewDesc:
        videoData.sort(
          (a, b) => parseInt(b.statistics.viewCount) - parseInt(a.statistics.viewCount)
        )
        break

      case viewAsc:
        videoData.sort(
          (a, b) => parseInt(a.statistics.viewCount) - parseInt(b.statistics.viewCount)
        )
        break

      case likeDesc:
        videoData.sort(
          (a, b) => parseInt(b.statistics.likeCount) - parseInt(a.statistics.likeCount)
        )
        break

      case likeAsc:
        videoData.sort(
          (a, b) => parseInt(a.statistics.likeCount) - parseInt(b.statistics.likeCount)
        )
        break

      case commentDesc:
        videoData.sort(
          (a, b) => parseInt(b.statistics.commentCount) - parseInt(a.statistics.commentCount)
        )
        break

      case commentAsc:
        videoData.sort(
          (a, b) => parseInt(a.statistics.commentCount) - parseInt(b.statistics.commentCount)
        )
        break

    }

    setPageData(videoData.slice(0, pageRecord))

  }


//ページネーション
  const [page, setPage] = useState<number>(1)

  const [pageData, setPageData] = useState<items[]>([])

  const pageHandleChange = (event: any, value: number) => {
    setPage(value)

    const pageStart = (value - 1) * pageRecord

    const pageEnd = pageStart + pageRecord

    setPageData(videoData.slice(pageStart, pageEnd))

    window.scrollTo(0, 0)
  }


  const pageAll = Math.floor(videoData.length / pageRecord) + 1


//ページ描画
  return (
    <>

      <header>
        <div className='h-28 bg-red-600 flex items-center justify-center'>
          <div className='sm:w-8/12 w-10/12'>
            <h1 className='sm:text-4xl text-3xl text-white'>ベースを弾く。</h1>
            <p className='pt-2 pl-2 text-gray-800'>from Youtube</p>
          </div>
        </div>
      </header>

      {loading ? (
        <Loading />
      ) : (

      <main className="flex min-h-screen flex-col items-center justify-center py-10">
        
        <div className='sm:w-8/12 w-10/12'>
          <h2 className='pb-8 pl-2 text-lg'>@yohei_www</h2>
          <div className='pb-8 pl-2 flex items-center justify-left'>
            <Box sx={{ minWidth: 200 }}>
              <FormControl fullWidth>
                <InputLabel id="sort-pulldown-label">並び替え</InputLabel>
                <Select
                  labelId="sort-pulldown-label"
                  id="sort-pulldown"
                  value={sort}
                  label="並び替え"
                  onChange={sortHandleChange}
                >
                  <MenuItem value={dateDesc}>Date(降順)</MenuItem>
                  <MenuItem value={dateAsc}>Date(昇順)</MenuItem>
                  <MenuItem value={viewDesc}>View(降順)</MenuItem>
                  <MenuItem value={viewAsc}>View(昇順)</MenuItem>
                  <MenuItem value={likeDesc}>Like(降順)</MenuItem>
                  <MenuItem value={likeAsc}>Like(昇順)</MenuItem>
                  <MenuItem value={commentDesc}>Comment(降順)</MenuItem>
                  <MenuItem value={commentAsc}>Comment(昇順)</MenuItem>
                </Select>
              </FormControl>
            </Box>
          </div>
        </div>


        <Stack spacing={2}>
          <Pagination count={pageAll} variant="outlined" color="secondary" page={page} onChange={pageHandleChange} />
        </Stack>


        <div className='flex flex-col items-center justify-center'>
          {pageData.map((video) => (

            <div key={video.id} className='grid sm:grid-cols-2 sm:w-8/12 w-10/12 my-8 p-4 border-solid border-gray-300 border-2 rounded'>

              <div className='flex items-center justify-center'>
                  <a 
                  href={`https://m.youtube.com/watch?v=${video.id}`} 
                  target="_blank" 
                  rel="noopener noreferrer">
                    <Image
                    src={video.snippet.thumbnails.high.url} 
                    alt="サムネイル"
                    width={360}
                    height={270}
                    />
                  </a>
              </div>

              <div className='my-4 mx-4'>
                <p className='text-sm text-blue-400'>{video.snippet.publishedAt.replace(/[T]|[Z]/g,' ')}</p>
                <a className='sm:text-lg text-gray-400' 
                href={`https://m.youtube.com/watch?v=${video.id}`} 
                target="_blank" rel="noopener noreferrer">
                  {video.snippet.title}
                </a>

                <ul className='flex pt-2 text-sm text-blue-400'>
                  <li className='pr-2'>
                    <span>View:&nbsp;{video.statistics.viewCount}</span>
                  </li>
                  <li className='pr-2'>
                    <span>Like:&nbsp;{video.statistics.likeCount}</span>
                  </li>
                  <li>
                    <span>Comment:&nbsp;{video.statistics.commentCount}</span>
                  </li>
                </ul>

              </div>

            </div>

          ))}
        </div>

        <Stack spacing={2}>
          <Pagination count={pageAll} variant="outlined" color="secondary" page={page} onChange={pageHandleChange} />
        </Stack>

      </main>

      )}

    </>
  )
}

