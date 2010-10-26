require 'spec_helper'

describe Guard::Passenger do
  subject { Guard::Passenger.new }

  describe 'options' do

    context 'standalone' do
      it 'should be false by default' do
        subject.should_not be_standalone
      end

      it 'should be set to true' do
        subject = Guard::Passenger.new([], {:standalone => true})
        subject.should be_standalone
      end
    end

    context 'port' do
      it 'should be 3000 by default' do
        subject.port.should be 3000
      end

      it 'should be set to 1337' do
        subject = Guard::Passenger.new([], {:port => 1337})
        subject.port.should be 1337
      end
    end

  end

  context 'start' do

    it 'should not call `passenger start\' command' do
      subject.should_not_receive(:system).with('passenger start -p 3000 -d')
      subject.start
    end

    it 'should call `passenger start\' command if standalone is set' do
      subject.should_receive(:standalone?).and_return(true)
      subject.should_receive(:system).with('passenger start -p 3000 -d')
      subject.start
    end

    it 'should call `passenger start -p 1337\' command if standalone is set and port is set to 1337' do
      subject.should_receive(:standalone?).and_return(true)
      subject.should_receive(:port).exactly(2).and_return(1337)
      subject.should_receive(:system).with('passenger start -p 1337 -d')
      subject.start
    end

  end

  context 'stop' do

    it 'should not call `passenger stop\' command' do
      subject.should_not_receive(:system).with('passenger stop')
      subject.stop
    end

    it 'should call `passenger stop\' command if standalone is set' do
      subject.should_receive(:standalone?).and_return(true)
      subject.should_receive(:system).with('passenger stop')
      subject.stop
    end

  end

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
