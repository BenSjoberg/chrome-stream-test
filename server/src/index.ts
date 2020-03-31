import { createServer, IncomingMessage, ServerResponse } from 'http'
import { Agent } from 'https'
import { Readable } from 'stream'
import { S3 } from 'aws-sdk'
import { EventEmitter } from 'events'
import { join, dirname } from 'path'
import PQueue from 'p-queue'

const server = createServer(handleRequest)
server.listen(8087)

function handleRequest(req: IncomingMessage, res: ServerResponse): void {
  const key = req.url?.replace(/^\//, '') ?? ''
  uploadReadableStream(key, req).then(() => {
    res.statusCode = 201
    res.end()
    // console.log("Uploaded:", key)
  }).catch(e => {
    res.statusCode = 500
    res.end(e.message)
  })
}

const s3 = new S3({ httpOptions: { agent: new Agent({ keepAlive: true }) } })
const emitter = new EventEmitter()
let lastUploadedKey = ''
const queue = new PQueue({ concurrency: 3, timeout: 60e3, throwOnTimeout: true })
async function uploadReadableStream(key: string, stream: Readable) {
  if(key.endsWith('.m3u8')) {
    return uploadPlaylist(key, stream)
  }

  console.time(key)
  await queue.add(() => s3.upload({
    Bucket: 'g2planet-hls-media',
    Key: key,
    Body: stream,
    ACL: 'public-read',
    CacheControl: `public, max-age=${key.endsWith('.m3u8') ? '0' : '86400'}`
  }).promise())
  console.timeEnd(key)

  lastUploadedKey = key
  emitter.emit('upload')
}

async function uploadPlaylist(key: string, stream: Readable) {
  // Read the file
  const playlist = await new Promise<string>((resolve, reject) => {
    const buffers: Buffer[] = []
    stream.on('data', d => buffers.push(d))
    stream.on('error', reject)
    stream.on('end', () => resolve(Buffer.concat(buffers).toString()))
  })

  // Get the most recent file in the list
  const lines = playlist.trim().split('\n').filter(line => line.match(/\.ts$/))
  const lastFile = lines[lines.length - 1] ?? ''
  const lastKey = join(dirname(key), lastFile)
  if(lastFile && lastUploadedKey < lastKey) {
    await new Promise(resolve => {
      const handler = () => {
        if(lastUploadedKey >= lastKey) {
          resolve()
        }
        emitter.off('upload', handler)
      }
      emitter.on('upload', handler)
    })
  }

  console.log("Next:", lastKey)
  queue.add(() => s3.upload({
    Bucket: 'g2planet-hls-media',
    Key: key,
    Body: playlist,
    ACL: 'public-read',
    CacheControl: 'public, max-age=0'
  }).promise()).catch(console.error)
}
