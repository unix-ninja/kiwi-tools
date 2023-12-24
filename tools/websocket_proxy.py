#!/usr/bin/python3
# proxy server for web sockets
# make sure websocket-client is installed

import argparse
import re
import sys
from http.server import SimpleHTTPRequestHandler
from socketserver import TCPServer
from urllib.parse import unquote, urlparse
from websocket import create_connection

############################################################
# Configs

############################################################
# Functions

def send_ws(payload):
	ws = create_connection(args.target)
	# If the server returns a response on connect, use below line
	#resp = ws.recv() # If server returns something like a token on connect you can find and extract from here

	# For our case, format the payload in JSON
	message = unquote(payload).replace('"','\'') # replacing " with ' to avoid breaking JSON structure
	data = '{"employeeID":"%s"}' % message

	ws.send(data)
	resp = ws.recv()
	ws.close()

	if resp:
		return resp
	else:
		return ''

def middleware_server(host_port,content_type="text/plain"):

	class CustomHandler(SimpleHTTPRequestHandler):
		def do_GET(self) -> None:
			self.send_response(200)
			try:
				payload = urlparse(self.path).query.split('=',1)[1]
			except IndexError:
				payload = False

			if payload:
				content = send_ws(payload)
			else:
				content = 'No parameters specified!'

			self.send_header("Content-type", content_type)
			self.end_headers()
			self.wfile.write(content.encode())
			return

	class _TCPServer(TCPServer):
		allow_reuse_address = True

	httpd = _TCPServer(host_port, CustomHandler)
	httpd.serve_forever()

############################################################
# Parse options
parser = argparse.ArgumentParser(description='Websocket proxy server')
parser.add_argument(dest='target', help='target websocket URL endpoint')
args = parser.parse_args()

############################################################
# Main App

# validate our web socket
args.target = re.sub("^https?:", "ws:", args.target)

if not re.match("^ws://", args.target):
  print("[!] Invalid websocket URL.")
  sys.exit(1)

# start the proxy
print("[+] Starting websocket proxy server.")
print("[+] Send payloads in http://localhost:8081/?id=*")

try:
	middleware_server(('0.0.0.0',8081))
except KeyboardInterrupt:
	pass
