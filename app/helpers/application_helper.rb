module ApplicationHelper
	def error_messages_for(object)
		render(:partial => 'shared/error_messages', :locals => {:object => object})
	end

  	# Replace with alt value if data is nil or an empty string.
  	def nilOrEmpty(data, alt)
  		if data == nil || data.length == 0
  			alt
  		else
  			data
  		end
  	end

end
