# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]

  def edit; end

  def create
    @comment = @commentable.comments.new(comment_params)
    if @comment.save
      redirect_to url_for(@commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render_commentable_show
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to url_for(@commentable), notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to url_for(@commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id)
  end
end
