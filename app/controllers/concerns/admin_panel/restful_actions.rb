module AdminPanel

##
# A concern that can be used for any REST resources (in admin panel). Defines actions #index, #show, #new, #create,
# #edit, #update, #destroy, that can be overridden in controller.
  module RestfulActions
    extend ActiveSupport::Concern

    included do
      load_and_authorize_resource
      skip_load_resource only: :create
    end

    def index
      set_records_query! { |records| records.page(params[:page]) }
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
      if result
        gflash success: I18n.t("admin_panel.#{records_name}.saved")
        redirect_to action: :index
      else
        render back_template
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
