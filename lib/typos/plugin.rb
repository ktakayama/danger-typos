# frozen_string_literal: true

require "json"
require "open3"

module Danger
  # [Danger](http://danger.systems/ruby/) plugin for [typos](https://github.com/crate-ci/typos).
  #
  # @example Run typos and send warn comment.
  #
  #          typos.binary_path = "path/to/typos"
  #          typos.run
  #
  # @see  ktakayama/danger-typos
  # @tags typos
  #
  class DangerTypos < Plugin
    # typos path
    # @return [String]
    attr_accessor :binary_path

    # Execute typos
    # @return [void]
    def run
      return if target_files.empty?

      args = ["--force-exclude", "--format", "json"] + target_files
      stdout, = Open3.capture3(cmd_path, *args)

      stdout.split("\n").each do |result|
        data = JSON.parse(result)
        next if data["type"] != "typo"

        warn(
          "`#{data['typo']}` should be `#{data['corrections'].first}`",
          file: data["path"],
          line: data["line_num"]
        )
      end
    end

    private

    def cmd_path
      return binary_path if binary_path

      cmd = File.expand_path("~/.cargo/bin/typos")
      File.exist?(cmd) ? cmd : "typos"
    end

    def target_files
      ((git.added_files + (git.modified_files - git.deleted_files)) - git.renamed_files.map { |r| r[:before] } + git.renamed_files.map { |r| r[:after] }).uniq
    end
  end
end
