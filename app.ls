/**
 * User: gisborne
 * Date: 9/13/14
 * Time: 13:48
 */
require! express
require! './root'
require! bodyParser: 'body-parser'

app = express()
app.use bodyParser.urlencoded(extended: false) # parse application/x-www-form-urlencoded

app.use(express.static('public'));

app.all '*', root.rootHandle

app.listen 8080
