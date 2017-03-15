webshot = require 'webshot'
validUrl = require 'valid-url'
minimist = require 'minimist'
Uploader = require 's3-image-uploader'

fatalError = (message, code) ->
  console.log message
  process.exit code

fatalError 'No AWS config present', 8 unless process.env.NODE_AWS_KEY? and process.env.NODE_AWS_SECRET? and process.env.NODE_AWS_BUCKET?

args = minimist process.argv.slice(2)

fatalError 'Missing url', 1 unless args.u? or args.url?

url = if args.u? then args.u else args.url
fatalError 'URL not a string', 4 unless typeof url is 'string'
fatalError 'URL not valid', 2 unless validUrl.isUri url

outputName = if args.o? then args.o else args.output
if outputName?
  fatalError 'Output name not a string', 4 unless outputName is 'string'
unless outputName
  outputName = "#{Math.random().toString(30).substr 2}.jpg"

outPath = "./data/#{outputName}"

options =
  renderDelay: 100          #Wait for another 0.1s after the page is loaded
  takeShotOnCallback: true  #Wait for page to tell us it's ready
  timeout: 15000            #15s
  windowSize:
    width: 1920
    height: 1080

webshot url, outPath, options, (err) ->
  fatalError 'Could not snapshot. ' + err, 3 if err?

  uploader = new Uploader
    aws:
      key: process.env.NODE_AWS_KEY,
      secret: process.env.NODE_AWS_SECRET
    websockets: false

  options =
    bucket: process.env.NODE_AWS_BUCKET,
    source: outPath,
    name: outputName,
    fileId: outputName
  uploader.upload options
  , (data) ->
    console.log data.path
    process.exit 0
  , (message, error) ->
    fatalError message, 12
