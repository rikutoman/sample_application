class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)              # paramsハッシュで受け取ったemail値を小文字化し、email属性に渡してUserモデルから同じemailの値のUserを探して、user変数に代入
    if @user && @user.authenticate(params[:session][:password])                 # user変数がデータベースに存在し、なおかつparamsハッシュで受け取ったpassword値と、userのemail値が同じ(パスワードとメールアドレスが同じ値であれば)true
      log_in @user                                                              # sessions_helperのlog_inメソッドを実行し、sessionメソッドのuser_id（ブラウザに一時cookiesとして保存）にidを送る
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)   # ログイン時、sessionのremember_me属性が1(チェックボックスがオン)ならセッションを永続的に、それ以外なら永続的セッションを破棄する
      redirect_to @user                                
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
