#coding:utf-8

# popenでMeCabを使う
module IOMecab
	PATH_TO_MECAB = 'mecab'

	# parse string with MeCab
	# _str_ :: string to input for MeCab
	# _option_ :: MeCabのcommand line option
	# 返り値 :: Array of Array [word, feature]
	def IOMecab.parse(str, option='')
		if str.index "\n"
			STDERR.puts "改行を削除"
			str.gsub!(/\n/, '')
		end
		res = IOMecab.mecab(option, str)
		return res if !res

		ret = []
		res.each do |line|
			line.chomp!
			next if line == 'EOS'
			ret.push line.split(/\t/)
		end
		return ret
	end

	def IOMecab.wakati(str, option = '')
		ret = []
		wakati = IOMecab.mecab('-O wakati ' + option, str)
		wakati.each do |line|
			ret << line.split(' ')
		end
		return ret
	end

	private
	def IOMecab.mecab(opt, str)
		IO.popen("#{PATH_TO_MECAB} #{opt}", 'r+') do |mecab|
			mecab.puts str
			mecab.close_write
			ret = mecab.readlines

			# readlinesによる改行文字を削除
			ret.each do |row|
				row.sub!(/ ?\n$/, '') if row[-1] == "\n"
			end
			return ret
		end
		return nil
	end
end

if __FILE__ == $0
	require 'pp'
	while l = gets
		pp IOMecab.parse(l.chomp)
		pp IOMecab.wakati(l.chomp)
	end
end

