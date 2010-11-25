require 'spec_helper'

describe Guard::Passenger::Pinger do
  
  describe '.ping' do
    before(:each) do
      Net::HTTP.should_receive(:start).with('localhost', 3000).and_yield(@http_object = mock('request'))
    end
    
    describe "default" do
      before(:each) do
        @http_object.should_receive(:head).with('/').and_return(@http_response = mock('response'))
      end
      
      it "should ping '/'" do
        @http_response.should_receive(:=~).with(Net::HTTPServerError).and_return(false)
        subject.ping('localhost', 3000)
        wait_for_thread_end
      end
      
      context "successful ping" do
        it 'should display an info message' do
          @http_response.should_receive(:=~).with(Net::HTTPServerError).and_return(false)
          Guard::Notifier.should_receive(:notify).with('Passenger is not running!', :title => "Passenger", :image => :failed)
          subject.ping('localhost', 3000)
          wait_for_thread_end
        end
      end
      
      context "failing ping" do
        it 'should display an error message' do
          @http_response.should_receive(:=~).with(Net::HTTPServerError).and_return(true)
          Guard::Notifier.should_receive(:notify).with('Passenger is running.', :title => "Passenger", :image => :success)
          subject.ping('localhost', 3000)
          wait_for_thread_end
        end
      end
    end
    
    describe "custom path" do
      context "not beginning with '/'" do
        before(:each) do
          @http_object.should_receive(:head).with('/foo').and_return(@http_response = mock('response'))
          @http_response.should_receive(:=~).with(Net::HTTPServerError)
        end
        
        context "successful ping" do
          it 'should display an info message' do
            subject.ping('localhost', 3000, 'foo')
            wait_for_thread_end
          end
        end
      end
      
      context "not beginning with '/'" do
        before(:each) do
          @http_object.should_receive(:head).with('/foo').and_return(@http_response = mock('response'))
          @http_response.should_receive(:=~).with(Net::HTTPServerError)
        end
        
        context "successful ping" do
          it 'should display an info message' do
            subject.ping('localhost', 3000, '/foo')
            wait_for_thread_end
          end
        end
      end
    end
    
  end
  
end

def wait_for_thread_end
  Thread.list.each { |t| t.join unless t == Thread.main }
end