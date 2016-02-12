require 'socket'
require 'json'

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
		request_type = request[0]
		path = request[1]
		version = request[2]

		if request[0] == "GET"
			get(request[1], request[2])
		elsif request[0] == "POST"
			post(request)
		else
			return %{#{version} 400 BAD_REQUEST}
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
			code = "404 FILE_NOT_FOUND"
		end

		response = version + code
		response += "\r\n#{header}"
		response += "\r\n\r\n"
		response += body
		response
	end

	def post(input)
		puts "Posting..."
		params = JSON.parse(input[-1])
		data = File.open(input[1], "r") { |f| f.read }
		posted_data = ""
		params.each do |val|
			val.each do |key, val2|
				posted_data += "<li>#{key}: #{val2}</li>\n\t\t\t"
			end
		end
		data.gsub!('<%= yield %>', posted_data)
		header = data.length

		response = input[2] + "200 OK"
		response += "\r\n#{header}"
		response += "\r\n\r\n#{data}"
		response
	end

end
simple = Server.new
