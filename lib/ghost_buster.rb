require 'mysql2'
require_relative 'core_ext/array'
require_relative 'attributes_array'
require 'pry'

module GhostBuster
  class Core

    attr_reader :ghost_trap

    def initialize
      @db_name = 'ghost-buster'
      @db_host = 'localhost'
      @db_username = 'jdc'
      @db_password = 'get_to_data'
      @ghost_trap = {}

      @client = Mysql2::Client.new(host: 'localhost', username: @db_username, password: @db_password, database: @db_name)

      find_tables
    end

    def find_tables
      table_names = @client.query('show tables').to_a.map {|rec| rec.values }.flatten.symbolize!
      table_names.delete(:sessions)
      table_names.delete(:schema_migrations)

      @tables = {}

      table_names.each do |table_name|
        table_attributes = @client.query("DESCRIBE #{table_name}").to_a.map!{|record| record["Field"] }.symbolize!
        attributes_array = AttributesArray.new(table_attributes)

        @tables[table_name] = {:primary_key => attributes_array.primary_key}
        @tables[table_name][:foreign_keys] = attributes_array.foreign_keys
      end
    end

    def look_for_ghost_records
      @tables.each do |table, keys|
        puts "*** Checking table: #{table} ***"

        if !keys[:foreign_keys].empty?
          records = @client.query("SELECT #{keys[:primary_key]}, #{keys[:foreign_keys].join(', ')} FROM #{table}").to_a

          records.each do |record|
            begin
              keys[:foreign_keys].each do |foreign_key|
                table_name = foreign_key.reference_table_name.to_sym
                primary_key = @tables[table_name][:primary_key]
                
                reference = @client.query("SELECT #{primary_key} FROM #{table_name} WHERE #{primary_key}=#{record[foreign_key.to_s]} LIMIT 1").to_a
                
                if reference.empty?
                  trap_ghost(table, record[keys[:primary_key].to_s], foreign_key, record[foreign_key.to_s])
                  puts "*** Ghost busted ***"
                end
              end
            rescue Exception => e
              puts "Exception caught: #{e.message}"
              puts "Exception caught: #{e.backtrace}"
            end
          end
        end

        puts "*** Clear ***"
        puts 
      end

      puts @ghost_trap.inspect
    end

    def trap_ghost(table, primary_key, foreign_key_name, foreign_key_value)
      @ghost_trap[table] ||= {}
      @ghost_trap[table][primary_key] ||= {}
      @ghost_trap[table][primary_key][:tainted_foreign_keys] ||= []
      @ghost_trap[table][primary_key][:tainted_foreign_keys] << {attribute: foreign_key_name, value: foreign_key_value}
    end

    def data_structure
      @tables.inspect
    end
  end
end
