#coding:utf-8
$LOAD_PATH.unshift './lib'
require 'features.rb'

while l = gets
	chars,sbei_tag,pos_tag = getfeatures({'text' => l.chomp})
	chars.size.times do |i|
		puts [ chars[i],
			pos_tag[i],
			sbei_tag[i],
		].join(' ')
	end
	print "\n"
	STDOUT.flush
end

