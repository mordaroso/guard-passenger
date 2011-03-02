require 'spec_helper'

describe Guard::Passenger::Pinger do

  describe '.ping' do
    before(:each) do
      Net::HTTP.should_receive(:start).any_number_of_times.and_yield(@http_object = mock('request'))
    end

    after(:each) do
      wait_for_thread_end
    end

    describe "default" do
      before(:each) do
        @http_object.should_receive(:head).with('/').and_return(@http_response = mock('response'))
      end

      it "should ping '/'" do
        @http_response.should_receive(:is_a?).with(Net::HTTPServerError).and_return(false)
        subject.ping('0.0.0.0', '3000', true)
      end

      context "successful ping" do
        it 'should notify the problem' do
          @http_response.should_receive(:is_a?).with(Net::HTTPServerError).and_return(false)
          Guard::Notifier.should_receive(:notify).with('Passenger is running.', :title => "Passenger", :image => :success)
          subject.ping('0.0.0.0', '3000', true)
        end

        context "successful ping without notification" do
          it 'should notify the problem' do
            Guard::Notifier.should_not_receive(:notify)
            subject.ping('0.0.0.0', '3000', false)
          end
        end
      end

      context "failing ping" do
        it 'should notify that it is ok' do
          @http_response.should_receive(:is_a?).with(Net::HTTPServerError).and_return(true)
          Guard::Notifier.should_receive(:notify).with('Passenger is not running!', :title => "Passenger", :image => :failed)
          subject.ping('0.0.0.0', '3000', true)
        end
      end

      context "failing ping without notification" do
        it 'should notify that it is ok' do
          Guard::Notifier.should_not_receive(:notify)
          subject.ping('0.0.0.0', '3000', false)
        end
      end
    end

    describe "custom path" do
      context "not beginning with '/'" do
        before(:each) do
          @http_object.should_receive(:head).with('/foo').and_return(@http_response = mock('response'))
          @http_response.should_receive(:is_a?).with(Net::HTTPServerError)
        end

        context "successful ping" do
          it 'should display an info message' do
            subject.ping('0.0.0.0', '3000', true, 'foo')
          end
        end
      end

      context "not beginning with '/'" do
        before(:each) do
          @http_object.should_receive(:head).with('/foo').and_return(@http_response = mock('response'))
          @http_response.should_receive(:is_a?).with(Net::HTTPServerError)
        end

        context "successful ping" do
          it 'should display an info message' do
            subject.ping('0.0.0.0', '3000', true, '/foo')
          end
        end
      end
    end

  end

end

def wait_for_thread_end
  Thread.list.each { |t| t.join unless t == Thread.main }
end
