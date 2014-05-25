require 'spec_helper'

describe Vultrlife::Agent do
  describe '.fetch_all_plans' do
    context 'when API responds normally' do
      let(:v1_plans) do
        File.read('spec/fixtures/v1_plans.json')
      end

      it 'returns plans(Hash)' do
        WebMock.stub_request(:get, 'https://api.vultr.com/v1/plans/list')
        .to_return(:body => v1_plans)

        response = Vultrlife::Agent.fetch_all_plans
        expect(response.keys.sort).to eq(
          %w(11 12 13 27 28 29 3 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 60 61 8)
        )
      end
    end
  end

  describe '.fetch_all_regions' do
    context 'when API responds normally' do
      let(:v1_regions) do
        File.read('spec/fixtures/v1_regions.json')
      end

      it 'returns regions(Hash)' do
        WebMock.stub_request(:get, 'https://api.vultr.com/v1/regions/list')
        .to_return(:body => v1_regions)

        response = Vultrlife::Agent.fetch_all_regions
        expect(response.keys.sort).to eq(
          %w(1 19 2 24 25 3 4 5 6 7 8 9)
        )
      end
    end
  end

  describe '.fetch_availability' do
    context 'when API responds normally' do
      let(:v1_availability_of_tokyo) do
        File.read('spec/fixtures/v1_availability_of_tokyo.json')
      end

      it 'returns available plans(Array)' do
        WebMock.stub_request(:get, 'https://api.vultr.com/v1/regions/availability?DCID=25')
        .to_return(:body => v1_availability_of_tokyo)

        response = Vultrlife::Agent.fetch_availability('25') # 25 -> tokyo
        expect(response.sort).to eq(
          %w(31 32 33 34 47 48 49 50 51 52 53 54 55 8)
        )
      end
    end
  end
end
