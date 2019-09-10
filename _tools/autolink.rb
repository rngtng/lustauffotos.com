#!/usr/bin/env ruby
# frozen_string_literal: true

# if RUBY_VERSION =~ /1.9/ # assuming you're running Ruby ~1.9
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
# end

require 'bundler/setup'
require 'pry'
require 'front_matter_parser'

Dir. glob('../_posts/*.md').each do |filename|
  puts filename
  parsed = FrontMatterParser::Parser.parse_file(filename)

  content = parsed.content.gsub(/(^|\s)(https?:\/\/\S+)(\s|$)/, '\1<\2>\3')
  # content2 = content2.gsub(/\(<(https?:\/\/[^ \]\)\n]+)>\)/, '(\1)')
  # binding.pry  if content2.include?('\_')
  # content2 = content2.gsub('\_', '_')

  File.open(filename, 'w') do |file|
    file.write(parsed.front_matter.to_yaml)
    file.write("---\n")
    file.write(content)
  end
end
