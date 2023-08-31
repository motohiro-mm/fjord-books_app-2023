# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
  include CommonCommentable

  private

  def set_commentable
    @commentable = Report.find(params[:report_id])
  end

  def render_commentable_show
    @report = @commentable
    render 'reports/show', status: :unprocessable_entity
  end
end
