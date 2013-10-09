#coding:utf-8
require 'mecab.rb'

def getSBEI word
	if word.size == 1
		return ['S']
	end
	ret = ['I'] * word.size
	ret[0] = 'B'
	ret[-1] = 'E'
	return ret
end

# MeCab標準の出力から、品詞の分類を得る
# _feature_ :: "名詞,固有名詞,組織,*,*,*,*"
# _return_ :: "名詞 固有名詞 組織"
def getPOS feature
	return feature.split(/,/)[0..2].join(' ').gsub(/\*/, '__nil__')
end

def getfeatures data
	chars = data['text'].split(//)
	sbei_tag = []
	pos_tag = []
	IOMecab.parse(data['text']).each do |w|
		# MeCabでは半角スペースが消えるので、
		# charsと照らしあわせて、半角スペースがある箇所には、
		# そういう素性を付け足す
		while chars[pos_tag.size] == ' '
			# 半角スペースの取り扱い
			chars[pos_tag.size] = 'Space'
			pos_tag.push 'Space __nil__ __nil__'
			sbei_tag.push 'S'
		end

		w[0].split(//).each_with_index do |ch,i|
			pos_tag.push getPOS(w[1])
		end
		sbei_tag += getSBEI w[0]
	end

	# 文末に半角スペースが来た時の対策
	while chars[pos_tag.size] == ' '
		chars[pos_tag.size] = 'Space'
		pos_tag.push 'Space __nil__ __nil__'
		sbei_tag.push 'S'
	end

	return [chars, sbei_tag, pos_tag]
end

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

