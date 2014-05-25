require 'spec_helper'
require 'json'

describe Vultrlife::Server do
  describe '.create!' do
    let(:config) do
      config = Vultrlife::Server::Configuration.new
      config.instance_eval do
        @plan           = '2048 MB RAM,40 GB SSD,0.30 TB BW'
        @region         = :tokyo
        @ipxe_chain_url = 'http://example.com/script.txt'
      end
      config
    end

    let(:v1_plans) do
      JSON.parse File.read('spec/fixtures/v1_plans.json')
    end

    let(:v1_regions) do
      JSON.parse File.read('spec/fixtures/v1_regions.json')
    end

    let(:v1_availability_of_tokyo) do
      JSON.parse File.read('spec/fixtures/v1_availability_of_tokyo.json')
    end

    context 'given a instance of Vultrlife::Server::Configuration' do
      context 'the instance has a valid specific @plan' do
        it 'check plans, availability, region' do
          Vultrlife::Agent.should_receive(:fetch_all_plans).and_return(v1_plans)
          Vultrlife::Agent.should_receive(:fetch_all_regions).and_return(v1_regions)

          Vultrlife::Agent.should_receive(:fetch_availability).with('25').and_return(v1_availability_of_tokyo)

          Vultrlife::Server.create!(config)
        end
      end
    end
  end
end
