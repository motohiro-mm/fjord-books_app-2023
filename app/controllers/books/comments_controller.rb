# frozen_string_literal: true

class Books::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  def render_commentable_show
    @book = @commentable
    render 'books/show', status: :unprocessable_entity
  end
end