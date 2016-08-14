##
# required seeds for app's first run

# Admin creation
email = ENV['ADMIN_EMAIL'] || 'admin@discursus.com'
pass = ENV['ADMIN_PASS']
admin = Admin.find_or_create_by(email: email)
admin.update(password: pass) if admin.new_record? && pass.present?

#
##
