require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.to_s.camelcase.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {foreign_key: "#{name}".concat('Id').underscore.to_sym,
                primary_key: :id,
                class_name: name.capitalize}
    options = defaults.merge(options)

    @foreign_key = options[:foreign_key]
    @class_name = options[:class_name]
    @primary_key = options[:primary_key]

    assoc_options[name] = {foreign_key: @foreign_key,
                            class_name: @class_name,
                            primary_key: @primary_key}
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {foreign_key: "#{self_class_name}".concat('Id').underscore.to_sym,
                primary_key: :id,
                class_name: name.to_s.singularize.capitalize}
    options = defaults.merge(options)

    @foreign_key = options[:foreign_key]
    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(name) do
      options.model_class.where(options.
        primary_key => self.send(options.foreign_key)).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)
    define_method(name) do
      options.model_class.where(options.
        foreign_key => self.send(options.primary_key))
    end
  end

  def assoc_options
    @assoc_options ||={}
  end
end

class SQLObject
  extend Associatable
  # Mixin Associatable here...
end
