# class CurrencyInput < SimpleForm::Inputs::Base
#   def input(wrapper_options)
#     merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

#     "<br>$#{@builder.text_field(attribute_name, merged_input_options)}".html_safe
#   end
# end

class CurrencyInput < SimpleForm::Inputs::Base

  def input
    input_html_classes.unshift("string currency")
    input_html_options[:type] ||= input_type if html5?

    template.content_tag(:span, "", class: "add-on") +
      @builder.text_field(attribute_name, input_html_options).html_safe
  end
end