// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require popper
//= require bootstrap
//= require activestorage
//= require_tree .

var Select2Cascade = (function(window, $) {
  function Select2Cascade(parent, child, url, select2Options, json_key) {
    var afterActions = [];
    var options = select2Options || {};

    // Register functions to be called after cascading data loading done
    this.then = function(callback) {
      afterActions.push(callback);
      return this;
    };

    parent.select2(select2Options).on("change", function (e) {
      child.prop("disabled", true);
      var _this = this;
        
      $.getJSON(url.replace(':parentId', $(this).val()), function(items) {

        var newOptions = '<option value="">-- Select --</option>';
        for(var id in items) {
          newOptions += '<option value="'+ items[id][json_key] +'">'+ items[id][json_key] +'</option>';
        }

        if (child.data('select2')) {
           child.select2('destroy');
         }

        child.html(newOptions).prop("disabled", false).select2(options);

        afterActions.forEach(function (callback) {
          callback(parent, child, items);
        });
      });
    });
  }

  return Select2Cascade;
})( window, $);

$(document).ready(function () {
  var select2Options = { selectOnClose: true };

  $('.autocomplete').select2(select2Options);                 

  var cascadLoading = new Select2Cascade(
    $('#visitor_country'),
    $('#visitor_city'),
    '/visitors/cities/:parentId',
    select2Options,
    'name'
  );
  $('#city_wrapper').show()
});
  
