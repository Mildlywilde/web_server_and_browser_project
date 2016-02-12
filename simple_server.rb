require 'socket'

class Server

	def initialize
		@server = TCPServer.open(2000)
		loop {
			@client = @server.accept
			response = recieve_request
			@client.puts response
			@client.close
		}
	end

	def recieve_request
		puts "recieving..."
		request = @client.read_nonblock(1000).split " "
		puts request
		request_type = request[0]
		path = request[1]
		version = request[2]

		if request[0] == "GET"
			get(request[1], request[2])
		else
			"Invalid Request"
		end
	end

	def get(path, version)
		puts "getting"
		if File.exists?(path)
			body = File.open(path, "r") { |f| f.read }
			code = "200 OK"
			header = File.size?(path)
			http_version = version
		else
			body = "Not Found"
			code = "404 FILE NOT FOUND"
		end

		response = version + code
		response += "\r\n#{header}"
		response += "\r\n\r\n"
		response += body
		response
	end

end
simple = Server.new
