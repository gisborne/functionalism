// Generated by LiveScript 1.2.0
/**
 * User: gisborne
 * Date: 9/20/14
 * Time: 23:29
 */
(function(){
  var _;
  _ = require('prelude-ls');
  $(function(){
    var id_fields;
    id_fields = $('#id');
    return _.each(function(f){
      if (!f.value) {
        return f.value = uuid.v4();
      }
    }, id_fields);
  }, function(){});
}).call(this);
