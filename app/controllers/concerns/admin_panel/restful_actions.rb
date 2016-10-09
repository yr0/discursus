module AdminPanel

##
# A concern that can be used for any REST resources (in admin panel). Defines actions #index, #show, #new, #create,
# #edit, #update, #destroy, that can be overridden in controller.
  module RestfulActions
    extend ActiveSupport::Concern

    included do
      load_and_authorize_resource find_by: cancan_find_by_field
      skip_load_resource only: :create
    end

    module ClassMethods
      # by what field to find record
      def cancan_find_by_field
        model = controller_name.demodulize.singularize.camelize.constantize
        if model.included_modules.include?(FriendlyId::Model)
          :slug
        else
          :id
        end
      end
    end

    def index
      set_records_query! { |records| records.includes(eager_load_associations).page(params[:page]) }
    end

    def create
      self.record = model.new(record_params)
      render_create record.save
    end

    def update
      render_update record.update(record_update_params)
    end

    def destroy
      if record.destroy
        gflash success: I18n.t("admin_panel.#{records_name}.destroyed")
      else
        gflash error: I18n.t("admin_panel.#{records_name}.not_destroyed",
                             errors: record.errors.full_messages.join('; '))
      end
      redirect_to action: :index
    end

    private

    # Permitted parameters for the record - this method must be implemented in controller
    def record_params
      raise NotImplementedError
    end

    # update permitted params are the same as create by default
    def record_update_params; record_params; end

    # what associations to add during loading of index action
    def eager_load_associations
      nil
    end

    # ActiveRecord model inferred from controller name
    def model
      record_name.camelize.constantize
    end

    # Loads cancancan's instance variable mapped to records' AR Relation and yields the relation to block
    # that can specify the query on relation. Can be overridden used in controller actions for complex scoping etc.
    def set_records_query!
      records = instance_variable_get("@#{records_name}")
      instance_variable_set("@#{records_name}", yield(records))
    end

    def render_create(result)
      render_save(result, :new)
    end

    def render_update(result)
      render_save(result, :edit)
    end

    def render_save(result, back_template)
      respond_to do |format|
        format.html do
          if result
            gflash success: I18n.t("admin_panel.#{records_name}.saved")
            redirect_to action: :index
          else
            render back_template
          end
        end
        format.js
      end
    end

    def record
      instance_variable_get("@#{record_name}")
    end

    def record=(value)
      instance_variable_set("@#{record_name}", value)
    end

    def records_name
      controller_name.demodulize.underscore
    end

    def record_name
      records_name.singularize
    end
  end
end
