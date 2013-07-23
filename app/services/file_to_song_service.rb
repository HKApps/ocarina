class FileToSongService
  def initialize(file_list, user)
    @file_list = file_list
    @user      = user
  end

  def convert_and_save
    @file_list.each { |song| find_or_create_song(song) }
    true
  end

  def find_or_create_song(song)
    s = Song.where(user_id: @user.id, provider: "dropbox", path: song['path']).first_or_initialize
    s.name       = song['path'][1..-1]
    s.properties = song
    s.save! if s.changed?
  end
end
