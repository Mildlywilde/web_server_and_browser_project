require 'socket'
require 'json'

class Browser

	def initialize
		@host = 'localhost'
		@port = 2000
		@path = "index.html"
		start
	end

	def start
		puts "get or post?"
		command = gets.chomp
		case command
		when 'get'
			get
		when 'post'
			post
		else
			puts "unknown command"
		end
	end

	def get
		request = "GET #{@path} HTTP/1.0\r\n\r\n"

		make_request(request)
	end

	def post
		puts "what's your name?"
		name = gets.chomp
		puts "email?"
		email = gets.chomp
		post_hash = {:viking => {:name=>name, :email=>email}}

		body = post_hash.to_json
		headers = { "Content-Type" => "viking_info", "Content-Length" => body.length}

		request = "POST thanks.html HTTP/1.0"
		headers.each do |key, val|
			request += "\r\n#{key.to_s}: #{val.to_s}"
		end
		request += "\r\n\r\n #{body}"
		puts request
		make_request(request)
	end

	def make_request(request)
		socket = TCPSocket.open(@host, @port)
		socket.print(request)
		response = socket.read
		response_hash = response.split(" ")
		if response_hash[1] != 200
			puts response_hash[2]
		end

		headers,body = response.split("\r\n\r\n", 2)
		print body
	end
end

client = Browser.new