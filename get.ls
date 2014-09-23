/**
 * User: gisborne
 * Date: 9/13/14
 * Time: 22:03
 */

require! './db'
require! './relation'
require! './reqFns'
require! './put'

export get_root = (req, res, next) ->
  res.send 'foo ' + req.url