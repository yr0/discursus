# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

# add fonts to assets path
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
Rails.application.config.assets.precompile += %w( home.scss ckeditor/* )
