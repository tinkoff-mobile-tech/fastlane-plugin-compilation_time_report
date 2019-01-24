require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class CompilationTimeReportHelper

      def self.generateResultsHashes(source_pathes, time_limit, xcodebuild_log_path)
        results = Array.new()
        
        source_pathes = source_pathes.join("|")
        compile_time_regex = /^[0-9]+.[0-9]/
        file_name_regex = /\w+\.swift/
        column_line_regex = /[0-9]+:[0-9]+/
        func_regex = /[a-z_A-Z]+\([^\)]*\)(\.[^\)]*\))?/
        line_with_compile_time_regex = /(^[0-9]+.[0-9])+.*\b(#{source_pathes})\b.*/
        
        File.open(xcodebuild_log_path, "rb") do |xcodebuild_log_file|
          xcodebuild_log_file.each_line { |line|
            line.scan(line_with_compile_time_regex) do |match|
              compile_time = match[0].scan(compile_time_regex)[0].to_f
              if compile_time >= time_limit
                results.push({
                              "time" => compile_time, 
                              "file" => line.match(file_name_regex).to_s, 
                              "column:line" => line.match(column_line_regex).to_s,
                              "func" => line.match(func_regex).to_s
                            })
              end
            end
          }
        end
        
        results.uniq.sort_by { |hsh| -hsh["time"] }        
      end

    end
  end
end
