module Vultrlife
  class Server
    class Configuration
      attr_accessor :region, :plan, :os, :ipxe_chain_url, :api_key

      def verify_plan(&b)
        yield Vultrlife::PlanVerifier.new
      end
    end
  end
end
