require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map {|key| "#{key} = ?"}.join(' AND ')

    output = DBConnection.execute(<<-SQL, params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      where
        #{where_line}
    SQL

    self.parse_all(output)
  end
end

class SQLObject
  extend Searchable
end
