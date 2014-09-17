/**
 * User: gisborne
 * Date: 9/13/14
 * Time: 22:03
 */

require! './db'
require! './relation'
require! './reqFns'

export get_root = (req, res, next) ->
  res.send 'foo ' + req.url

export get_handler = (req, res, next)->
  url = req.url
  url_parts = url.split '/'

  reqFns.get_path url_parts, req, res, next