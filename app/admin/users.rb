ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :avatar
  
  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :avatar, as: :file
      f.input :admin
    end
    f.actions
  end
  
  show do
    attributes_table do
      row :id
      row :email
      row :avatar do |user|
        image_tag(user.avatar.variant(resize_to_fit: [50,50])) if user.avatar.attached?
      end
      row :created_at
      row :updated_at
    end
  end
  
  index do
    selectable_column
    id_column
    column :email
    column :avatar do |user|
      if user.avatar.attached? && user.avatar.variable?
        image_tag(user.avatar.variant(resize_to_fit: [50, 50]))
      end
    end
    column :created_at
    column :updated_at
    column :admin
    actions
  end

  controller do
   def create
  super do |success, failure|
    success.html do
      user = resource.reload
      if params[:user][:avatar].present?
        Rails.logger.debug("User avatar present, attaching...")
        user.avatar.attach(params[:user][:avatar])
      end
      redirect_to admin_user_path(user), notice: "User was successfully created."
    end
    failure.html do
      render :new
    end
  end
end
    
    def update
      super do |success, failure|
        success.html do
          user = resource.reload
          if params[:user][:avatar].present?
            user.avatar.attach(params[:user][:avatar])
          end
          user.save
          redirect_to admin_user_path(user), notice: "User was successfully updated."
        end
        failure.html do
          render :edit
        end
      end
    end

    def destroy
      if resource.id == current_user.id
        redirect_to admin_user_path(resource), alert: "Cannot delete active user."
      else
        super
      end
    end
  end
end
