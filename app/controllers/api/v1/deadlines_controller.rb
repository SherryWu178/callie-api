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
    count = 1
    while File.exist?(path) == false
      sleep(1)
      count = count + 1
      if count > 10
        render json: {
              message: "invalid credentials"
          }, status: :unprocessable_entity
      end
    end 
  
    file = File.open(path)
    data = JSON.parse(file.read)
    info = data["data"]
    
    if info.empty?
      render json: {
              message: "invalid credentials"
          }, status: :unprocessable_entity
    end 
    
    half = params["activity_title"]
    activity_title = "CS" + half
    activity = Activity.find_or_create_by(title: activity_title, target:10, user_id: @current_user.id)
    @current_user.activities << activity

    info.each do |child|
      title = child["title"]
      datetime = child["datetime"]
      retrieved = Deadline.find_by(title: title, user_id: @current_user.id)
      if retrieved == nil
        deadline = Deadline.create({title: title, datetime: datetime, allDay: true, activity: activity})
        @current_user.deadlines << deadline
      else
        retrieved.datetime = datetime
        retrieved.allDay = true
        retrieved.save
      end
    end
    
    fork { exec("rm #{Rails.root.join('app','python','deadlines','data.json')}")}
  end

  def webscrap
      url = params[:url]
      email = params[:email]
      password = params[:password]
      mod = params[:mod]
      fork { exec("python #{Rails.root.join('app','python','deadlines','webscrapper.py')} #{url} #{email} #{password} #{mod}")
      }
  end


  private
  def deadline_param
    params.require(:deadline).permit(:title, :datetime, :activity_id, :allDay, :user_id)
  end
end
