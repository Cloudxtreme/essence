#encoding: utf-8
desc 'Create an HTML5 AppCache manifest'
task appcache: :environment do
  File.open('public/application.manifest', 'w') do |file|
    file.write "CACHE MANIFEST\n"
    file.write "# #{ Time.now.to_i }\n"
    assets = Dir.glob File.join(Rails.root, 'public/assets/**/*')
    assets.each do |asset|
      if File.extname(asset) != '.gz'
        file.write "assets/#{ File.basename(asset) }\n"
      end
    end
    file.write "NETWORK\n"
    file.write "*\n"
  end
end
