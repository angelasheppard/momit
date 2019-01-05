class Log
	def self.debug(current_user, message, *objects)
		self.write('DEBUG', current_user, message, objects)
	end

	def self.info(current_user, message, *objects)
		self.write('INFO', current_user, message, objects)
	end

	def self.notice(current_user, message, *objects)
		self.write('NOTICE', current_user, message, objects)
	end

    def self.warn(current_user, message, *objects)
        self.write('WARN', current_user, message, objects)
    end

    def self.alert(current_user, message, *objects)
        self.write('ALERT', current_user, message, objects)
    end

	def self.error(current_user, message, *objects)
		self.write('ERROR', current_user, message, objects)
	end

	def self.write(level, current_user, message, objects)
		@@log ||= File.open("#{Rails.root}/log/activity.log", "a")
		@@log.sync = true
		datetime = Time.now.strftime(LONG_TIMESTAMP_FORMAT)
        if objects[0].is_a? Hash
            diffs = objects[0]
            diffs.except!('updated_at','created_at')
        elsif objects.size == 1
            diffs = self.compute_diff_string(objects[0], nil)
        elsif objects.size == 2
            diffs = self.compute_diff_string(objects[0], objects[1])
        end
		username = current_user.is_a?(User) ? current_user.username : current_user
		@@log.puts("#{datetime}\t[#{level}]\t#{username}\t#{message}\t#{diffs}")

        if level == 'ERROR'
            begin
                NotificationMailer.error_email(username, message, diffs).deliver_now
            end
        elsif level == 'ALERT'
            begin
                NotificationMailer.alert_email(username, message, diffs).deliver_now
            end
        end
	end

    def self.server_error(exception, params, request, session, cookies)
		@@server_error_log ||= File.open("#{Rails.root}/log/server_errors.log", "a")
		@@server_error_log.sync = true
        @@server_error_log.puts("################################################################################
		#{Time.now.strftime(LONG_TIMESTAMP_FORMAT)}

		#{exception.message.inspect}

		==============Exception Backtrace==============
		#{exception.backtrace.join("\n")}

		===============Post/Get Params:================
		#{params.collect{|key,value| "#{key}: #{value}"}.join("\n")}

		====================Request====================
		SERVER_NAME: #{request['SERVER_NAME']}
		REQUEST_METHOD: #{request['REQUEST_METHOD']}
		REQUEST_PATH: #{request['REQUEST_PATH']}
		REQUEST_URI: #{request['REQUEST_URI']}
		HTTP_VERSION: #{request['HTTP_VERSION']}
		HTTP_HOST: #{request['HTTP_HOST']}
		SERVER_PORT: #{request['SERVER_PORT']}
		QUERY_STRING: #{request['QUERY_STRING']}
		HTTP_USER_AGENT: #{request['HTTP_USER_AGENT']}
		REMOTE_ADDR: #{request['REMOTE_ADDR']}
		HTTP_REFERER: #{request['HTTP_REFERER']}

		====================Session====================
		#{session.to_hash.collect{|key,value| "#{key}: #{value.is_a?(String) ? value : value.inspect}"}.join("\n")}

		====================Cookies====================
		#{cookies.collect{|key,value| "#{key}: #{value}"}.join("\n")}

		################################################################################")
    end

	private

	def self.compute_diff_string(new_obj, old_obj)
		string = ''
		return string if new_obj.nil?
		name_exclusions = ['id','created_at','updated_at','current_sign_in_ip','last_sign_in_ip',
		                    'encrypted_password','reset_password_token']

		if old_obj.nil?
			new_obj.class.attribute_names.each do |attr_name|
			    next if attr_name.blank? || name_exclusions.include?(attr_name)
				string = string + " | #{attr_name}:#{new_obj.send(attr_name)}"
			end
		else
			new_obj.class.attribute_names.each do |attr_name|
			    next if attr_name.blank? || name_exclusions.include?(attr_name)
                new_val = new_obj.send(attr_name)
                old_val = old_obj.send(attr_name)
                new_val.sort! if new_val.is_a?(Array)
                old_val.sort! if old_val.is_a?(Array)
				if new_val != old_val
					string = string + " | #{attr_name}:#{old_val}->#{new_val}"
				end
			end
		end

		string.gsub!(/^ \| /, '')
        if string == ''
            string = 'No fields changed'
        end
		return string
	end
end
# -*- SkipSchemaAnnotations
