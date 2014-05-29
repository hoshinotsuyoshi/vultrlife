require 'spec_helper'
require 'json'

describe Vultrlife::Server do
  describe '.show_servers' do
    context 'when some servers exist' do
      let(:account) do
        Vultrlife::Account.new.configure do |config|
          config.api_key = 'APIKEY'
        end
      end
      it 'returns Server array' do
        server_hash = {"1356867"=>
                       {"os"=>"CentOS 6 x64",
                        "ram"=>"768 MB",
                        "disk"=>"Virtual 15 GB",
                        "main_ip"=>"108.61.223.121",
                        "vcpu_count"=>"1",
                        "location"=>"Tokyo",
                        "default_password"=>"moskety!7j",
                        "date_created"=>"2014-05-25 07:28:35",
                        "pending_charges"=>"0.02",
                        "status"=>"active",
                        "cost_per_month"=>"5.00",
                        "current_bandwidth_gb"=>0.028,
                        "netmask_v4"=>"255.255.255.0",
                        "gateway_v4"=>"108.61.223.1",
                        "power_status"=>"running"}
        }
        Vultrlife::Agent.should_receive(:fetch_server_list).with('APIKEY').and_return(server_hash)

        servers = Vultrlife::Server.show_servers(account)
        expect(servers.size).to eq 1
        expect(servers.first).to include("os"=>"CentOS 6 x64")
        expect(servers.first).to be_a Vultrlife::Server
      end
    end

    context 'when no servers exist' do
      it 'returns []' do
        pending
      end
    end
  end

  describe '#destroy!' do
    context 'when successfully' do
      it 'returns subid' do
        account = Vultrlife::Account.new.configure do |config|
          config.api_key = 'API_KEY'
        end
        server  = Vultrlife::Server.new('111111', account)

        Vultrlife::Agent.should_receive(:post_destroy).with(subid: '111111', api_key: 'API_KEY')
        expect(server.destroy!).to eq '111111'
        expect(server).to be_destroyed
      end
    end
  end

  describe '.create!' do
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

    let(:centos_config) do
      account = Vultrlife::Account.new.configure do |config|
        config.api_key = 'API_KEY'
      end
      centos_config = Vultrlife::Server::Configuration.new(account)
      centos_config.instance_eval do
        @plan           = '768 MB RAM,15 GB SSD,0.10 TB BW'
        @region         = :tokyo
        @os             = 'CentOS 6 x64'
        @api_key        = 'API_KEY'
      end
      centos_config
    end

    context 'given a config for CentOS' do
      context 'the instance has a valid specific @plan, @region, @os' do
        it 'check plans, availability, region' do
          Vultrlife::Agent.should_receive(:fetch_all_plans).and_return(v1_plans)
          Vultrlife::Agent.should_receive(:fetch_all_regions).and_return(v1_regions)
          Vultrlife::Agent.should_receive(:fetch_all_oss).and_return(v1_os)
          Vultrlife::Agent.should_receive(:fetch_availability).with('25').and_return(v1_availability_of_tokyo)
          Vultrlife::Agent.should_receive(:post_create).with(plan: 31, region: 25, os: 127, api_key: 'API_KEY').and_return("SUBID" => "1312965")

          server = Vultrlife::Server.create!(centos_config)
          expect(server.subid).to eq(1312965)
        end
      end
    end

    let(:custom_os_config) do
      account = Vultrlife::Account.new.configure do |config|
        config.api_key = 'API_KEY'
      end
      custom_os_config = Vultrlife::Server::Configuration.new(account)
      custom_os_config.instance_eval do
        @plan           = '768 MB RAM,15 GB SSD,0.10 TB BW, Custom ISO'
        @region         = :tokyo
        @os             = 'Custom'
        @api_key        = 'API_KEY'
        @ipxe_chain_url = 'http://example.com/script.txt'
      end
      custom_os_config
    end

    context 'given a config for custom_os' do
      context 'the instance has a valid specific @plan, @region, @os' do
        it 'check plans, availability, region' do
          Vultrlife::Agent.should_receive(:fetch_all_plans).and_return(v1_plans)
          Vultrlife::Agent.should_receive(:fetch_all_regions).and_return(v1_regions)
          Vultrlife::Agent.should_receive(:fetch_all_oss).and_return(v1_os)
          Vultrlife::Agent.should_receive(:fetch_availability).with('25').and_return(v1_availability_of_tokyo)
          Vultrlife::Agent.should_receive(:post_create)
          .with(plan: 52, region: 25, os: 159, api_key: 'API_KEY',ipxe_chain_url: 'http://example.com/script.txt')
          .and_return("SUBID" => "1312965")

          server = Vultrlife::Server.create!(custom_os_config)
          expect(server.subid).to eq(1312965)
        end
      end
    end
  end
end
