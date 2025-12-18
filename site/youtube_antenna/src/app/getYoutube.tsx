"use server"

export default async function getYoutube() {

  const apiKey = process.env.YOUTUBE_API_KEY
  const channelId = "UCn-csilsRLW3h2CiuGDb12w"

//チャンネル情報の取得
  async function getChannel() {

    const channelRes = await fetch(
      "https://www.googleapis.com/youtube/v3/channels?part=" +
        "contentDetails" +
        "&id=" +
        channelId + 
        "&key=" +
        apiKey,
      { cache: 'no-store', }
    )
      
    const channelData = await channelRes.json()

    return channelData;

  }

  const channelData = await getChannel()

  const uploadsId = channelData.items[0].contentDetails.relatedPlaylists.uploads


//プレイリスト情報の取得
  async function getPlaylist() {

    const playlistRes = await fetch(
      "https://www.googleapis.com/youtube/v3/playlistItems?part=" +
        "contentDetails" +
        "&playlistId=" +
        uploadsId +
        "&maxResults=50" +
        "&key=" +
        apiKey,
      { cache: 'no-store', }
    )
      
    const playlistData = await playlistRes.json()

    return playlistData;

  }

  const playlistData = await getPlaylist()

  const videoIdArray: string[] = []

  for (let i = 0; i < playlistData.items.length; i++) {
    videoIdArray.push(playlistData.items[i].contentDetails.videoId)
  }


  console.log(videoIdArray)


//動画データの取得
  async function getVideo() {

    const videoRes = await fetch(
      "https://www.googleapis.com/youtube/v3/videos?part=" +
        "snippet,statistics" +
        "&id=" +
        videoIdArray +
        "&key=" +
        apiKey,
      { cache: 'no-store', }
    )
      
    const videoData = await videoRes.json()

    return videoData.items;

  }

  let videoData = await getVideo()

//playlistData = プレイリスト情報のJSONファイル（動画ID取得用）
//videoData = 動画情報のJSONファイル
//videoIdArray = 動画IDを格納した配列


//プレイリスト情報の次ページを取得
  let pageToken = playlistData.nextPageToken

  async function getPlaylistNext() {

    while (pageToken !== undefined) {

      const nextPlaylistRes = await fetch(
        "https://www.googleapis.com/youtube/v3/playlistItems?part=" +
          "contentDetails" +
          "&playlistId=" +
          uploadsId +
          "&maxResults=50" +
          "&pageToken=" +
          pageToken +
          "&key=" +
          apiKey,
      { cache: 'no-store', }
    )

      const nextPlaylistData = await nextPlaylistRes.json()

      let nextVideoIdArray: string[] = []

      for (let j = 0; j < nextPlaylistData.items.length; j++) {
        nextVideoIdArray.push(nextPlaylistData.items[j].contentDetails.videoId)
      }

      if (nextPlaylistData.nextPageToken !== undefined) {
        pageToken = nextPlaylistData.nextPageToken
      } else {
        pageToken = undefined
      }

      const nextVideoRes = await fetch(
        "https://www.googleapis.com/youtube/v3/videos?part=" +
          "snippet,statistics" +
          "&id=" +
          nextVideoIdArray +
          "&key=" +
          apiKey,
      { cache: 'no-store', }
    )
          
      let nextVideoData = await nextVideoRes.json()

      videoData = videoData.concat(nextVideoData.items)

    }

    return videoData

  }

  await getPlaylistNext()

  return videoData

}
