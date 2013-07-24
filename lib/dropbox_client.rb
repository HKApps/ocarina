require 'dropbox-api'

class DropboxClient < Dropbox::API::Client
  def initialize(access_token, access_secret)
    super(token: access_token, secret: access_secret)
  end

  ##
  # Dropbox metadata enables discovery of all the songs
  # uploaded to a user's account. It also provides metadata on
  # the folder and whether the folder has been modified since a
  # particular revision.
  #
  # See: https://www.dropbox.com/developers/core/docs#metadata
  def metadata
    @metadata ||= Metadata.new(self.raw.metadata(path: "/"))
  end

  def metadata=(new)
    @metadata = new
  end

  ##
  # Checks to see if the user's dropbox folder was modified since
  # the last fetch. If modifications were made, then we cache
  # the new metadata in an instance variable and return true. If
  # no changes were made, then we return false.
  def update_metadata
    begin
      @metadata = Metadata.new(self.raw.metadata(path: "/", hash: metadata.hash))
    rescue Dropbox::API::Error::Redirect
    end
  end

  def all_song_files
    metadata.contents.select { |file| file['mime_type'] == "audio/mpeg" }
  end

  ##
  # Song names are synonymous with the path. As a consequence, the root
  # '/' prefix shows up.
  def all_song_paths
    all_song_files.map{ |file| file['path'] }
  end

  def fetch_media_urls(*paths)
    paths.map do |path|
      begin
        self.media_url(path)
      rescue Dropbox::API::Error::NotFound
      end
    end
  end

  def media_url(path)
    begin
      self.raw.media(path: path)
    rescue Dropbox::API::Error::NotFound
    end
  end

  class Metadata
    include ActiveModel::Model

    attr_accessor :size, :hash, :bytes, :thumb_exists, :rev, :modified,
                  :path, :is_dir, :icon, :root, :contents, :revision

    def initialize(*args)
      super
    end
  end

  class NullMetadata
    def initialize(*args); end

    def size;         end
    def hash;         end
    def bytes;        end
    def thumb_exists; end
    def rev;          end
    def modified;     end
    def path;         end
    def is_dir;       end
    def icon;         end
    def root;         end
    def contents; []; end
    def revision;     end
  end

end
