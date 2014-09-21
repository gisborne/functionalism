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
require! method_override: 'method-override'
require! bodyParser: 'body-parser'

global.fn = {}

# NOTE: when using req.body, you must fully parse the request body
#       before you call methodOverride() in your middleware stack,
#       otherwise req.body will not be populated.

app = express()
app.use bodyParser.urlencoded(extended: false) # parse application/x-www-form-urlencoded

# parse application/json
#app.use bodyParser.json()
#app.use method_override '_method'

app.use('/static', express.static(__dirname + '/public'))
app.route /.*/
  .get  get.get_handler

app.listen 8080
