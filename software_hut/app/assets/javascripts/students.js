/**
 * students.js
 * 
 * A Javascript file for helping manage the student views
 *.
 * @author William Lee
 * @since  05.05.21
*/

/**
 * When a department code is selected, it will show the department's module IDs
 * When a department code is selected, it will also show the tuttees 
*/
initDepartmentModuleSelects('#search_department_code', '#search_module_ids');
initDepartmentAcademicSelects('#student_department_code', '#supervisor_username');

/**
 * A callback function for a search menu so it only includes the search date in searches when box is ticked
*/
$(function() {
  $('#search_include_date').change(function() {
    let checked = $(this).is(':checked');
    let updatedAtDateInput = $('#search_updated_at');
    checked ? updatedAtDateInput.removeAttr('disabled') : updatedAtDateInput.attr('disabled', 'disabled');
  })
  .trigger('change');
});
