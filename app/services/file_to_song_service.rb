class FileToSongService
  def initialize(file_list, user)
    @file_list = file_list
    @user      = user
  end

  def convert_and_save
    @file_list.map { |song| find_or_create_song(song) }
  end

  def find_or_create_song(song)
    Song.where(user_id: @user.id, provider: "dropbox", path: song['path']).first_or_initialize do |s|
      s.name       = song['path'][1..-1].gsub('_',' ')
      s.properties = song
      s.save! if s.changed?
    end
  end
end
