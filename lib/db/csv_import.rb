db_config = YAML.load_file('config/database2.yml')
ActiveRecord::Base.establish_connection(db_config['development'])

# datafile = Rails.root + 'db/data.csv'
path = "/Users/hielf/Downloads/wind/data/"

Dir.foreach(path) do |filename|
  datafile = path + filename
  if filename.include? ".CSV"
    p datafile

    conn = ActiveRecord::Base.connection
    rc = conn.raw_connection
    rc.exec("COPY wind_data FROM STDIN WITH CSV")

    file = File.open(datafile, 'r:gbk')
    while !file.eof?
      # Add row to copy data
      line = file.readline
      p line
      rc.put_copy_data(line)
    end

    # We are done adding copy data
    rc.put_copy_end

    # Display any error messages
    while res = rc.get_result
      if e_message = res.error_message
        p e_message
      end
    end
  end
end
