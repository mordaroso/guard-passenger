require 'spec_helper'

describe Guard::Passenger do
  subject { Guard::Passenger.new }

  describe 'options' do

    context 'standalone' do
      it 'should be true by default' do
        subject.should be_standalone
      end

      it 'should be set to false' do
        subject = Guard::Passenger.new([], {:standalone => false})
        subject.should_not be_standalone
      end
    end

    context 'port' do
      it 'should be 3000 by default' do
        subject.port.should == 3000
      end

      it 'should be set to 1337' do
        subject = Guard::Passenger.new([], {:port => 1337})
        subject.port.should == 1337
      end
    end

    context 'env' do
      it 'should be development by default' do
        subject.env.should == 'development'
      end

      it 'should be set to production' do
        subject = Guard::Passenger.new([], {:env => 'production'})
        subject.env.should == 'production'
      end
    end

    context 'touch' do
      it 'should touch / by default' do
        subject.touch.should == '/'
      end

      it 'should touch /users/all' do
        subject = Guard::Passenger.new([], {:touch => '/users/all'})
        subject.touch.should == '/users/all'
      end

      it 'should disable touch' do
        subject = Guard::Passenger.new([], {:touch => false})
        subject.touch.should be_false
      end
    end

  end

  context 'start' do

    it 'should not call `passenger start\' command if standalone is disabled' do
      subject.should_receive(:standalone?).and_return(false)
      Guard::Passenger::Runner.should_not_receive(:start_passenger)
      subject.start
    end

    it 'should call `passenger start\' command if standalone is set' do
      Guard::Passenger::Runner.should_receive(:start_passenger).with(3000, 'development').and_return(true)
      subject.start
    end

    it 'should call `passenger start -p 1337\' command if standalone is set and port is set to 1337' do
      subject.should_receive(:port).and_return(1337)
      Guard::Passenger::Runner.should_receive(:start_passenger).with(1337, 'development').and_return(true)
      subject.start
    end

    it 'should call `passenger start -p 1337\' command if standalone is set, port is set to 1337 and environment is production' do
      subject.should_receive(:port).and_return(1337)
      subject.should_receive(:env).and_return('production')
      Guard::Passenger::Runner.should_receive(:start_passenger).with(1337, 'production').and_return(true)
      subject.start
    end

  end

  context 'stop' do

    it 'should not call `passenger stop\' command if standalone is disabled' do
      subject.should_receive(:standalone?).and_return(false)
      Guard::Passenger::Runner.should_not_receive(:stop_passenger)
      subject.stop
    end

    it 'should call `passenger stop\' command if standalone is set' do
      Guard::Passenger::Runner.should_receive(:stop_passenger).with(3000).and_return(true)
      subject.stop
    end

    it 'should call `passenger stop\' command if standalone is set and port is 1337' do
      subject.should_receive(:port).and_return(1337)
      Guard::Passenger::Runner.should_receive(:stop_passenger).with(1337).and_return(true)
      subject.stop
    end

  end

  context 'reload' do

    it 'should call `touch tmp/restart.txt\' command' do
      Guard::Passenger::Runner.should_receive(:restart_passenger).and_return(true)
      subject.should_receive(:touch_url).and_return(true)

      subject.reload.should be_true
    end

    it 'should return false if `touch tmp/restart.txt\' command fails' do
      Guard::Passenger::Runner.should_receive(:restart_passenger).and_return(false)
      subject.should_receive(:touch_url).and_return(true)
      subject.reload.should be_false
    end

    it 'should return false if touch_url fails' do
      Guard::Passenger::Runner.should_receive(:restart_passenger).and_return(true)
      subject.should_receive(:touch_url).and_return(false)
      subject.reload.should be_false
    end

  end

  context 'run_on_change' do

    it 'should call `touch tmp/restart.txt\' command' do
      Guard::Passenger::Runner.should_receive(:restart_passenger).and_return(true)
      subject.should_receive(:touch_url).and_return(true)
      subject.reload.should be_true
    end

  end

  context 'touch_url' do

    it 'should touch localhost on port 3000 and path / by default' do
      Guard::Passenger::Toucher.should_receive(:touch).with('localhost', 3000, '/').and_return(true)
      subject.send(:touch_url).should be_true
    end

    it 'should touch localhost on port 3001 and path /users/all by default' do
      subject.should_receive(:port).and_return(3001)
      subject.should_receive(:touch).exactly(2).and_return('/users/all')
      Guard::Passenger::Toucher.should_receive(:touch).with('localhost', 3001, '/users/all').and_return(true)
      subject.send(:touch_url).should be_true
    end

    it 'should touch if disabled' do
      subject.should_receive(:touch).and_return(false)
      Guard::Passenger::Toucher.should_not_receive(:touch)
      subject.send(:touch_url).should be_true
    end

  end
end
