class FileToSongService
  def initialize(file_list, user)
    @file_list  = file_list
    @user       = user
    @start_time = Time.now.utc
  end

  def convert_and_save
    @file_list.map { |song| find_or_create_song(song) }
  end

  def find_or_create_song(song)
    Song.where(user_id: @user.id, provider: "dropbox", path: song['path']).first_or_initialize.tap do |s|
      s.name       = song['path'][1..-1].gsub('_',' ').gsub(/.mp3|.mp4|.wav|.ogg|.aac/, '')
      s.properties = song
      s.removed_at = nil
      s.changed? ? s.save! : s.touch
    end
  end

  def update_removed_dropbox_songs
    Song.where("user_id = ? AND updated_at < ?", @user.id, @start_time).map do |song|
      song.removed_from_dropbox!
    end
  end
end
