require 'spec_helper'

describe Vultrlife::Account do
  let(:account){ Vultrlife::Account.new }

  describe '#configure' do
    context 'given no block' do
      it 'raises error' do
        expect{ account.configure }.to raise_error
      end
    end

    context 'given a block with api_key' do
      it 'sets @api_key' do
        expect do
          account.configure do |config|
            config.api_key = 'my_api_key'
          end
        end.to change {
          config = account.instance_variable_get(:@config)
          config.instance_variable_get(:@api_key)
        }.from(nil).to('my_api_key')
      end
    end
  end

  describe '#servers' do
    context 'when the account has no servers' do
      it 'returns empty' do
        expect( account.servers ).to be_empty
      end
    end
  end

  describe '#server_create!' do
    context 'given no block' do
      it 'raises error' do
        expect{ account.server_create! }.to raise_error
      end
    end

    context 'given a block' do
      it 'yields Vultrlife::Account::Server::Configuration' do
        config = double(:config)
        Vultrlife::Account::Server::Configuration.should_receive(:new).and_return(config)
        config.should_receive(:setting_a=).with('setting_a')
        config.should_receive(:setting_b=).with('setting_b')

        account.server_create! do |server|
          server.setting_a = 'setting_a'
          server.setting_b = 'setting_b'
        end
      end
    end
  end
end

describe Vultrlife::Account::Server::Configuration do
  let(:config){ Vultrlife::Account::Server::Configuration.new }

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
end
