/**
 * department_academic_select.js
 * 
 * A file for managing various academic-related things belonging to their department 
 *.
 * @author William Lee
 * @since  26.04.21 
*/

/**
 * A function for whenever a department is changed, the academic is updated with it
 * @param  departmentSelectId whatever department is selected, the department ID is passed in
 * @param  academicSelectId the ID for the academic select box
*/
function updateAcademics(departmentSelectId, academicSelectId) {

  /**
   * A function for clearing the academic select
  */
  function clearAcademicSelect() {
    academicSelect.attr('disabled', 'disabled').empty();
  }

  let departmentSelect = $(departmentSelectId);
  let academicSelect = $(academicSelectId);
  let value = departmentSelect.val();
  if (!value) {
    clearAcademicSelect();
    return;
  }
  $.ajax({
    url: `/departments/${value}/academics`,
    type: 'get',
  }).done(function (data, _textStatus, _jqXHR) {
    let academics = [];
    for (let code in data) {
      academics.push({
        id: code,
        text: data[code],
      });
    }
    if (academics.length > 0) {
      $(academicSelectId).removeAttr('disabled').empty().select2({ data: academics, width: '100%' });
    } else {
      clearAcademicSelect();
    }
  }).fail(function () {
    console.log("Failed to retrieve academics");
  });
}

/**
   * Initialises department and academic select boxes with Select2
  * @param  departmentSelectId whatever department is selected, the department ID is passed in
  * @param  academicSelectId the ID for the academic select box
*/
function initDepartmentAcademicSelects(departmentSelectId, academicSelectId) {
  $(document).on('turbolinks:load', function () {
    function callback() {
      updateAcademics(departmentSelectId, academicSelectId);
    }
    $(departmentSelectId).select2({ width: '100%' }).change(callback)
    $(academicSelectId).select2({ width: '100%' })
    if (!$(`${departmentSelectId} option`).length) {
      callback();
    }
  });
}
