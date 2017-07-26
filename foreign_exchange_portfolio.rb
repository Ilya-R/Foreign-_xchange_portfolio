# encoding: utf-8

require 'net/http'
require 'uri'
require 'rexml/document'
require 'date'

uri = URI.parse('http://www.cbr.ru/scripts/XML_daily.asp')
response = Net::HTTP.get_response(uri)
doc = REXML::Document.new(response.body)

# R01235 — Доллар США
doc.each_element('//Valute[@ID="R01235"]') do |currency_tag|
  @value = currency_tag.get_text('Value').to_s.tr(',', '.').to_f
end

exchange_rate = @value.to_f
puts "Курс доллара #{exchange_rate}"

puts 'Введите кол-во долларов у вас на руках:'
quant_dollars = STDIN.gets.to_f

puts 'Введите кол-во рублей у вас на руках'
quant_rubles = STDIN.gets.to_f

disbalance = ((quant_dollars * exchange_rate) - quant_rubles)

if disbalance.abs.round(2) < exchange_rate
  puts 'Ваш портфель сбалансирован'
elsif disbalance > 0
  abort "Вам нужно продать #{(disbalance / 2 / exchange_rate).round(2)} долларов"
else
  abort "Вам нужно продать #{(disbalance.abs / 2).round(2)} рублей"
end
