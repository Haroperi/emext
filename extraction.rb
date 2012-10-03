#coding:utf-8
require 'pp'

# メモ: 「# 1」と書かれている行を全部消せば、顔文字だけが抽出されます。

def each_emoticon(obj, &block)
	ret = []
	if obj['emoticons'].size == 0
		ret << obj['text'] # 1
	else
		i = 0
		obj['emoticons'].each do |range|
			if i < range[0]
				ret << obj['text'].split(//)[i..range[0]-1].join # 1
				i = range[0]
			end
			fail unless i == range[0]

			ret << (yield obj['text'].split(//)[range[0]..range[1]].join)
			i = range[1]+1
		end

		tail = obj['text'].split(//)[i..-1].join
		ret << tail if tail != nil && tail != '' # 1
	end
	ret
end

# YamChaのBIOを解釈し、原文中の顔文字の範囲を[0,10]みたいな範囲で表す形式に変換する
def hoge(chars, iob_tags)
	ret = {'text' => chars.join, 'emoticons' => [] }
	range = []
	iob_tags.size.times do |i|
		case iob_tags[i]
		when 'B'
			range[0] = i
		when 'I'
			range[1] = i
		when 'O'
			if range != []
				ret['emoticons'].push range
				range = []
			end
		else
			fail
		end
	end
	ret['emoticons'].push range if range != []
	return ret
end

def each_sentence &block
	# 空行まで読み込む
	chars = []
	iob_tags = []
	while l = gets
		l.chomp!
		if l == ''
			yield hoge chars, iob_tags
			chars = []
			iob_tags = []
		else 
			row = l.split(/\t/)
			row[0] = ' ' if row[0] == 'Space'
			chars << row[0]
			iob_tags << row[-1]
		end
	end
end

each_sentence do |s|
	puts (each_emoticon(s) { |e| "<em>#{e}</em>"}).join
end

