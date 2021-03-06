 class SubsController < ApplicationController
  before_action :require_login
  
  def index
    @subs = Sub.all
  end

  def show
    @sub = Sub.find(params[:id])
  end

  def new
    @sub = Sub.new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit  
    @sub = Sub.find(params[:id])
    redirect_to subs_path unless user_is_creator?(@sub, :moderator_id)
  end

  def update
    @sub = Sub.find(params[:id])
    redirect_to subs_path unless user_is_creator?(@sub, :moderator_id)
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
    
  end

  def destroy
    sub = Sub.find(params[:id])
    redirect_to subs_path unless user_is_creator?(sub, :moderator_id)
    sub.destroy
    redirect_to subs_url
  end
  
  private
  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end