class Api::V1::DeadlinesController < ApplicationController

  def index
    deadlines = Deadline.order("created_at DESC")
    render json: deadlines
  end

  def create
    newDeadline = Deadline.create(deadline_param)
    @current_user.deadlines << newDeadline
    render json: newDeadline
  end

  def show
    deadline = Deadline.find(params[:id])
    render json: deadline
  end

  def update
    deadline = Deadline.find(params[:id])
    deadline.update_attributes(deadline_param)
    render json: deadline
  end

  def destroy
    deadline = Deadline.find(params[:id])
    deadline.destroy
    head :no_content, status: :ok
  end

  def import
    require "json"
    path = Rails.root.join('app','python','deadlines','data.json')
    while File.exist?(path) == false
      sleep(1)
    end 
  
    file = File.open(path)
    data = JSON.parse(file.read)
    info = data["data"]
    info.each do |child|
      title = child["title"]
      datetime = child["datetime"]
      activity = Activity.find(2)
      retrieved = Deadline.find_by(title: title)
      if retrieved == nil
        deadline = Deadline.create({title: title, datetime: datetime, allDay: true, activity: activity})
        @current_user.deadlines << deadline
      else
        retrieved.datetime = datetime
        retrieved.allDay = true
        retrieved.save
      end
    end
  end

  def webscrap
      url = params[:url]
      email = params[:email]
      password = params[:password]
      mod = params[:mod]
      fork { exec("python #{Rails.root.join('app','python','deadlines','webscrapper.py')} #{url} #{email} #{password} #{mod}")
      }
  end

end
