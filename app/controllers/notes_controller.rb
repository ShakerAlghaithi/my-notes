class NotesController < ApplicationController
   
      include NotesHelper

  before_filter :signed_in_user, only: [:create, :new, :edit, :update, :destroy]
  before_filter :check_note_owner, only: [:edit, :update, :destroy]
   def index
      @notes = current_user.notes
      unless request.env['omniauth.auth'].nil?
        @token_id = request.env['omniauth.auth']["credentials"]["token"]
        current_user.update(token_id: @token_id)
      end
      
      unless current_user.token_id.nil? 
        client = Google::APIClient.new
        client.authorization.access_token = current_user.token_id
        service = client.discovered_api('calendar', 'v3')
           @result = client.execute(
                                 :api_method => service.calendar_list.list,
                                 :parameters => {},
                                 :headers => {'Content-Type' => 'application/json'})
            
       end
      
    end
   
    def new
        @note = current_user.notes.build
    end 
   
    def create
        @note = current_user.notes.create note_params
        @note.save
         
       if @note.save
          client = Google::APIClient.new
          client.authorization.access_token = current_user.token_id
          puts current_user.token_id
          service = client.discovered_api('calendar', 'v3')
            event = {
                     'summary' => @note.title,
                     'description' => @note.note,
                     'start' => {'date' =>(DateTime.now+1.week).rfc3339.split("T")[0]},
                     'end' => {'date' => (DateTime.now+1.week).rfc3339.split("T")[0]}
                   }
             result = client.execute(:api_method => service.events.insert,
                        :parameters => {'calendarId' => 'primary'},
                        :body => JSON.dump(event),
                        :headers => {'Content-Type' => 'application/json'})
         
             print result.data.id
         end
       
        redirect_to notes_path
        
    end
   
    def show 
        @note = Note.find(params[:id])
    end 
   
    def edit
        @note = Note.find(params[:id])
    end
   
    def update
       @note = Note.find(params[:id])
       @note.update note_params
       redirect_to note_path
    end
    
    def destroy
       Note.find(params[:id]).destroy
       redirect_to notes_path
    end
   
   private 
    def note_params
       params.require(:note).permit(:title, :note)
    end 
end
