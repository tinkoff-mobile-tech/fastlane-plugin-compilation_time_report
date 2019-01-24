require 'fastlane/action'
require_relative '../helper/compilation_time_report_helper'

module Fastlane
  module Actions
    class CompilationTimeReportAction < Action
      def self.run(params)
        require "erb"
        UI.message("The compilation_time_report plugin is working!")        

        @hashes_results = Helper::CompilationTimeReportHelper.generateResultsHashes(params[:source_pathes], params[:time_limit], params[:xcodebuild_log_path])        
        template = 
        '
        <style type="text/css">
        	.flat-table {
          		display: block;
          		font-family: sans-serif;
                -webkit-font-smoothing: antialiased;
          		font-size: 100%;
          		overflow: auto;
          		width: auto;
        	}
        	.flat-table th {
          		background-color: #70c469;
          		color: white;
          		font-weight: normal;
          		padding: 20px 30px;
          		text-align: center;
        	}
        	.flat-table td {
          		background-color: #eeeeee;
          		color: #6f6f6f;
          		padding: 20px 30px;
        	}
        </style>        
        <table class="flat-table">
          <tbody>
            <tr>
              <th>Compilation time (ms)</th>
              <th>File</th>
              <th>Column:Line</th>
              <th>Function</th>              
            </tr>
            <% for info in @hashes_results %>
            <tr>
              <td><%= info["time"] %></td>
              <td><%= info["file"] %></td>
              <td><%= info["column:line"] %></td>
              <td><%= info["func"] %></td>
            </tr>
            <% end %>
          </tbody>
        </table>
'

        result = ERB.new(template).result(binding())

        sh("rm -rf fastlane/compilation_time_report")
        sh("mkdir fastlane/compilation_time_report")
        sh("touch fastlane/compilation_time_report/index.html")

        File.open('fastlane/compilation_time_report/index.html', 'w+') do |file|
          file.puts result
        end
      end

      def self.description
        "Generate custom HTML report compilation time of each Swift func"
      end

      def self.authors
        ["i.v.vasilenko"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Generate custom HTML report compilation time of each Swift function from provided xcode_build_log"
        "Note: You should provide xcode_build with enabled '-Xfrontend -debug-time-function-bodies' in OTHER_SWIFT_FLAGS"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcodebuild_log_path,
                                  env_name: "COMPILATION_TIME_REPORT_XCODEBUILD_LOG_PATH",
                               description: "A description of your option",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :time_limit,
                                  env_name: "COMPILATION_TIME_REPORT_TIME_LIMIT",
                               description: "Single function compilation time limit in miliseconds",
                                      type: Float, 
                                  optional: true,
                             default_value: 100),
          FastlaneCore::ConfigItem.new(key: :source_pathes,
                                  env_name: "COMPILATION_TIME_REPORT_SOURCE_PATHES",
                               description: "Source pathes that should be scanned",
                                      type: Array,
                                  optional: false)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end