"use client"

import './globals.css'
import CircularProgress from '@mui/material/CircularProgress';
import Box from '@mui/material/Box';


console.log('ロード中')

export default function Loading() {


  return (
    <>
    <div id='spiner' className='w-full h-screen bg-black text-white flex-col flex items-center justify-center'>
      <Box sx={{ display: 'flex' }}>
        <CircularProgress />
      </Box>
      <div className='pt-4'>
        <span className='animate-pulse'>Loading...</span>
      </div>
    </div>
    </>
  );
}