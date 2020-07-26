class Api::V1::EventsController < ApplicationController
  require 'json' 
  def index
    events = Event.order("created_at DESC")
    render json: events
  end

  def create
    newEvent = Event.create(event_param)
    @current_user.events << newEvent
    render json: newEvent
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
    path = Rails.root.join('app','python','timetables','caldr.json')
    while File.exist?(path) == false
      sleep(1)
    end 
  
    file = File.open(path)
    data = JSON.parse(file.read)
    info = data["data"]
    info.each do |child|
      event_title = child["title"]
      start_time = child["start"]
      end_time = child["end"]
      duration = child["duration"]
      completion = true

      # retrieved = Event.find_by(title: event_title, start_time: start_time, user_id: @current_user.id)

      # if retrieved == nil
      activity_title = event_title.split(" ")[0]
      activity = Activity.find_or_create_by(title: activity_title, target: 10, user_id: @current_user)
      @current_user.activities << activity

      # if activity.duration == nil
      #   activity.duration = 0
      # else
      #   activity.duration = activity.duration + duration
      # end
      # activity.save

      newEvent = Event.create({title: event_title, start_time: start_time, end_time: end_time, 
        activity: activity, duration: duration, completion: completion})
      @current_user.events << newEvent

      # else 
      #   puts "changing"
      #   @current_user.events << retrieved
      #   @current_user.activities << retrieved.activity
      #   retrieved.end_time = end_time
      #   retrieved.duration = duration
      #   retrieved.completion = false
      #   retrieved.save
      # end
    end
    puts
    fork { exec("rm #{Rails.root.join('app','python','timetables','caldr.json')} ")}

  end


  def read
    # RubyPython.start # start the Python interpreter
    # sys = RubyPython.import("sys") # (add) method used to search for a directory
    # sys.path.append('./app/python/timetables') # (add) execute search in directory
    # RubyPython.import("cal_rdr_no_input_duration") # (add) call on setup.py in the directory
    # RubyPython.stop # stop the Python interpreter
    # fork { exec("python /Users/sherrywu1999/Desktop/untitled/callie/callie-api/app/python/timetables/cal_rdr_no_input_duration.py") }
    id = params[:user_id]
    fork { exec("python #{Rails.root.join('app','python','timetables','cal_rdr_no_input_duration.py')} #{id}") }
  end

  def write
    content = params["file"].tempfile
    data = File.read(content)
    user_id = @current_user.id
    file_name = 'nusmods_calendar' + user_id.to_s + '.ics'
    target  = Rails.root.join('app','python','timetables', file_name)
    File.open(target, "w+") do |f| f.write(data) end
  end
        

  private
  def event_param
    params.require(:event).permit(:title, :start_time, :end_time, 
    :activity_id, :duration, :completion)
  end

end

