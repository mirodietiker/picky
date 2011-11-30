module Picky

  module Backends

    class SQLite

      class Basic

        include Helpers::File

        attr_reader :cache_path, :db

        def initialize cache_path, options = {}
          @cache_path   = "#{cache_path}.sqlite3"
          @empty        = options[:empty]
          @initial      = options[:initial]
          @self_indexed = options[:self_indexed]

          lazily_initialize_client
        end

        def initial
          @initial && @initial.clone || (@self_indexed ? self.reset : {})
        end

        def empty
          @empty && @empty.clone || (@self_indexed ? self.reset.asynchronous : {})
        end

        def dump internal
          dump_sqlite internal unless @self_indexed
          self
        end

        def load
          self
        end

        def clear
          db.execute 'delete from key_value'
        end

        def lazily_initialize_client
          @db ||= SQLite3::Database.new cache_path
        end

        def dump_sqlite internal
          reset

          transaction do
            # Note: Internal structures need to
            #       implement each.
            #
            internal.each do |key, value|
              encoded_value = Yajl::Encoder.encode value
              db.execute 'insert into key_value values (?,?)', key.to_s, encoded_value
            end
          end
        end

        def reset
          create_directory cache_path
          lazily_initialize_client

          truncate_db

          self
        end

        def truncate_db
          # TODO Could this be replaced by a truncate statement?
          #
          drop_table
          create_table
        end

        def drop_table
          db.execute 'drop table if exists key_value;'
        end

        def asynchronous
          db.execute 'PRAGMA synchronous = OFF;'
          self
        end

        def synchronous
          db.execute 'PRAGMA synchronous = ON;'
          self
        end

        def transaction
          db.execute 'BEGIN;'
          yield
          db.execute 'COMMIT;'
        end

        def to_s
          "#{self.class}(#{cache_path})"
        end

      end

    end

  end

end