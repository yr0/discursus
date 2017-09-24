module AdminPanel
  class PromoCodesController < AdminPanelController
    include RestfulActions

    private

    def record_params
      params.require(:promo_code).permit(:code, :discount_percent, :limit, :expires_at)
    end
  end
end
