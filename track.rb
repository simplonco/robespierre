
class Track < ActiveRecord::Base
  def self.destroy_from_title(title)
    `rm ./public/tracks/#{title}.mp3`
    #regarder les fileutils ruby pour supprimer en ruby plutôt que de rentrer dans le schell
    Track.find_by_title(title).destroy
  end

  def self.create_track(title)
    title = no_special_caracters(title)
    title.to_file("fr", "public/tracks/#{title[0..57]}.mp3")
    new_track = Track.new(title: title, lien: "/tracks/#{title}")
    new_track.save
  end

  private
  
  def self.no_special_caracters(input)
    input.gsub("&", "et ").
      gsub("@", "at ").
      gsub("#", "hachetague").
      gsub(/[$°_\"{}\]\[`~&+,:;=?@#|'<>.^*()%!-]/, "")
  end
end
