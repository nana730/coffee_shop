class Customer::ContactsController < ApplicationController
  def new
  end

  def create
    # フォームから送信されたパラメータを直接受け取る
    @name = params[:contact][:name]
    @subject = params[:contact][:subject]
    @message = params[:contact][:message]
    @errors = []
  
    if @name.blank?
      @errors << "お名前を入力してください。"
    end
  
    if params[:contact][:email].blank?
      @errors << "メールアドレスを入力してください。"
    elsif !params[:contact][:email].match(/\A[^@\s]+@[^@\s]+\z/)
      @errors << "メールアドレスの形式が正しくありません。"
    end

    if @subject.blank?  # 件名が空の場合のチェック
      @errors << "件名を入力してください。"
    end
  
    if @message.blank?
      @errors << "お問い合わせ内容を入力してください。"
    end
  
    if @errors.empty?
      ContactMailer.send_mail(@name, params[:contact][:email], @subject, @message).deliver_now
      ContactMailer.send_confirmation_to_customer(@name, params[:contact][:email], @subject, @message).deliver_now
  
      flash[:notice] = "お問い合わせが送信されました。"
      redirect_to new_contact_path
    else
      render :new, status: :unprocessable_entity
    end
  end
end
