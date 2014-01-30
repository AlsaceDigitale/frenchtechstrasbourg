class Startup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Slug
  include Geocoder::Model::Mongoid

  field :name, type: String
  field :url, type: String
  field :street, type: String
  field :zip_code, type: String
  field :city, type: String
  field :email, type: String
  field :description_fr, type: String
  field :description_en, type: String
  field :is_published, type: Boolean, default: false

  field :coordinates, type: Array

  slug :name

  has_mongoid_attached_file :logo,
    :styles => {
      :small  => ['250x250>', :png],
      :medium => ['500x500>', :png],
    }

  geocoded_by :address

  before_validation do |startup|
    if startup.is_published == "1"
      startup.is_published = true
    elsif startup.is_published == "0"
      startup.is_published = false
    end
  end

  after_validation :geocode
  before_save do |startup|
    startup.coordinates = startup.to_coordinates
  end

  def address
    [street, zip_code, city].compact.join(', ')
  end

  def self.is_published
    where(:is_published => true)
  end

  def description(locale)
    txt = self["description_#{locale}".to_sym]
    contrary = locale.to_s == "en" ? "fr" : "en"
    txt = txt.present? ? txt : self["description_#{contrary}".to_sym]
    txt.present? ? txt : self["description".to_sym]
  end
end
