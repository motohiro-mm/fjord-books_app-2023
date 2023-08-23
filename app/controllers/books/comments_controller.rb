# frozen_string_literal: true

class Books::CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create update edit destroy]
  before_action :set_comment, only: %i[edit update destroy]

  def edit; end

  def create
    @comment = @commentable.comments.new(comment_params)
    if @comment.save
      redirect_to url_for(@commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render 'books/show', status: :unprocessable_entity
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

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id)
  end
end
