import SocketServer
import SimpleHTTPServer
import urllib
PORT = 23
class MyProxy(SimpleHTTPServer.SimpleHTTPRequestHandler):
  def do_GET(self):
    url=self.path[1:]
    self.send_response(200)
    self.end_headers()
    self.copyfile(urllib.urlopen(url), self.wfile)
httpd = SocketServer.ForkingTCPServer(('', PORT), MyProxy)
print ("Now serving at %s" % str(PORT))
httpd.serve_forever()
