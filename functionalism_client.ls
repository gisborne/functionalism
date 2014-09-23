/**
 * User: gisborne
 * Date: 9/20/14
 * Time: 23:29
 */
require! _: 'prelude-ls'

<-! $ ->
  id_fields = $ \#id
  _.each ((f) ->
    unless f.value
      f.value = uuid.v4()), id_fields