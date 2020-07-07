class Api::V1::EventsController < ApplicationController
  def index
    events = Event.order("created_at DESC")
    render json: events
  end

  def create
    event = Event.create(event_param)
    render json: event
  end

  def show
    event = Event.find(params[:id])
    render json: event
  end

  def update
    event = Event.find(params[:id])
    event.update_attributes(event_param)
    render json: event
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    head :no_content, status: :ok
  end

  def import
    require "json"
    while File.exist?("/Users/sherrywu1999/Desktop/untitled/callie/callie-api/python/timetables/caldr.json") == false
      sleep(1)
    end 
  
    file = File.open("/Users/sherrywu1999/Desktop/untitled/callie/callie-api/python/timetables/caldr.json")
    data = JSON.parse(file.read)
    info = data["data"]
    info.each do |child|
      event_title = child["title"]
      start_time = child["start"]
      end_time = child["end"]
      duration = child["duration"]

      retrieved = Event.find_by(title: event_title, start_time: start_time)

      if retrieved == nil
        activity_title = event_title.split(" ")[0]
        activity = Activity.find_or_initialize_by(title: activity_title)
        if activity.duration == nil
          activity.duration = 0
        else
          activity.duration = activity.duration + duration
        end
        activity.save
        puts duration

        event = Event.create({title: event_title, start_time: start_time, end_time: end_time, activity: activity, duration: duration})
        event.save
      else 
        puts "changing"
        puts duration
        retrieved.end_time = end_time
        retrieved.duration = duration
        retrieved.save
      end
    end
  end

  def read
    fork {
      exec("python /Users/sherrywu1999/Desktop/untitled/callie/callie-api/python/timetables/cal_rdr_no_input_duration.py")
    }

  end

  def event_param
    params.require(:event).permit(:title, :start_time, :end_time, :activity_id, :duration)
  end

end

