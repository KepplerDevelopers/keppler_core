Mime::Type.register_alias 'text/excel', :xls

# Array of Hashes support
[{ name: 'ruby', version: '2.1.0' }, { name: 'rails', version: '4.1.0' }].to_xls

# ActiveRecords to save as .xls
if Developer.table_exists?
  @developers = Developer.all
  @developers.to_xls(
    only: %i[avatar name],
    except: [:id],
    header: false,
    prepend: [['Col 0, Row 0', 'Col 1, Row 0'], ['Col 0, Row 1']],
    column_width: [17, 15, 15, 40, 25, 37]
  )
  @developers.to_xls do |column, value|
    column == :salutation ? t(value) : value
  end
end

