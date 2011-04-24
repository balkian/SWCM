require 'socket'

numCon = 0
maxCon = 10

def respond(socket, code, body)   # Genera respuestas
  socket.puts "HTTP/1.0 #{ code }"
  socket.puts "Content-type: text/html"
  socket.puts "Content-length: #{ body.length }"
  socket.puts
  socket.puts body
  socket.close
end

server = TCPServer.open(8080)
puts "web server created at port 8080"
loop do
  if(numCon < maxCon)					# Si no se ha superado el número máximo de hebras
	sock = server.accept				# Acepta conexión del cliente
	t = Thread.new(sock) do |socket|
		numCon=numCon+1					
		request = socket.gets            # Lee la primera línea
		o = socket.gets until ( o != "") # cabecera acaba con línea vacía

		unless request =~ /^GET/          # Si el comando no esta soportado
			respond socket, "400 Bad Request", "<html><body><h1>Comando desconocido</h1></body></html>" 
			next                            # Acaba el ciclo
		end
		request =~ /^GET \/(.*) .*/       # GET /(fichero) HTTP/1.x
		path = $1
		if path == "" || path =~ /\/$/ then path += "index.html" end  # Inserta index.html
		if File.exists?(path)
			file = open(path)               # Lee fichero y prepara respuesta
			puts "OK #{ path }"
			respond socket, "200 OK", file.read
		else
			puts "NotFound #{ path }"       # Si el fichero no existe
			respond socket, "404 Not Found", "<html><body><h1>Recurso no encontrado</h1></body></html>" 
		end
		numCon=numCon-1;
	  end
  end
end


