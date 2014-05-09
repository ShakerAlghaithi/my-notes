module NotesHelper

	def check_note_owner
    note = current_user.notes.where(:id => params[:id]).first
    
    if note.nil?
      flash[:error] = "That's not yours!"
      redirect_to note_path(params[:id])
    end
  end

end
