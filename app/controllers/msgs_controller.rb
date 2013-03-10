class MsgsController < ApplicationController
  before_action :set_msg, only: [:show, :edit, :update, :destroy]

  # GET /msgs
  # GET /msgs.json
  def index
    @msgs = Msg.all
  end

  # GET /msgs/1
  # GET /msgs/1.json
  def show
  end

  # GET /msgs/new
  def new
    @msg = Msg.new
    @msg.room = "default"
  end

  # GET /msgs/1/edit
  def edit
  end

  # POST /msgs
  # POST /msgs.json
  def create
    @msg = Msg.new(msg_params)

    respond_to do |format|
      if @msg.save
        format.html { redirect_to @msg, notice: 'Msg was successfully created.' }
        format.json { render action: 'show', status: :created, location: @msg }
      else
        format.html { render action: 'new' }
        format.json { render json: @msg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /msgs/1
  # PATCH/PUT /msgs/1.json
  def update
    respond_to do |format|
      if @msg.update(msg_params)
        format.html { redirect_to @msg, notice: 'Msg was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @msg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /msgs/1
  # DELETE /msgs/1.json
  def destroy
    @msg.destroy
    respond_to do |format|
      format.html { redirect_to msgs_url }
      format.json { head :no_content }
    end
  end

  class SSE
    def initialize io
      @io = io
    end

    def write(args)
      args.each do |k,v|
        if v.class==Hash
          v = JSON.dump(v)
        end
        @io.write "#{k}: #{v}\n"
      end
      @io.write "\n"
    end

    def close
      @io.close
    end
  end

  def chat
    @room = params[:room]
    @msg = Msg.new(:room=>@room)
  end

  include ActionController::Live
  def watch
    room          = params[:room]
    last_event_id = (request.headers["Last-Event-ID"] || 0).to_i

    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    begin
      counter = 0
      loop do
        counter += 1
        sse.write(:data=>{"debug"=>"counter=#{counter}"})

        Msg.connection.clear_query_cache
        @msgs = Msg.fetch_next(room, last_event_id)
        if @msgs.empty?
          sleep(1)
        else
          @msgs.each do |msg|
            args = {
              :id   => msg.id,
              :data => {:id=>msg.id, :room=>msg.room, :sender=>msg.sender, :body=>msg.body}
            }
            sse.write(args)
          end
          last_event_id = @msgs.last.id
        end
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_msg
      @msg = Msg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def msg_params
      params.require(:msg).permit(:room, :sender, :body)
    end
end
