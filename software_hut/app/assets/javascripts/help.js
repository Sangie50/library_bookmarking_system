// JavaScript for popup help boxes

function helpInit() {
  $('.help-button, .help-close').click(function() {
    // Toggles visibility
    let popup = $('.help-popup');
    if (popup.css('visibility') === 'hidden') {
      popup.css('visibility', 'visible');
    } else {
      popup.css('visibility', 'hidden');
    }
  });
}

$(helpInit);
$(document).on('turbolinks:load', helpInit);
