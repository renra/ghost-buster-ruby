gem 'minitest'
require 'minitest/autorun'
require 'minitest/mock'
require 'mocha/setup'
require_relative '../lib/ghost_buster'

class GhostBusterTest < Minitest::Test
  def setup
    host = 'localhost'
    username = 'username'
    password = 'password'
    db_name = 'db_name'

    @db_client = mock
    Mysql2::Client.stubs(:new).with(
      host: host,
      username: username,
      password: password,
      database: db_name
    ).returns(@db_client)

    @db_client.expects(:query).with('SHOW TABLES').returns(
      [
        {"Tables_in_db_name" => 'organizations'},
        {"Tables_in_db_name" => 'children'},
        {"Tables_in_db_name" => 'users'},
        {"Tables_in_db_name" => 'sessions'},
        {"Tables_in_db_name" => 'schema_migrations'}
      ]
    )

    @db_client.expects(:query).with('DESCRIBE organizations').returns(
      [
        {'Field' => 'id'},
        {'Field' => 'name'}
      ]
    )


    @db_client.expects(:query).with('DESCRIBE children').returns(
      [
        {'Field' => 'id'},
        {'Field' => 'name'},
        {'Field' => 'organization_id'},
        {'Field' => 'user_id'}
      ]
    )


    @db_client.expects(:query).with('DESCRIBE users').returns(
      [
        {'Field' => 'id'},
        {'Field' => 'name'},
        {'Field' => 'organization_id'}
      ]
    )

    @db_client.stubs(:query).with(
      'SELECT id, organization_id FROM users'
    ).returns(
      [
        {"id" => 1, "organization_id" => 1},
        {"id" => 2, "organization_id" => nil},
        {"id" => 3, "organization_id" => 3}   #ghost
      ]
    )

    @db_client.stubs(:query).with(
      "SELECT id, organization_id, user_id FROM children"
    ).returns(
      [
        {"id" => 1, "organization_id" => 1, "user_id" => 1},
        {"id" => 2, "organization_id" => nil, "user_id" => nil},
        {"id" => 3, "organization_id" => 3, "user_id" => 3},   #part ghost
        {"id" => 4, "organization_id" => 3, "user_id" => 4}   #full ghost
      ]
    )

    @db_client.stubs(:query).with(
      'SELECT id FROM organizations WHERE id=1 LIMIT 1'
    ).returns(['record'])

    @db_client.stubs(:query).with(
      'SELECT id FROM organizations WHERE id=2 LIMIT 1'
    ).returns(['record'])

    @db_client.stubs(:query).with(
      'SELECT id FROM organizations WHERE id=3 LIMIT 1'
    ).returns([])

    @db_client.stubs(:query).with(
      'SELECT id FROM users WHERE id=1 LIMIT 1'
    ).returns(['record'])

    @db_client.stubs(:query).with(
      'SELECT id FROM users WHERE id=2 LIMIT 1'
    ).returns(['record'])

    @db_client.stubs(:query).with(
      'SELECT id FROM users WHERE id=3 LIMIT 1'
    ).returns(['record'])

    @db_client.stubs(:query).with(
      'SELECT id FROM users WHERE id=4 LIMIT 1'
    ).returns([])

    @buster = GhostBuster::Core.new(
      username,
      password,
      db_name
    )

    @tables = @buster.tables
    @buster.look_for_ghost_records
    @ghost_trap = @buster.ghost_trap
  end

  def test_bust_em
    assert_equal @buster.respond_to?(:bust_em), true
  end

  def test_tables
    assert_equal @tables, {
      "organizations" => {:primary_key => "id", :foreign_keys => []},
      "children" => {:primary_key => "id", :foreign_keys => [
        "organization_id", "user_id"
      ]},
      "users" => {:primary_key => "id", :foreign_keys => [
        "organization_id"
      ]}
    }
  end

  def test_ghost_trap
    assert_equal @ghost_trap, {
      "children" => {
        3 => {:tainted_foreign_keys => [
          {:attribute => "organization_id", :value => 3}
        ]},
        4 => {:tainted_foreign_keys => [
          {:attribute => "organization_id", :value => 3},
          {:attribute => "user_id", :value => 4}
        ]}
      },
      "users" => {
        3 => {:tainted_foreign_keys => [
          {:attribute => "organization_id", :value => 3}
        ]}
      }
    }
  end
end
