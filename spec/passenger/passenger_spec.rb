require 'spec_helper'

describe Guard::Passenger do
  subject { Guard::Passenger.new }

  context 'reload' do

    it 'should call `touch tmp/restart.txt\' command' do
      subject.should_receive(:system).with('touch tmp/restart.txt').and_return(true)
      subject.reload.should be_true
    end

    it 'should return false if `touch tmp/restart.txt\' command fail' do
      subject.should_receive(:system).with('touch tmp/restart.txt').and_return(false)
      subject.reload.should be_false
    end

  end

  context 'run_on_change' do

    it 'should call `touch tmp/restart.txt\' command' do
      subject.should_receive(:system).with('touch tmp/restart.txt').and_return(true)
      subject.reload.should be_true
    end

  end
end