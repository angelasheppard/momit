class EventsController < ApplicationController

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user_creator = current_user
    if @event.save
      #success
      redirect_to events_path
    else
      #failure
      render 'new'
    end
  end

  def show
    @event = Event.find_by(params[:id])
  end

  def index
    @events = Event.all.order(:start_time)


  end

    private
        def event_params
            params.require(:event)
                .permit(:name, :description, :start_time, :end_time,
                        :event_type, :is_template, :is_locked, :max_tank,
                        :max_dps, :max_healer, :log_url, :creator_id)
        end


end
