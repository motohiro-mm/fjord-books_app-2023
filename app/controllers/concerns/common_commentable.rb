# frozen_string_literal: true

module CommonCommentable
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable
    before_action :set_comment, only: %i[edit update destroy]
  end

  def edit
    render 'comments/edit'
  end

  def create
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
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
      render 'comments/edit', status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to url_for(@commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
