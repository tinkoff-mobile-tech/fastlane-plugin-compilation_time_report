describe Fastlane::Actions::CompilationTimeReportAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The compilation_time_report plugin is working!")

      Fastlane::Actions::CompilationTimeReportAction.run(nil)
    end
  end
end
