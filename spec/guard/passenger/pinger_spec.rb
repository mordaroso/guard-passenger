require 'spec_helper'

describe Guard::Passenger::Pinger do
  
  describe '.ping' do
    before(:each) do
      Net::HTTP.should_receive(:start).with('localhost', 3000).and_yield(http_object = mock('request'))
      http_object.should_receive(:head).with('/').and_return(@http_response = mock('response'))
    end
    
    context "successful ping" do
      it 'should display an info message' do
        @http_response.should_receive(:=~).with(Net::HTTPServerError).and_return(false)
        Guard::UI.should_receive(:info).with('Passenger is running.')
        subject.ping('localhost', 3000)
        wait_for_thread_end
      end
    end
    
    context "failing ping" do
      it 'should display an error message' do
        @http_response.should_receive(:=~).with(Net::HTTPServerError).and_return(true)
        Guard::UI.should_receive(:error).with('Passenger is not running.')
        subject.ping('localhost', 3000)
        wait_for_thread_end
      end
    end
  end
  
end

def wait_for_thread_end
  Thread.list.each { |t| t.join unless t == Thread.main }
end