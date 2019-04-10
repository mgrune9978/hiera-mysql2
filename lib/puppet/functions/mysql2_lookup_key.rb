Puppet::Functions.create_function(:mysql2_lookup_key) do
  require 'puppet'
  require 'facter'
  require 'java'

  begin 
    require 'jdbc/mysql'
  rescue LoadError
    puts 'please install some_gem first!'
  end

  dispatch :mysql2_lookup_key do
    param 'String[1]', :key
    param 'Hash[String[1],Any]', :options
    param 'Puppet::LookupContext', :context
  end

  def mysql2_lookup_key(key, options, context)
    results = nil

    if key == 'lookup_options'
      return {}
    end

    path = options['path']
    mysql_options = YAML.load_file(path)

    if mysql_options[key].nil?
      context.not_found()
    end

    dbconfig = mysql_options[:dbconfig]

    connection_options = {
      :host => context.interpolate(dbconfig['host']),
      :username => context.interpolate(dbconfig['username']),
      :password => context.interpolate(dbconfig['password']),
      :database => context.interpolate(dbconfig['database']),
      :port => context.interpolate(dbconfig['port']) || 3306
    }

    _query = mysql_options[key]

    results = query(connection_options, _query)

    if results.nil?
      context.not_found()
    end

    return results
  end

  def query(connection_options, query)
    data = []

    if defined?(JRUBY_VERSION)
      _host = connection_options[:host]
      _username = connection_options[:username]
      _password = connection_options[:password]
      _database = connection_options[:database]
      _port = connection_options[:port]

      Jdbc::MySQL.load_driver
      url = "jdbc:mysql://#{_host}:#{_port}/#{_database}"
      props = java.util.Properties.new
      props.set_property :user, _username
      props.set_property :password, _password

      conn = com.mysql.jdbc.Driver.new.connect(url,props)
      stmt = conn.create_statement

      res = stmt.execute_query(query)
      md = res.getMetaData
      numcols = md.getColumnCount

      while ( res.next ) do
        if numcols < 2
          data << res.getString(1)
        else
          row = {}
          (1..numcols).each do |c|
            row[md.getColumnName(c)] = res.getString(c)
          end
          data << row
        end
      end
    else
      client = Mysql2::Client.new(connection_options)
      begin
        data = client.query(query).to_a
      rescue => e
        puts e.message
        data = nil
      ensure
        client.close
      end
    end

    return data

  end
end