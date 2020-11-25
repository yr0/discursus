require 'csv'

desc 'Prints out how many times the pdfs in Hlyna series have been downloaded'
task count_hlyna_downloads: :environment do
  hlyna = Series.find_by(slug: 'hlyna')

  attachment_to_text_map = hlyna.books.flat_map do |book|
    doc = Nokogiri::HTML(book.description)
    
    doc.xpath("//a[contains(@href, '.pdf')]").map do |a|
      text = a.text
      text = "#{a.parent.text}: #{text}" if text =~ /розгортками|посторінково/

      [a.attributes['href'].value.match(/attachments\/(\d+)/).captures.first, text]
    end
  end

  log = File.read('/var/log/nginx/discursus_access.log.1')
  hlyna_csv_file = Rails.root.join('log/hlyna_downloads.csv')
  csv = CSV.read(hlyna_csv_file) rescue [[]]
  previous_counts = csv[1..-1].map { |id, _, count| [id, count.to_i] }.to_h
  
  CSV.open(hlyna_csv_file, 'wb') do |write_csv|
    write_csv << %w(id title downloads)
    
    attachment_to_text_map.each do |id, text|
      count = log.scan(/attachments\/#{id}\/.*pdf/).count

      write_csv << [id, text, count + previous_counts[id].to_i]
    end
  end

  puts "Hlyna downloads count successfully completed"
end
