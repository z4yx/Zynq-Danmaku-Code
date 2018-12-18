#!/bin/sh

###
exec coffee $0 "$@"
###
process.stderr.write('Nodejs Version: ' + process.version + "\n");

sleep = require('sleep');
request = require('request');
URL = require('url');
config = require('./config.json');

testMode = false
if config['testMode']? 
  testMode = config['testMode']

api = "https://stu.cs.tsinghua.edu.cn/comment/app/screen"
token = "unset"

if config['srvUrl']?
  apiUrl = new URL.URL config['srvUrl']
  api = apiUrl.origin + apiUrl.pathname
  token = apiUrl.searchParams.get('token')
  # console.log(api)
  # console.log(apiUrl.searchParams)

if token is 'unset'
  throw new Error 'token not set'


if testMode
  nowId =1450615764115
else
  # waiting for correct system time
  while((nowId = (new Date).getTime()) < 1451606400000)
    process.stderr.write 'nowId='+nowId+" waiting \n"
    sleep.sleep(5)
process.stderr.write('Started, TestMode=' + testMode + "\n");
  
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
    if not err and Array.isArray body
      for m in body
        if testMode and m.id > nowId
          diff = Math.floor((m.id-nowId)/1000)
          if(diff>10) # speed up
            diff=10
          sleep.sleep(diff)
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
