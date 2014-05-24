require 'spec_helper'

describe Vultrlife do
  describe '.configure' do
    context 'given no block' do
      it 'raises error' do
        expect{ Vultrlife.configure }.to raise_error
      end
    end

    context 'given a block with api_key' do
      it 'sets @api_key' do
        expect do
          Vultrlife.configure do |config|
            config.api_key = 'my_api_key'
          end
        end.to change{ Vultrlife.instance_variable_get(:@api_key) }
        .from(nil).to('my_api_key')
      end
    end
  end
end
