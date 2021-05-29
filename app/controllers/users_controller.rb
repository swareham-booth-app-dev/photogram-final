class UsersController < ApplicationController
  def index
    @all_users = User.all

    @all_users = @all_users.order({ :username => :asc })

    render({ :template => "users/index.html.erb" })
  end

  def show
    the_username = params.fetch("username")

    matching_users = User.where({ :username => the_username })
    @the_user = matching_users.at(0)

    session_user_is_follower = false
    @the_user.followers.each do |follower|
      if follower.id = @the_user.id
        session_user_is_follower = true
      end
    end


    # Allowed to view if public user or if its you or if you're already following them
    
    if session[:user_id] == @the_user.id || !@the_user.private  || session_user_is_follower
      render({ :template => "users/show.html.erb" })
    else
      redirect_to("/users", { :alert => "You're not authorized for that."})
    end

    
  end

  def create
    the_photo = Photo.new
    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch("query_image")
    the_photo.owner_id = params.fetch("query_owner_id")
    the_photo.location = params.fetch("query_location")
    the_photo.likes_count = params.fetch("query_likes_count")
    the_photo.comments_count = params.fetch("query_comments_count")
    the_photo.likes_count = params.fetch("query_likes_count")
    the_photo.comments_count = params.fetch("query_comments_count")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully." })
    else
      redirect_to("/photos", { :notice => "Photo failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch("query_image")
    the_photo.owner_id = params.fetch("query_owner_id")
    the_photo.location = params.fetch("query_location")
    the_photo.likes_count = params.fetch("query_likes_count")
    the_photo.comments_count = params.fetch("query_comments_count")
    the_photo.likes_count = params.fetch("query_likes_count")
    the_photo.comments_count = params.fetch("query_comments_count")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => "Photo failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end
end