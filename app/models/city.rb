class City < ApplicationRecord
  include Import

  belongs_to :country, foreign_key: :country_name, primary_key: :name

  validates :name, presence: true, uniqueness: {scope: :country_name}

  scope :by_country, -> (var) { where(country_name: var&.squish&.upcase) }

  before_validation do
    self.name = self.name&.squish&.upcase
    self.country_name = self.country_name&.squish&.upcase
  end

  def self.import_csv(args)
    uniq_column = 'name'

    records = CSV.read(
      args[:csv_file_path],
      encoding: 'iso-8859-1:utf-8',
      headers: true,
      skip_blanks: true
    ).delete_if { |row| row.to_hash.values.all?(&:blank?) }
      .map{
        |a| a.to_h.slice(*(self.column_names)).merge(country_name: args[:country]).each { |k, v| v.squish!.upcase! if ['name', 'country_name'].include? k }
      }

    duplicate_records = records.map{ |a| a[uniq_column]&.strip }
      .compact
      .group_by{ |e| e }
      .select { |k, v| v.size > 1 }.map(&:first) 

    raise StandardError, "Duplicate records = #{duplicate_records.join(', ')}" if duplicate_records.any?

    records = self.import! records, on_duplicate_key_update: {conflict_target: uniq_column, columns: self.column_names.map(&:to_sym)}
  rescue ActiveRecord::RecordNotUnique => ex
    key, val = (/\((.*?)\)=\((.*?)\)/.match ex.message).captures
    raise StandardError, "Duplicate #{key} = #{val}"
  rescue ActiveModel::MissingAttributeError => ex
    matched = (/`(.*?)`/.match ex.message).captures.join(', ')
    raise StandardError, "Invalid Column Names: #{matched}"
  rescue ActiveRecord::StatementInvalid => ex
    raise Exception, ex.message
  end
end
