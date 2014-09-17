/**
 * User: gisborne
 * Date: 9/15/14
 * Time: 21:42
 */

export render_relation = (relation, req, res, next) ->

export render_form_for_relation = (relation, req, res, next) ->
  res.set 'Content-Type', 'text/json'
  res.send relation.rows[0]