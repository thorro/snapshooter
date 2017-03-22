webshot = require 'webshot'
validUrl = require 'valid-url'
express = require 'express'

Uploader = require 's3-image-uploader'
app = express()

app.get '/shot', (req, res) ->
  url = req.query.url
  res.status(400).send '{"error": "No URL provided"}' unless url?
  res.status(400).send '{"error": "No URL provided"}' unless validUrl.isUri url

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
      res.json data
    , (message, error) ->
      res.status(500).send '{"error": "Unable to upload file.", "message": "' + message + '", "errorObj": "' + JSON.stringify(error) + '"'

port = process.env.port || 1437
app.listen port, () ->
  console.log 'Listening on ' + port
