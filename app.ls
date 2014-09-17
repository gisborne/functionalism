/**
 * User: gisborne
 * Date: 9/13/14
 * Time: 13:48
 */
require! express
require! './db'
require! './get'
require! './put'
require! './conversions'

global.fn = {}

app = express()
  ..use('/static', express.static(__dirname + '/public'))
  ..route '/'
  .get get.get_root

app.route /.*/
  .get  get.get_handler
  .put  put.put_handler

app.listen 8080
