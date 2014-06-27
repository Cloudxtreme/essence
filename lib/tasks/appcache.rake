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

    fonts = Dir.glob File.join(Rails.root, 'public/fonts/**/*')
    fonts.each do |font|
      file.write "fonts/#{ File.basename(font) }\n"
    end

    audios = Dir.glob File.join(Rails.root, 'public/audios/**/*')
    audios.each do |audio|
      file.write "audios/#{ File.basename(audio) }\n"
    end

    javascripts = Dir.glob File.join(Rails.root, 'public/javascripts/**/*')
    javascripts.each do |javascript|
      file.write "javascripts/#{ File.basename(javascript) }\n"
    end

    file.write "NETWORK\n"
    file.write "*\n"
  end
end
