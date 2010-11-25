require 'spec_helper'

describe Guard::Passenger do
  
  describe 'options' do
    describe 'standalone' do
      it 'should be true by default' do
        subject = Guard::Passenger.new([])
        subject.should be_standalone
      end
      
      it 'should be true if set to true' do
        subject = Guard::Passenger.new([], { :standalone => true })
        subject.should be_standalone
      end
      
      it 'should be false if set so' do
        subject = Guard::Passenger.new([], { :standalone => false })
        subject.should_not be_standalone
      end
    end
    
    describe 'port' do
      it 'should be 3000 by default' do
        subject = Guard::Passenger.new([])
        subject.port.should == 3000
      end
      
      it 'should be set to 1337' do
        subject = Guard::Passenger.new([], { :port => 1337 })
        subject.port.should == 1337
      end
    end
    
    describe 'env' do
      it 'should be development by default' do
        subject = Guard::Passenger.new([])
        subject.env.should == 'development'
      end
      
      it 'should be set to production' do
        subject = Guard::Passenger.new([], { :env => 'production' })
        subject.env.should == 'production'
      end
    end
    
    describe 'touch' do
      it "should display a message when passing the former :touch option" do
        Guard::UI.should_receive(:info).with("Warning: The :touch option has been replaced by the :ping option, usage is still the same.")
        Guard::Passenger.new([], { :touch => false })
      end
    end
    
    describe 'ping' do
      it 'should be false by default' do
        subject = Guard::Passenger.new([])
        subject.ping.should be_false
      end
      
      it 'should be false if set so' do
        subject = Guard::Passenger.new([], { :ping => false })
        subject.ping.should be_false
      end
      
      it 'should be true if set so' do
        subject = Guard::Passenger.new([], { :ping => true })
        subject.ping.should == '/'
      end
      
      it 'should be true if set to "foo"' do
        subject = Guard::Passenger.new([], { :ping => 'foo' })
        subject.ping.should == 'foo'
      end
    end
  end
  
  describe '#start' do
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
  
  describe '#stop' do
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
  
  %w[reload run_on_change].each do |method|
    describe "##{method}" do
      before(:each) do
        Guard::Passenger::Runner.stub(:restart_passenger)
      end
      
      it "should not call Pinger.ping by default" do
        Guard::Passenger::Pinger.should_not_receive(:ping)
        subject.send(method)
      end
      
      it 'should call `touch tmp/restart.txt\' command' do
        Guard::Passenger::Runner.should_receive(:restart_passenger)
        subject.send(method)
      end
      
      it 'should return true if `touch tmp/restart.txt\' command succeeds' do
        Guard::Passenger::Runner.stub(:restart_passenger).and_return(true)
        subject.send(method).should be_true
      end
      
      it 'should return false if `touch tmp/restart.txt\' command fails' do
        Guard::Passenger::Runner.stub(:restart_passenger).and_return(false)
        subject.send(method).should be_false
      end
      
      it 'should ping localhost:3000/ if ping is set to true' do
        subject = Guard::Passenger.new([], { :ping => true })
        Guard::Passenger::Pinger.should_receive(:ping).with('localhost', 3000, '/')
        subject.send(method)
      end
    end
  end

end