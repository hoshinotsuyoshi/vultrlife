require 'spec_helper'

describe Vultrlife::Server::Configuration do
  let(:config){ Vultrlife::Server::Configuration.new }

  describe '#region=' do
    context 'given :tokyo' do
      it 'sets @region :tokyo' do
        expect do
          config.region= :tokyo
        end.to change {
          config.instance_variable_get(:@region)
        }.from(nil).to(:tokyo)
      end
    end
  end

  describe '#plan=' do
    context 'given :starter' do
      it 'sets @plan :starter' do
        expect do
          config.plan = :starter
        end.to change {
          config.instance_variable_get(:@plan)
        }.from(nil).to(:starter)
      end
    end
  end

  describe '#os=' do
    context 'given :custom' do
      it 'sets @os :custom' do
        expect do
          config.os = :custom
        end.to change {
          config.instance_variable_get(:@os)
        }.from(nil).to(:custom)
      end
    end
  end

  describe '#ipxe_chain_url=' do
    context 'given url' do
      it 'sets @ipxe_chain_url the url' do
        expect do
          config.ipxe_chain_url = 'http://example.com/script.txt'
        end.to change {
          config.instance_variable_get(:@ipxe_chain_url)
        }.from(nil).to('http://example.com/script.txt')
      end
    end
  end

  describe '#verify_plan' do
    context 'given block' do
      it 'yields Vultrlife::PlanVerifier' do
        verifier = double(:verifier)
        Vultrlife::PlanVerifier.should_receive(:new).and_return(verifier)
        verifier.should_receive(:costs_at_most=).with(7)
        verifier.should_receive(:vcpu_count=   ).with(1)
        verifier.should_receive(:ram=          ).with(1024)
        verifier.should_receive(:disk=         ).with(30)
        verifier.should_receive(:bandwidth=    ).with(2)

        config.verify_plan do |verify|
          verify.costs_at_most = 7
          verify.vcpu_count    = 1
          verify.ram           = 1024
          verify.disk          = 30
          verify.bandwidth     = 2
        end
      end
    end
  end
end


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
