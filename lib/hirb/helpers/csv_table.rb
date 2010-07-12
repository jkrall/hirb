require 'fastercsv'

class Hirb::Helpers::CsvTable < Hirb::Helpers::Table
  # Rows are any ruby objects, rendered with to_csv. Takes same options as Hirb::Helpers::Table.render except as noted below.
  #
  # ==== Options:
  # [:fields] Methods of the object to represent as columns. Defaults to [:to_s].
  def self.render(rows, options ={})
    options[:fields] ||= [:to_s]
    options[:headers] ||= {:to_s=>'value'} if options[:fields] == [:to_s]
    item_hashes = options[:fields].empty? ? [] : Array(rows).inject([]) {|t,item|
      t << options[:fields].inject({}) {|h,f| h[f] = item.__send__(f); h}
    }
    super(item_hashes, options)
  end

  def render
    table_string = FasterCSV.generate @options[:csv]||{} do |csv|
      unless @rows.length == 0
        setup_field_lengths
        csv << render_header if @headers
        render_rows.each do |row|
          csv << row
        end
      end
    end
    table_string += render_table_description if @options[:description]
    table_string
  end

  def render_table_header
    title_row = @fields.map {|f| @headers[f] }
    title_row
  end

  def render_border
    nil
  end

  def render_rows
    @rows.map do |row|
      row = @fields.map {|f| row[f] }
    end
  end

end