# WickedPdf.configure do |config|
#   config.exe_path = '/usr/bin/wkhtmltopdf'  # run `which wkhtmltopdf` to confirm path
# end
# WickedPdf.config = {
#   exe_path: '/usr/bin/wkhtmltopdf',
#   enable_local_file_access: true
# }

# config/initializers/wicked_pdf.rb
WickedPdf.configure do |config|
  config.exe_path = '/usr/bin/wkhtmltopdf' 
  config.enable_local_file_access = true
end
