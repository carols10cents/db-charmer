module DbCharmer
  module ActiveRecord
    module Sharding

      def self.extended(model)
        model.cattr_accessor(:sharded_connection)
      end

      def shard_for(key, proxy_target = nil, &block)
        raise ArgumentError, "No sharded connection configured!" unless sharded_connection
        conn = sharded_connection.sharder.shard_for_key(key)
        on_db(conn, proxy_target, &block)
      end

      # Run on default shard (if supported by the sharding method)
      def on_default_shard(proxy_target = nil, &block)
        raise ArgumentError, "No sharded connection configured!" unless sharded_connection

        if sharded_connection.support_default_shard?
          shard_for(:default, proxy_target, &block)
        else
          raise ArgumentError, "This model's sharding method does not support default shard"
        end
      end

      # Enumerate shards
      def on_each_shard(proxy_target = nil, &block)
        raise ArgumentError, "No sharded connection configured!" unless sharded_connection

        conns = sharded_connection.shard_connections
        raise ArgumentError, "This model's sharding method does not support shards enumeration" unless conns

        conns.each do |conn|
          on_db(conn, proxy_target, &block)
        end
      end

      module InstanceMethods
        def shard_for(key, proxy_target = nil, &block)
          proxy_target ||= self
          self.class.shard_for(key, proxy_target, &block)
        end

        def on_default_shard(proxy_target = nil, &block)
          proxy_target ||= self
          self.class.on_default_shard(proxy_target, &block)
        end
      end

    end
  end
end
