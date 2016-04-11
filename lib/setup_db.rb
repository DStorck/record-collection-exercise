require 'sqlite3'
require 'csv'

class ReleaseDatabase
  FILE_PATH = 'source/20160406-record-collection.csv'
  attr_reader :db

  def initialize(dbname = "releases")
    @db = SQLite3::Database.new "database/#{dbname}.db"
  end

  def reset_schema!
    #table name: albums
    #label_code, :artist,title,label,format,released,date_added
    #blob, text, text, text, text, integer, text
    #keep in one table
    query = <<-CREATESTATEMENT
    CREATE TABLE albums(
    id INTEGER PRIMARY KEY,
    label_code BLOB,
    artist TEXT NOT NULL,
    title TEXT NOT NULL,
    label TEXT,
    format TEXT,
    released INTEGER,
    date_added TEXT
    );
    CREATESTATEMENT

    @db.execute('DROP TABLE IF EXISTS albums;') #this will reset table if table already exists
    @db.execute(query) #execute can only run one query at a time
  end

  def load!
    #statement preparation designed for reuse, it is a query , will work sort of like interpolation
    insert_statement = <<-INSERTSTATEMENT
    INSERT INTO albums (
    label_code, artist, title, label, format, released, date_added
    ) VALUES (
    :label_code, :artist, :title, :label, :format, :released, :date_added
    );
    INSERTSTATEMENT

    prepared_statement = @db.prepare(insert_statement)
    #now that we have a prepared statement let's iterate the csv and use its values to populate our database

    CSV.foreach(FILE_PATH, headers: true) do |row|#tells it that first line is header info, not data
      prepared_statement.execute(row.to_h)  #knows because of headers
    end

  end

end



release_db = ReleaseDatabase.new
#potato = ReleaseDatabase.new   #this would connect to the same database
release_db.reset_schema!
release_db.load!
