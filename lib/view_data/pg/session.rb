module ViewData
  module PG
    class Session < MessageStore::Postgres::Session
      settings.each do |setting_name|
        setting setting_name
      end

      def self.build(settings: nil)
        settings ||= Settings.instance

        super(settings: settings)
      end

      def self.build_connection(*)
        connection = super

        type_map_for_results = connection.type_map_for_results

        name_decoder = ::PG::TextDecoder::String.new({
          :oid => 19,
          :name => 'name'
        })

        regproc_decoder = ::PG::TextDecoder::String.new({
          :oid => 24,
          :name => 'regproc'
        })

        type_map_for_results.add_coder(name_decoder)
        type_map_for_results.add_coder(regproc_decoder)

        connection.type_map_for_queries = ::PG::BasicTypeMapForQueries.new(connection)

        connection
      end
    end
  end
end
