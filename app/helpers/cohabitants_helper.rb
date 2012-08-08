module CohabitantsHelper
  def toggle_activated_button(cohabitant)
    button_info = if cohabitant.activated?
                    activated_info
                  else
                    deactivated_info
                  end

    button_to button_info[:text], toggle_activated_path(cohabitant),
      title: "#{button_info[:text].capitalize} #{cohabitant.department}",
      class: button_info[:html_class]
  end

  private

    def activated_info
      { text: 'deactivate', html_class: 'btn btn-inverse' }
    end
    
    def deactivated_info
      { text: 'activate', html_class: 'btn' }
    end
end
