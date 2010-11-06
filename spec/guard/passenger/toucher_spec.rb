require 'spec_helper'

describe Guard::Passenger::Toucher do
  subject { Guard::Passenger::Toucher }

  context 'url touch' do

    it 'should touch http://localhost:3000/ and return 200' do
      http_mock = mock 'request'
      http_mock.stub(:head).with('/').and_return({'status' => '200'})
      Net::HTTP.should_receive(:start).with('localhost', 3000).and_yield(http_mock)
      subject.touch('localhost', 3000, '/').should be true
    end

    it 'should return false if touch returns 500' do
      http_mock = mock 'request'
      http_mock.stub(:head).with('/').and_return({'status' => '500'})
      Net::HTTP.should_receive(:start).with('localhost', 3000).and_yield(http_mock)
      subject.touch('localhost', 3000, '/').should be false
    end

    it 'should return false if touch raises exception' do
      Net::HTTP.should_receive(:start).with('localhost', 3000).and_raise('Connection refused')
      subject.touch('localhost', 3000, '/').should be false
    end

  end
end