# Snapshooter

A snapshot utility. Takes an URL, waits for the page to load and takes a snapshot.

**Note**
Service waits until the page signals that it's ready for a snapshot. See more here: https://www.npmjs.com/package/webshot search for `takeShotOnCallback`.

### Usage

`GET http://snapshoterurl/shot?url={URL}`

Returns AWS response for uploading or error if it occured.

### Development

Build  
`docker build -t snapshooter .`

Run:  
`docker run -p 1437:1437 -it --rm --name snapshooter snapshooter`

Or to have files mounted in cotainer:  
`docker run -p 1437:1437 -it --rm -v /path/to/snapshooter/:/usr/app/ --name snapshooter snapshooter`

### Authors

* [Jan Halozan](https://github.com/JanHalozan)
