require 'spec_helper'
require 'json'

describe Vultrlife::Server do
  describe '.create!' do
    let(:config) do
      config = Vultrlife::Server::Configuration.new
      config.instance_eval do
        @plan           = '768 MB RAM,15 GB SSD,0.10 TB BW'
        @region         = :tokyo
        @os             = 'CentOS 6 x64'
      end
      config
    end

    let(:v1_plans) do
      JSON.parse File.read('spec/fixtures/v1_plans.json')
    end

    let(:v1_regions) do
      JSON.parse File.read('spec/fixtures/v1_regions.json')
    end

    let(:v1_os) do
      JSON.parse File.read('spec/fixtures/v1_os.json')
    end

    let(:v1_availability_of_tokyo) do
      JSON.parse File.read('spec/fixtures/v1_availability_of_tokyo.json')
    end

    context 'given a instance of Vultrlife::Server::Configuration' do
      context 'the instance has a valid specific @plan, @region, @os' do
        it 'check plans, availability, region' do
          Vultrlife::Agent.should_receive(:fetch_all_plans).and_return(v1_plans)
          Vultrlife::Agent.should_receive(:fetch_all_regions).and_return(v1_regions)
          Vultrlife::Agent.should_receive(:fetch_all_os).and_return(v1_os)
          Vultrlife::Agent.should_receive(:fetch_availability).with('25').and_return(v1_availability_of_tokyo)
          Vultrlife::Agent.should_receive(:post_create).with(plan: 31, region: 25, os: 127).and_return("SUBID" => "1312965")

          server = Vultrlife::Server.create!(config)
          expect(server.subid).to eq(1312965)
        end
      end
    end
  end
end
