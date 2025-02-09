import http.server
import socketserver
import json  # For pretty printing JSON (optional)

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])  # Get the size of data
        post_data = self.rfile.read(content_length)  # Read the data

        # Optional: Try to decode as JSON for pretty printing
        try:
            data = json.loads(post_data.decode('utf-8'))
            formatted_data = json.dumps(data, indent=4) # Pretty print
        except json.JSONDecodeError:
            formatted_data = post_data.decode('utf-8') # Fallback to plain text

        print("\n--- Received POST Data ---\n")
        print(formatted_data)
        print("\n--- End of Data ---\n")

        # Send a response back to the client (important!)
        self.send_response(200)  # 200 OK
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b"POST data received and printed to server console")  # Or any message

if __name__ == "__main__":
    PORT = 4444  # Choose your port
    Handler = MyHandler

    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print(f"Serving at port {PORT}")
        httpd.serve_forever()
