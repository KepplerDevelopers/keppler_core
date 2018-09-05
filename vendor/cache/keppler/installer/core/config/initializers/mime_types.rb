Mime::Type.register 'application/xls', :xls

# Array of Hashes support
[{ name: 'ruby', version: '2.5.1' }, { name: 'rails', version: '5.2.0' }].to_xls

# ActiveRecords to save as .xls
