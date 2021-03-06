require 'dm-core'
require 'digest/sha2'

module DataMapper
  module Is
    module Checksumed
      #
      # Fired when your plugin gets included into a Model.
      #
      def is_checksumed(options={})
        extend DataMapper::Is::Checksumed::ClassMethods
        include DataMapper::Is::Checksumed::InstanceMethods
      end

      #
      # Calculates the SHA256 checksum of the given data.
      #
      # @param [#to_s] data
      #   The data to checksum.
      #
      # @return [String]
      #   The SHA256 hex-digest of the data.
      #
      # @since 0.2.0
      #
      def self.checksum(data)
        Digest::SHA256.hexdigest(data.to_s)
      end

      module ClassMethods
        #
        # The properties which have accompanying checksums.
        #
        # @return [Set<Symbol>]
        #   The property names.
        #
        def checksumed_properties
          @checksumed_properties ||= Set[]
        end

        #
        # Determines if a checksum property was defined for another
        # property.
        #
        # @param [Symbol, String] name
        #   The name of the property.
        #
        # @return [Boolean]
        #   Specifies whether the property has an checksum property.
        #
        def checksumed?(name)
          checksumed_properties.include?(name.to_sym)
        end

        #
        # Filters a query, replacing the checksumed properties, with their
        # accompanying checksums.
        #
        # @param [Hash, DataMapper::Undefined] query
        #   The query to filter.
        #
        # @return [Hash, DataMapper::Undefined]
        #   The filtered query.
        #
        def checksum_query(query)
          return query unless query.kind_of?(Hash)

          new_query = {}

          query.each do |name,value|
            if (name.respond_to?(:to_sym) && checksumed_properties.include?(name.to_sym))
              new_query[:"#{name}_checksum"] = Checksumed.checksum(value)
            else
              new_query[name] = value
            end
          end

          return new_query
        end

        #
        # Substitutes any checksumed properties with the checksums of their
        # values.
        #
        # @param [DataMapper::Undefined, DataMapper::Query, Hash] query
        #   The query.
        #
        # @return [DataMapper::Resource, nil]
        #   The matching resource.
        #
        def first(query=Undefined)
          super(checksum_query(query))
        end

        #
        # Substitutes any checksumed properties with the checksums of their
        # values.
        #
        # @param [DataMapper::Undefined, DataMapper::Query, Hash] query
        #   The query.
        #
        # @return [DataMapper::Collection]
        #   The matching resources.
        #
        def all(query=Undefined)
          super(checksum_query(query))
        end

        protected

        #
        # Defines a checksum property for another property.
        #
        # @param [Symbol] name
        #   The name of the property to checksum.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Boolean] :unique (true)
        #   Specifies whether the checksums are to be unique, or if
        #   duplicates are allowed.
        #
        def checksum(name,options={})
          # build the checksum property options
          property_options = {
            :length => 64,
            :required => true,
            :default => lambda { |resource,property|
              resource.checksum_attribute(name)
            }
          }

          if options.fetch(:unique,true)
            property_options[:unique] = true
          else
            property_options[:index] = true
          end

          property :"#{name}_checksum", String, property_options
          checksumed_properties << name
        end
      end # ClassMethods

      module InstanceMethods
        #
        # Calculates the checksum of an attribute.
        #
        # @param [Symbol] name
        #   The name of the attribute.
        #
        # @return [String]
        #   The checksum of the attribute.
        #
        # @since 0.2.0
        #
        def checksum_attribute(name)
          checksum = Checksumed.checksum(attribute_get(name))

          attribute_set(:"#{name}_checksum",checksum)
          return checksum
        end

        #
        # Updates the checksums and saves the resource.
        #
        # @param [Array] arguments
        #   Additional arguments passed to `save`.
        #
        # @return [Boolean]
        #   Specifies whether the resource was successfully saved.
        #
        # @since 0.2.0
        #
        def save(*arguments)
          self.class.checksumed_properties.each do |name|
            checksum_attribute(name) if attribute_dirty?(name)
          end

          super(*arguments)
        end
      end # InstanceMethods
    end # Checksumed
  end # Is
end # DataMapper
