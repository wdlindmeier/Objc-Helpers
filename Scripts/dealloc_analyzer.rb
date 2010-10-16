#!/usr/bin/env ruby

# This script scans Objective C Class files and checks that member variables
# are found in the dealloc or didTurnIntoFault methods. 
#
# Usage: 
# $ ./dealloc_analyzer.rb Path/To/Classes/

require 'fileutils'

if !ARGV[0]
  
  puts "\nERROR: Please input a class path you would like to analyze.\n\n"
  
else
  
  Dir.glob(File.join(ARGV[0], '**/*.h')).each do |f|
    interface = File.read(f).scan(/\@interface[^\n]+\{[^}]*\}/mis)
    if !interface.empty?
      interface.each do |i|
        matches = i.scan(/^[^\*\/]*\*([^;)\n]*);/mis)
        matches.each do |m|
          varname = m.first.strip
          mfile_name = f.sub('.h', '.m')
          if File.file?(mfile_name)
            dealloc_matches = File.read(mfile_name).scan(/dealloc.*(#{varname}).*\}/mis)
            dealloc_matches += File.read(mfile_name).scan(/didTurnIntoFault.*(#{varname}).*\}/mis)
            if dealloc_matches.empty?
              puts "\n#{varname} not released in #{f}"
            end
          end
        end
      end
    end
    print '.';$stdout.flush    
  end
  
  puts "\n"
  
end