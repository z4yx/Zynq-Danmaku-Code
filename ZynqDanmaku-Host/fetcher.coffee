#!/bin/sh

###
exec coffee $0 "$@"
###
sleep = require('sleep');

token = "e2289b7366a270d8e1012e6fecb2f994ab80be26"

# nowId = 1481805759250
# waiting for correct system time
while((nowId = (new Date).getTime()) < 1451606400000)
  process.stderr.write 'nowId='+nowId+" waiting \n"
  sleep.sleep(5)

api = "https://stu.cs.tsinghua.edu.cn/comment/app/screen"


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
