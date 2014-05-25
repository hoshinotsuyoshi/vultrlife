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
      it 'yields Vultrlife::Server::Configuration' do
        config = double(:config)
        Vultrlife::Server::Configuration.should_receive(:new).and_return(config)
        config.should_receive(:setting_a=).with('setting_a')
        config.should_receive(:setting_b=).with('setting_b')

        server = account.server_create! do |server|
          server.setting_a = 'setting_a'
          server.setting_b = 'setting_b'
        end
      end

      it 'returns a new Vultrlife::Server' do
        config = double(:config)
        Vultrlife::Server::Configuration.should_receive(:new).with(account).and_return(config)
        config.should_receive(:setting_a=).with('setting_a')
        config.should_receive(:setting_b=).with('setting_b')

        server = account.server_create! do |server|
          server.setting_a = 'setting_a'
          server.setting_b = 'setting_b'
        end

        server.should be_a(Vultrlife::Server)
      end
    end
  end
end
