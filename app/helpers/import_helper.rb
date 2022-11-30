module ImportHelper
  def get_columns_as_option(controller_name)
    columns = controller_name.titleize.singularize.constantize.columns
    columns.map { |col| [col.name, col.name] }
  end
end
