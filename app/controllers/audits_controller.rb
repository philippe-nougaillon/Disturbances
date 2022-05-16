class AuditsController < ApplicationController
  before_action :is_user_authorized

  def index
    # authorize :audit, :index?

    @audits  = Audited::Audit.order("id DESC")
    @actions = @audits.pluck(:action).uniq.sort
    @types   = @audits.pluck(:auditable_type).uniq.sort
    @users   = User.all

    unless params[:date].blank?  
      @audits = @audits.where("DATE(created_at) = ?", params[:date])
    end

    unless params[:audit_action].blank?
      @audits = @audits.where(action: params[:audit_action])
    end

    unless params[:type].blank?
      @audits = @audits.where(auditable_type: params[:type])
    end

    unless params[:user_id].blank?
      @audits = @audits.where(user_id: params[:user_id])
    end

    @audits = @audits.page(params[:page]).per(20)
  end

  private

  def is_user_authorized
    authorize :audit
  end

end
