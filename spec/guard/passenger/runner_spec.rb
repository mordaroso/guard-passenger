require 'spec_helper'

describe Guard::Passenger::Runner do
  subject { Guard::Passenger::Runner }

  context 'passenger start' do

    it 'should start passenger with port 3000 and development environment' do
      subject.should_receive(:system).with('passenger start -p 3000 -d -e development').and_return(true)
      subject.should_receive(:gem).with("passenger", ">=3.0.0").and_return(true)
      subject.start_passenger(3000, 'development').should be_true
    end

    it 'should start passenger with port 3000 and production environment' do
      subject.should_receive(:system).with('passenger start -p 3000 -d -e production').and_return(true)
      subject.should_receive(:gem).with("passenger", ">=3.0.0").and_return(true)
      subject.start_passenger(3000, 'production').should be_true
    end

    it 'should start passenger with port 1337' do
      subject.should_receive(:system).with('passenger start -p 1337 -d -e development').and_return(true)
      subject.should_receive(:gem).with("passenger", ">=3.0.0").and_return(true)
      subject.start_passenger(1337, 'development').should be_true
    end

    it 'should fail to start passenger with port 1' do
      subject.should_receive(:system).with('passenger start -p 1 -d -e development').and_return(false)
      subject.should_receive(:gem).with("passenger", ">=3.0.0").and_return(true)
      subject.start_passenger(1, 'development').should be_false
    end

    it 'should fail to start passenger without passenger 3 installed' do
      subject.should_not_receive(:system).with('passenger start -p 3000 -d -e development')
      subject.should_receive(:passenger_standalone_installed?).and_return(false)
      subject.start_passenger(3000, 'development').should be_false
    end

  end

  context 'check for passenger standalone' do
    it 'should not have passenger >= 3 installed' do
      subject.should_receive(:gem).with("passenger", ">=3.0.0").and_raise(Gem::LoadError)
      subject.passenger_standalone_installed?.should be_false
    end

    it 'should have passenger >= 3 installed' do
      subject.should_receive(:gem).with("passenger", ">=3.0.0").and_return(true)
      subject.passenger_standalone_installed?.should be_true
    end
  end

  context 'passenger stop' do

    it 'should stop passenger' do
      subject.should_receive(:system).with('passenger stop').and_return(true)
      subject.stop_passenger.should be_true
    end

    it 'should fail to stop passenger' do
      subject.should_receive(:system).with('passenger stop').and_return(false)
      subject.stop_passenger.should be_true
    end

  end

  context 'passenger restart' do

    it 'should restart passenger' do
      subject.should_receive(:system).with('touch tmp/restart.txt').and_return(true)
      subject.restart_passenger.should be_true
    end

    it 'should fail to restart passenger' do
      subject.should_receive(:system).with('touch tmp/restart.txt').and_return(false)
      subject.restart_passenger.should be_false
    end

  end
end
