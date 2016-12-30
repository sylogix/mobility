module Mobility
  module Backend
    class Sequel::Columns::QueryMethods < Backend::Sequel::QueryMethods
      def initialize(attributes, **options)
        define_method :where do |cond, &block|
          if cond.is_a?(Hash) && (keys = cond.keys & attributes.map(&:to_sym)).present?
            cond = cond.dup
            keys.each do |attr|
              attr_with_locale = Mobility::Backend::Columns.column_name_for(attr, Mobility.locale)
              cond[attr_with_locale.to_sym] = cond.delete(attr)
            end
          end
          super(cond, &block)
        end

        attributes.each do |attribute|
          define_method :"first_by_#{attribute}" do |value|
            where(attribute.to_sym => value).first
          end
        end
      end
    end
  end
end
