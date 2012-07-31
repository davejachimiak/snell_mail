module CohabitantsHelper
  def toggle_activated_button(cohabitant)
    if cohabitant.activated?
      button_to 'deactivate', toggle_activated_path(cohabitant),
        title: "Deactivate #{cohabitant.department}", class: "btn btn-inverse"
    else
      button_to 'activate', toggle_activated_path(cohabitant),
        title: "Activate #{cohabitant.department}", class: "btn"
    end
  end
end
