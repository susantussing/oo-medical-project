module InstanceMethodsORM

  def escape(string)
    string = SQLite3::Database.quote(string)
    "'#{string}'"
  end

  def format_values(values)
    values.map do |value|
      if value.class.to_s == "String"
        escape(value)
      else
        value
      end
    end
  end

  def table
    self.class.to_s.downcase + "s"
  end

  def delete
    
  end

  def columns
    DB.execute2("SELECT * FROM #{table}")[0]
  end

  def fields
    fields = columns.map {|field| [field, instance_variable_get("@#{field}")]}
    Hash[fields].reject{ |k, v| v.nil? }
  end

  def save
    keys = fields.keys.join(",")
    values = format_values(fields.values).join(",")

    DB.execute("INSERT INTO #{table} (#{keys}) VALUES (#{values})")
    @id = DB.last_insert_row_id
  end

  def update(attributes)

  end

end