require 'whois'
require 'whois-parser'
require 'csv'
require 'set'

latin_confusables_map = Hash[
  'a' => 'а',
  'c' => 'с',
  'd' => 'ԁ',
  'e' => 'е',
  'h' => 'һ',
  'i' => 'і',
  'j' => 'ј',
  # 'k' => 'ҟ',
  'l' => 'ӏ',
  'm' => 'м',
  'n' => 'п',
  'o' => 'о',
  'p' => 'р',
  'q' => 'ԛ',
  'r' => 'г',
  's' => 'ѕ',
  # 'u' => 'џ',
  'w' => 'ԝ',
  'x' => 'х',
  'y' => 'y'
]

latin_confusables = latin_confusables_map.keys.to_set

(0..9).each{|num| latin_confusables.add num.to_s }
c = Whois::Client.new

puts 'available domains: '

domains = CSV.read('./top-1m.csv').map(&:last)
domains.each do |domain|
  domain_name, tld = domain.split('.', 2)
  if Set[*domain_name.chars].subset?(latin_confusables)
    cyrllilc_domain = Array.new
    domain_name.each_char do |char|
      cyrllilc_domain.push latin_confusables_map[char]
    end
    cyrllilc_domain = cyrllilc_domain.join
    cyrllilc_domain += '.'
    cyrllilc_domain += tld

    begin 
      record = Whois.whois(cyrllilc_domain).parser
      if record.available?
        puts "#{domain} (#{cyrllilc_domain})"
      end
    rescue
      puts "--can't parse-- #{domain} (#{cyrllilc_domain})"
    end
  end
end