require 'sqlite3'

class ReleaseDatabase
  attr_reader :db

  def initialize(dbname = "releases")
    @db = SQLite3::Database.new "database/#{dbname}.db"
  end

  def reset_schema!
    #table name: albums
    #label_code,artist,title,label,format,year released,date_added
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
end

release_db = ReleaseDatabase.new
#potato = ReleaseDatabase.new   #this would connect to the same database
release_db.reset_schema!
