class Song #Song class == songs table

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end
#The #initialize method creates a new instance of the 
#song class, a new Ruby object. 

#create a songs table and give that table column names that 
#match the attributes of an individual instance of Song
  def self.create_table #class method -> whole class responsible
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      );
      SQL
    DB[:conn].execute(sql)
  end

  def save
#The #save method takes the @attributes that characterize a given song 
#and saves them in a new row of the songs table in our database.
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?);
    SQL

    #insert the song
    DB[:conn].execute(sql, self.name, self.album)
    #.execute method will take the values we pass in as an argument 
    #and apply them as the values of the question marks.
    
    # get the song ID from the database and save it to the Ruby instance
    #connecting database to instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the current Ruby instance
    self
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end
end
