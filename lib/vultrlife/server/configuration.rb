module Vultrlife
  class Server
    class Configuration
      attr_accessor :region, :plan, :os, :ipxe_chain_url

      def verify_plan(&b)
        yield Vultrlife::PlanVerifier.new
      end
    end
  end
end
