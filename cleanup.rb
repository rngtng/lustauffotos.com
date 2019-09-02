#!/usr/bin/env ruby

# if RUBY_VERSION =~ /1.9/ # assuming you're running Ruby ~1.9
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
# end

require 'pry'
require 'date'
require 'time'
require 'front_matter_parser'
require 'reverse_markdown'
require 'cgi'
require 'yaml'
require 'differ'

Differ.format = :color

loader = FrontMatterParser::Loader::Yaml.new(whitelist_classes: [Time])

Dir. glob("_posts/*.md").each do |filename|
  puts filename
  parsed = FrontMatterParser::Parser.parse_file(filename, loader: loader)
  content = CGI.unescapeHTML(parsed.content).strip

  filename2 = filename.gsub(".md", ".html")
  puts filename2
  string = File.read(filename2)
  parsed2 =  FrontMatterParser::Parser.new(:md).call(string)
  content2 = ReverseMarkdown.convert(parsed2.content).strip

  front_matter = parsed.front_matter.merge(parsed2.front_matter)
  File.open("new/#{filename}", 'w') do |file|
    file.write(front_matter.slice(
      *%w{id title date permalink layout categories tags comments}
    ).to_yaml)
    file.write("---\n")
    content3 = if content != content2
      puts  Differ.diff_by_char(content, content2)
      (gets.strip == 1) ? content : content2
    else
      content
    end
    file.write(content3)
  end
end
