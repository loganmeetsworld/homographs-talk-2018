require 'whois'
require 'whois-parser'
require 'csv'
require 'set'
require 'simpleidn'

module HaFinder
  class Run
    def initialize
      @latin_confusables_map = Hash[
        'a' => 'а',
        'b' => 'Ь',
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
        'y' => 'у',
      ]
  
      @latin_confusables = @latin_confusables_map.keys.to_set
      (0..9).each{|num| @latin_confusables.add num.to_s; @latin_confusables_map[num.to_s] = num.to_s }  
    end

    def perform 
      c = Whois::Client.new

      puts 'available domains: '

      domains = CSV.read('./lib/ha-finder/top-1m.csv').map(&:last)
      domains.each do |domain|
        domain_name, tld = domain.split('.', 2)
        if Set[*domain_name.chars].subset?(@latin_confusables)
          cyrillic_domain = Array.new
          domain_name.each_char do |char|
            cyrillic_domain.push @latin_confusables_map[char]
          end
          cyrillic_domain = cyrillic_domain.join
          cyrillic_domain += '.'
          cyrillic_domain += tld
          punycode_domain = SimpleIDN.to_ascii(cyrillic_domain)

          begin 
            record = Whois.whois(punycode_domain).parser
            if !record.registered?
              puts "#{domain} (#{cyrillic_domain})"
            end
          rescue
            puts "--can't parse-- #{domain} (#{cyrillic_domain})"
          end
        end
      end
    end
  end
end
