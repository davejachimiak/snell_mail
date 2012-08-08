module CohabitantsHelper
  def toggle_activated_button(cohabitant)
    if cohabitant.activated?
      button_info = { text: 'deactivate', html_class: 'btn btn-inverse' }
    else
      button_info = { text: 'activate', html_class: 'btn' }
    end
    
    button_to button_info[:text], toggle_activated_path(cohabitant),
      title: "#{button_info[:text].capitalize} #{cohabitant.department}",
      class: button_info[:html_class]
  end
end
