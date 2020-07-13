require 'concurrent'

class Api::V1::DeadlinesController < ApplicationController
  def index
    deadlines = Deadline.order("created_at DESC")
    render json: deadlines
  end

  def create
    deadline = Deadline.create(deadline_param)
    render json: deadline
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
    while File.exist?("../../../python/deadlines/data.json") == false
      sleep(1)
    end 
  
    file = File.open("../../../python/deadlines/data.json")
    data = JSON.parse(file.read)
    info = data["data"]
    info.each do |child|
      title = child["title"]
      datetime = child["datetime"]
      activity = Activity.find(2)
      retrieved = Deadline.find_by(title: title)
      if retrieved == nil
        deadline = Deadline.create({title: title, datetime: datetime, allDay: true, activity: activity})
      else
        retrieved.datetime = datetime
        retrieved.allDay = true
        retrieved.save
      end
    end
  end

  def webscrap
    fork { exec("python ../../../python/deadlines/pythonweb.py")
    }
  end




end
