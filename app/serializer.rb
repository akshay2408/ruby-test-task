# frozen_string_literal: true

# app/serializer.rb
class Serializer
  class << self
    attr_reader :serializable
  end

  attr_reader :object

  def initialize(object)
    @object = object
  end

  def self.attribute(field, &block)
    @serializable ||= {}
    @serializable[field] = block
  end

  def serialize
    extract_attrs
  end

  private

  def extract_attrs
    resource_serializable.map { |key, proc| key_arr(key, proc) }.to_h
  end

  def key_arr(key, proc)
    [key, attribute_value(key, proc)]
  end

  def resource_serializable
    self.class.serializable
  end

  def attribute_value(key, proc)
    proc.nil? ? object.public_send(key) : instance_eval(&proc)
  end
end
