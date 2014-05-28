module Vultrlife
  class Server < Hash
    class Configuration
      attr_accessor :region, :plan, :os, :ipxe_chain_url, :api_key

      def initialize(account)
        api_key = account.config.api_key
      end

      def verify_plan(&b)
        yield Vultrlife::PlanVerifier.new
      end
    end
  end
end
