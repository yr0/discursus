module AdminPanel

##
# A concern that can be used for any REST resources (in admin panel). Defines actions #index, #show, #new, #create,
# #edit, #update, #destroy, that can be overridden in controller.
  module RestfulActions
    extend ActiveSupport::Concern

    included do
      load_and_authorize_resource
    end

    def index
      set_records_query! { |records| records.page(params[:page]) }
    end

    private

    # Loads cancancan's instance variable mapped to records' AR Relation and yields the relation to block
    # that can specify the query on relation. Can be overridden used in controller actions for complex scoping etc.
    def set_records_query!
      records = instance_variable_get("@#{records_name}")
      instance_variable_set("@#{records_name}", yield(records))
    end

    def records_name
      controller_name.demodulize.underscore
    end

    def record_name
      records_name.singularize
    end
  end
end
