# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
    def update
        self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
        prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

        resource_updated = update_resource(resource, account_update_params)
        yield resource if block_given?
        if resource_updated
            if is_flashing_format?
                flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
                :update_needs_confirmation : :updated
                set_flash_message :notice, flash_key
            end
            bypass_sign_in resource, scope: resource_name
            Log.info(current_user, "Updated profile", resource.previous_changes)
            respond_with resource, location: after_update_path_for(resource)
        else
            Log.warn(current_user, "Failed to update profile: #{resource.errors.full_messages}")
            clean_up_passwords resource
            set_minimum_password_length
            respond_with resource
        end
    end

    # DELETE /resource
    def destroy
        if resource.destroy
            Log.info(current_user, "Cancelled account")
            Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
            set_flash_message! :notice, :destroyed
            yield resource if block_given?
            respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
        else
            Log.warn(current_user, "Failed to cancel account: #{resource.errors.full_messages}")
        end
    end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
   def after_inactive_sign_up_path_for(resource)
       Log.info(current_user, "Registration created", resource)
       super(resource)
   end

   # def after_update_path_for(resource)
   #     super(resource)
   # end
end
