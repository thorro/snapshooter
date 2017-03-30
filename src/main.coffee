webshot = require 'webshot'
validUrl = require 'valid-url'
express = require 'express'
fs = require 'fs'

Uploader = require 's3-image-uploader'
app = express()

unless process.env.NODE_AWS_KEY? and process.env.NODE_AWS_SECRET? and process.env.NODE_AWS_BUCKET
  console.log 'Missing AWS config'
  process.exit 1

app.get '/shot', (req, res) ->
  url = req.query.url
  return res.status(400).send '{"error": "No URL provided"}' unless url?
  return res.status(400).send '{"error": "Invalid URL provided"}' unless validUrl.isUri url

  outputName = "#{Math.random().toString(30).substr 2}.jpg"
  outPath = "./data/#{outputName}"

  options =
    renderDelay: 1000          #Wait for another 0.1s after the page is loaded
    takeShotOnCallback: true  #Wait for page to tell us it's ready
    timeout: 15000            #15s
    windowSize:
      width: 1920
      height: 1080

  webshot url, outPath, options, (err) ->
    if err?
      console.log err
      return res.status(500).send '{"error": "Could not snapshot", "message": "' + err + '"}'

    uploader = new Uploader
      aws:
        key: process.env.NODE_AWS_KEY
        secret: process.env.NODE_AWS_SECRET
      websockets: false

    options =
      bucket: process.env.NODE_AWS_BUCKET
      source: outPath
      name: outputName
      fileId: outputName

    uploader.upload options
    , (data) ->
      fs.unlinkSync outPath
      res.json data
    , (message, error) ->
      console.log error
      if fs.existsSync outPath
        fs.unlinkSync outPath
      res.status(500).send '{"error": "Unable to upload file.", "message": "' + message + '", "errorObj": "' + JSON.stringify(error) + '"'

port = process.env.port || 1437
app.listen port, () ->
  console.log 'Listening on ' + port
