# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  def create
    self.resource = resource_class.new(sign_in_params)

   # フォームが空でないかをチェック
   if resource.email.blank? || resource.password.blank?
     # 独自のエラーメッセージを追加
     resource.errors.add(:base, I18n.t('errors.messages.blank', attribute: 'Eメールまたはパスワード'))
     clean_up_passwords resource
     respond_with(resource, location: after_sign_in_path_for(resource))
   else
     # Deviseのデフォルト処理を呼び出す
     super
   end
end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

   protected

   def after_sign_in_path_for(resource)
    admin_root_path # Admin用のルート（/admin）
  end

  # def after_sign_out_path_for(resource_or_scope)
  #   new_admin_session_path # ログイン画面
  # end
end
