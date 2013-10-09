#!/bin/sh
ruby -Ku ./lib/features.rb $1 | yamcha -m emoticon.model | ruby -Ku ./lib/extraction.rb
