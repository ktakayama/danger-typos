# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerTypos do
    let(:fixtures_path) { File.expand_path("fixtures", __dir__) }

    it "should be a plugin" do
      expect(Danger::DangerTypos.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.typos
      end

      context "with a file included no warnings" do
        before do
          allow(@my_plugin).to receive(:target_files).and_return(
            [File.join(fixtures_path, "no_warnings.txt")]
          )
        end

        it "warns nothing" do
          @my_plugin.run

          expect(@dangerfile.status_report[:warnings]).to eq([])
        end
      end

      context "with a file included some errors" do
        let(:expected_message1) { "`Udate` should be `Update`" }
        let(:expected_message2) { "`Sampl` should be `Sample`" }
        before do
          allow(@my_plugin).to receive(:target_files).and_return(
            [File.join(fixtures_path, "error.txt")]
          )
        end

        it "returns error" do
          @my_plugin.run

          expect(@dangerfile.status_report[:warnings]).to eq([expected_message1, expected_message2])

          violation_report = @dangerfile.violation_report[:warnings].first
          expect(violation_report.file).to eq(File.join(fixtures_path, "error.txt"))
          expect(violation_report.line).to eq(1)
          expect(violation_report.message).to eq(expected_message1)
        end
      end

      context "with a file containing errors according to config file" do
        let(:expected_message) { "`Udate` should be `Update`" }
        before do
          allow(@my_plugin).to receive(:target_files).and_return(
            [File.join(fixtures_path, "error.txt")]
          )
        end

        it "returns error" do
          config_path = File.join(fixtures_path, "typos_config.toml")
          @my_plugin.run(config_path: config_path)

          expect(@dangerfile.status_report[:warnings]).to eq([expected_message])

          violation_report = @dangerfile.violation_report[:warnings].first
          expect(violation_report.file).to eq(File.join(fixtures_path, "error.txt"))
          expect(violation_report.line).to eq(1)
          expect(violation_report.message).to eq(expected_message)
        end
      end

      context "with an excluded file" do
        before do
          allow(@my_plugin).to receive(:target_files).and_return(
            [File.join(fixtures_path, "exclude_file.txt")]
          )
        end

        it "should not generate any warnings" do
          config_path = File.join(fixtures_path, "typos_config.toml")
          @my_plugin.run(config_path: config_path)

          expect(@dangerfile.status_report[:warnings]).to be_empty
        end
      end
    end
  end
end
