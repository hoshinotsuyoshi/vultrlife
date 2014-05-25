require 'spec_helper'
require 'json'

describe Vultrlife::Server do
  describe '.create!' do
    let(:config) do
      config = Vultrlife::Server::Configuration.new
      config.instance_eval do
        @region         = :tokyo
        @os             = :custom
        @plan           = '512 MB RAM,160 GB SATA,1.00 TB BW, Custom ISO'
        @ipxe_chain_url = 'http://example.com/script.txt'
      end
      config
    end

    let(:v1_plans_json) do
      JSON.parse File.read('spec/fixtures/v1_plans_list')
    end

    context 'given a instance of Vultrlife::Server::Configuration' do
      it 'check plans, availability, region' do
        Vultrlife::Agent.should_receive(:fetch_all_plans).and_return(v1_plans_json)
        #FIXME

        Vultrlife::Server.create!(config)
      end
    end
  end
end
