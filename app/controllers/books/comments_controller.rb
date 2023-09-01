# frozen_string_literal: true

class Books::CommentsController < ApplicationController
  include CommonCommentable

  private

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  def render_commentable_show
    @book = @commentable
    @comments = @book.comments.order(:id)
    render 'books/show', status: :unprocessable_entity
  end
end
