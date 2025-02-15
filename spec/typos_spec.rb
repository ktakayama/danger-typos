# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerTypos do
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
            [File.expand_path("fixtures/no_warnings.txt", __dir__)]
          )
        end

        it "warns nothing" do
          @my_plugin.run

          expect(@dangerfile.status_report[:warnings]).to eq([])
        end
      end

      context "with a file included some errors" do
        let(:expected_message) { "`Udate` should be `Update`" }
        before do
          allow(@my_plugin).to receive(:target_files).and_return(
            [File.expand_path("fixtures/error.txt", __dir__)]
          )
        end

        it "should returns error" do
          @my_plugin.run

          expect(@dangerfile.status_report[:warnings]).to eq([expected_message])

          violation_report = @dangerfile.violation_report[:warnings].first
          expect(violation_report.file).to eq(File.expand_path("fixtures/error.txt", __dir__))
          expect(violation_report.line).to eq(1)
          expect(violation_report.message).to eq(expected_message)
        end
      end
    end
  end
end
