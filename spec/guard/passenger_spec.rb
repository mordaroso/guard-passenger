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

    context 'env' do
      it 'should be development by default' do
        subject.env.should eql 'development'
      end

      it 'should be set to production' do
        subject = Guard::Passenger.new([], {:env => 'production'})
        subject.env.should eql 'production'
      end
    end

  end

  context 'start' do

    it 'should not call `passenger start\' command' do
      Guard::RSpec::Runner.should_not_receive(:start_passenger)
      subject.start
    end

    it 'should call `passenger start\' command if standalone is set' do
      subject.should_receive(:standalone?).and_return(true)
      Guard::Passenger::Runner.should_receive(:start_passenger).with(3000, 'development').and_return(true)
      subject.start
    end

    it 'should call `passenger start -p 1337\' command if standalone is set and port is set to 1337' do
      subject.should_receive(:standalone?).and_return(true)
      subject.should_receive(:port).and_return(1337)
      Guard::Passenger::Runner.should_receive(:start_passenger).with(1337, 'development').and_return(true)
      subject.start
    end

    it 'should call `passenger start -p 1337\' command if standalone is set, port is set to 1337 and environment is production' do
      subject.should_receive(:standalone?).and_return(true)
      subject.should_receive(:port).and_return(1337)
      subject.should_receive(:env).and_return('production')
      Guard::Passenger::Runner.should_receive(:start_passenger).with(1337, 'production').and_return(true)
      subject.start
    end

  end

  context 'stop' do

    it 'should not call `passenger stop\' command' do
      Guard::RSpec::Runner.should_not_receive(:stop_passenger)
      subject.stop
    end

    it 'should call `passenger stop\' command if standalone is set' do
      subject.should_receive(:standalone?).and_return(true)
      Guard::Passenger::Runner.should_receive(:stop_passenger).and_return(true)
      subject.stop
    end

  end

  context 'reload' do

    it 'should call `touch tmp/restart.txt\' command' do
      Guard::Passenger::Runner.should_receive(:restart_passenger).and_return(true)
      subject.reload.should be_true
    end

    it 'should return false if `touch tmp/restart.txt\' command fail' do
      Guard::Passenger::Runner.should_receive(:restart_passenger).and_return(false)
      subject.reload.should be_false
    end

  end

  context 'run_on_change' do

    it 'should call `touch tmp/restart.txt\' command' do
      Guard::Passenger::Runner.should_receive(:restart_passenger).and_return(true)
      subject.reload.should be_true
    end

  end
end
