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
end
