# app/inputs/wday_input.rb
class WdayInput < SimpleForm::Inputs::Base
  def input
    @builder.select(attribute_name, I18n.t(:"date.day_names").each_with_index.to_a)
  end
end
