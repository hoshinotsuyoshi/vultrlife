require 'spec_helper'

describe Vultrlife::Account do
  let(:account){ Vultrlife::Account.new }

  describe '#servers' do
    it 'calls Vultrlife::Server.show_servers' do
      expect(Vultrlife::Server).to receive(:show_servers).with(account)

      account.servers
    end
  end

  describe '#server_create!' do
    context 'given no block' do
      it 'raises error' do
        expect{ account.server_create! }.to raise_error
      end
    end

    def server_create!(&b)
      config = Server::Configuration.new(self)
      yield config
      Server.create!(config)
    end

    context 'given a block' do
      it 'yields Vultrlife::Server::Configuration' do
        config = double(:config)
        expect(Vultrlife::Server::Configuration).to receive(:new).with(account).and_return(config)
        expect(config).to receive(:setting_a=).with('setting_a')
        expect(config).to receive(:setting_b=).with('setting_b')
        config.stub(:plan)
        expect(Vultrlife::Server).to receive(:create!).with(config)

        server = account.server_create! do |server|
          server.setting_a = 'setting_a'
          server.setting_b = 'setting_b'
        end
      end

      it 'returns a new Vultrlife::Server' do
        pending('this spec must be feature test')
        config = double(:config)
        expect(Vultrlife::Server::Configuration).to receive(:new).with(account).and_return(config)
        expect(config).to receive(:setting_a=).with('setting_a')
        expect(config).to receive(:setting_b=).with('setting_b')
        config.stub(:plan)
        expect(Vultrlife::Server).to receive(:create!).with(config)

        server = account.server_create! do |server|
          server.setting_a = 'setting_a'
          server.setting_b = 'setting_b'
        end

        server.should be_a(Vultrlife::Server)
      end
    end
  end
end
