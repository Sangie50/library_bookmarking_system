/**
 * Application.js
 * 
 * Automatically generated file to ensure that all necessary libraries run on Javascript
 *.
 * @author William Lee, Sophie Dillon
 * @since  26.04.21 
*/

//= require jquery
//= require jquery_ujs
//= require ajax_setup
//= require ajax_modal
//= require popper
//= require bootstrap
//= require flash_message
//= require visibility_map
//= require modal
//= require turbolinks
//= require select2
//= require select2_init
//= require department_module_select
//= require department_academic_select
//= require help
//= require academic
//= require students
//= require course_modules

/**
 * Callback function before Turbolinks caches pages.
*/
$(document).on('turbolinks:before-cache', function () {
  $('.collapse.show').collapse("hide");
  $('select').select2('destroy');
});

/**
 * A function which uses Turbolinks to submit the form.
 * @return false - what is needed to be returned to allow the function to work
*/
$(document).on("submit", "form[method=get]", function (e) {
  Turbolinks.visit(`${this.action}${this.action.indexOf('?') == -1 ? '?' : '&'}${$(this).serialize()}`);
  return false;
});
