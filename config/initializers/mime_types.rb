Mime::Type.register_alias 'text/excel', :xls

# Array of Hashes support
[{ name: 'ruby', version: '2.1.0' }, { name: 'rails', version: '4.1.0' }].to_xls

# ActiveRecords to save as .xls
