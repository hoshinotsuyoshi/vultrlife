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

  describe '.fetch_server_list' do
    context 'when API responds normally' do
      let(:v1_server_list) do
        File.read('spec/fixtures/v1_server_list.json')
      end

      it 'returns my servers(Hash)' do
        WebMock.stub_request(:get, 'https://api.vultr.com/v1/server/list?api_key=APIKEY')
        .to_return(body: v1_server_list)

        response = Vultrlife::Agent.fetch_server_list('APIKEY')
        expect(response).to eq(
          {
            "1356876" => {
              "os"                   => "CentOS 6 x64",
              "ram"                  => "768 MB",
              "disk"                 => "Virtual 15 GB",
              "main_ip"              => "108.61.223.121",
              "vcpu_count"           => "1",
              "location"             => "Tokyo",
              "default_password"     => "moskety!7j",
              "date_created"         => "2014-05-25 07:28:35",
              "pending_charges"      => "0.01",
              "status"               => "active",
              "cost_per_month"       => "5.00",
              "current_bandwidth_gb" => 0,
              "netmask_v4"           => "255.255.255.0",
              "gateway_v4"           => "108.61.223.1",
              "power_status"         => "running"
            }
          }
        )
      end
    end
  end

  describe '.post_create' do
    context 'given valid option' do
      context 'when API responds normally' do
        it 'returns server\'s sub_id(Hash)' do
          data =  "DCID=25"
          data << "&VPSPLANID=31"
          data << "&OSID=127"
          WebMock.stub_request(:post, 'https://api.vultr.com/v1/server/create?api_key=APIKEY')
          .with(body: data)
          .to_return(body: %q{{"SUBID" : "1312965"}})

          option = {plan: 31, region: 25, os: 127, api_key: 'APIKEY'}
          response = Vultrlife::Agent.post_create(option)
          expect(response).to eq(
            {'SUBID' => '1312965'}
          )
        end
      end
    end
  end
end