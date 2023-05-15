function updateModules(departmentSelectId, moduleSelectId) {
  function clearModuleSelect() {
    moduleSelect.attr('disabled', 'disabled').empty();
  }

  let departmentSelect = $(departmentSelectId);
  let moduleSelect = $(moduleSelectId);
  let value = departmentSelect.val();
  if (!value) {
    clearModuleSelect();
    return;
  }
  $.ajax({
    url: `/departments/${value}/modules`,
    type: 'get',
  }).done(function (data, _textStatus, _jqXHR) {
    let modules = [];
    for (let code in data) {
      modules.push({
        id: code,
        text: data[code],
      });
    }
    if (modules.length > 0) {
      $(moduleSelectId).removeAttr('disabled').empty().select2({ data: modules, width: '100%' });
    } else {
      clearModuleSelect();
    }
  }).fail(function () {
    console.log("Failed to retrieve modules");
  });
}

function initDepartmentModuleSelects(departmentSelectId, moduleSelectId) {
  $(document).on('turbolinks:load', function () {
    function callback() {
      updateModules(departmentSelectId, moduleSelectId);
    }
    $(departmentSelectId).select2({ width: '100%' }).change(callback)
    $(moduleSelectId).select2({ width: '100%' })
    if (!$(`${departmentSelectId} option`).length) {
      callback();
    }
  });
}
