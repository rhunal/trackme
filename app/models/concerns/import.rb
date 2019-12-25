require 'csv'

module Import
  extend ActiveSupport::Concern

  class_methods do
    def import_csv(csv_file_path)
      # in future, add another uniq column into below array
      uniq_columns = self.column_names & ['name']
      uniq_columns = uniq_columns.try(:first)

      records = CSV.read(
        csv_file_path,
        encoding: 'iso-8859-1:utf-8',
        headers: true,
        skip_blanks: true
      ).delete_if {
        |row| row.to_hash.values.all?(&:blank?)
      }.map{|a| a.to_h.slice(*(self.column_names)).each { |k, v| v.squish!.upcase! if %w(name).include? k } }

      duplicate_records = records.map{|a| a[uniq_columns].try(:strip) }.compact.group_by{ |e| e }.select { |k, v| v.size > 1 }.map(&:first)

      raise StandardError, "Duplicate codes = #{duplicate_records.join(', ')}" if duplicate_records.any?

      records = self.import! records, on_duplicate_key_update: {conflict_target: uniq_columns, columns: self.column_names.map(&:to_sym)}
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
end