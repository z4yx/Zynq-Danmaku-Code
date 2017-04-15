#!/bin/sh

###
exec coffee $0 "$@"
###
sleep = require('sleep');

token = "cb561cb3cd0ddff31551f4b49608639e56aad80d"

# nowId = 1481805759250
# waiting for correct system time
while((nowId = (new Date).getTime()) < 1451606400000)
  process.stderr.write 'nowId='+nowId+" waiting \n"
  sleep.sleep(5)

api = "http://c.n9.vc/app/screen"


request = require('request');

getOne = ()->

  request(
    method: 'GET'
    uri: api
    qs:
      token: token
      l: 1
      s: nowId.toString()
    json: true
  , (err, res, body)->
    if(!err)
      for m in body
        # if(m.id > nowId)
        #   sleep.sleep(Math.floor((m.id-nowId)/1000))
        nowId = m.id + 1 if m.id + 1 > nowId
        msg = if m.s 
          1
        else
          0
        msg += m.m + "\n" 
        process.stderr.write(m.id+" ")
        process.stderr.write(msg)
        process.stdout.write(msg)
    process.nextTick getOne
  )

getOne()
