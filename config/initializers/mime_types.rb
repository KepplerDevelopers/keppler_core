Mime::Type.register_alias 'text/excel', :xls

# Array of Hashes support
[{ name: 'ruby', version: '2.1.0' }, { name: 'rails', version: '4.1.0' }].to_xls

# ActiveRecords to save as .xls
if Banner.table_exists?
  @banners = Banner.all
  @banners.to_xls(
    only: %i[cover category_id],
    except: [:id],
    header: false,
    prepend: [['Col 0, Row 0', 'Col 1, Row 0'], ['Col 0, Row 1']],
    column_width: [17, 15, 15, 40, 25, 37]
  )
  @banners.to_xls do |column, value|
    column == :salutation ? t(value) : value
  end
end

if Shop.table_exists?
  @shops = Shop.all
  @shops.to_xls(
    only: %i[image name category_id],
    except: [:id],
    header: false,
    prepend: [['Col 0, Row 0', 'Col 1, Row 0'], ['Col 0, Row 1']],
    column_width: [17, 15, 15, 40, 25, 37]
  )
  @shops.to_xls do |column, value|
    column == :salutation ? t(value) : value
  end
end

if Category.table_exists?
  @categories = Category.all
  @categories.to_xls(
    only: %i[icon name],
    except: [:id],
    header: false,
    prepend: [['Col 0, Row 0', 'Col 1, Row 0'], ['Col 0, Row 1']],
    column_width: [17, 15, 15, 40, 25, 37]
  )
  @categories.to_xls do |column, value|
    column == :salutation ? t(value) : value
  end
end

