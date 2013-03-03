class SoundtracksController < ApplicationController
  
  def new
    @user = User.find(params[:user_id])
    @soundtrack = Soundtrack.new
    @soundtrack.build_user
   end

   def create
     @soundtrack = Soundtrack.new(params[:soundtrack])

     if @soundtrack.save
       render(:action => :show)
     else
       render(:action => :new)
     end
   end

   def show
   end

   def edit
   end

   def update
     if @soundtrack.update_attributes(params[:soundtrack])
       render(:action => :show)
     else
       render(:action => :edit)
     end
   end   
   
end
