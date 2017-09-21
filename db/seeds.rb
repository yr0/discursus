##
# required seeds for app's first run

# Admin creation
email = ENV['DEFAULT_ADMIN_EMAIL']
pass = ENV['DEFAULT_ADMIN_PASS']
admin = Admin.find_or_create_by(email: email)
admin.update!(password: pass) if admin.new_record? && pass.present?

# Settings seed
setting = Setting.first_or_initialize
if setting.new_record?
  setting.assign_attributes(email: '@', phone: '0', home_hero_title: 'Discursus')
  setting.save!
end
#
##
