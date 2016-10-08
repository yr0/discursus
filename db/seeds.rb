##
# required seeds for app's first run

# Admin creation
email = ENV['DEFAULT_ADMIN_EMAIL']
pass = ENV['DEFAULT_ADMIN_PASS']
admin = Admin.find_or_create_by(email: email)
admin.update(password: pass) if admin.new_record? && pass.present?

#
##
