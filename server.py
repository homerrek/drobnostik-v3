#!/usr/bin/env python3
# server.py — Drobnostík v3 dev server
# Použití: python3 server.py [port]

import sys
import os
import mimetypes
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
ROOT = os.path.dirname(os.path.abspath(__file__))

MIME = {
    '.html': 'text/html; charset=utf-8',
    '.css':  'text/css',
    '.js':   'application/javascript',
    '.json': 'application/json',
    '.svg':  'image/svg+xml',
    '.png':  'image/png',
    '.jpg':  'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.webp': 'image/webp',
    '.gif':  'image/gif',
    '.ico':  'image/x-icon',
    '.woff': 'font/woff',
    '.woff2':'font/woff2',
    '.ttf':  'font/ttf',
    '.map':  'application/json',
    '.toml': 'text/plain',
    '.txt':  'text/plain',
    '.xml':  'application/xml',
}

# ANSI colors
GREEN  = '\033[92m'
YELLOW = '\033[93m'
RED    = '\033[91m'
RESET  = '\033[0m'

class SPAHandler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        code = args[1] if len(args) > 1 else '?'
        try:
            c = int(code)
            color = GREEN if c < 300 else (YELLOW if c < 400 else RED)
        except:
            color = RESET
        print(f"{color}[{self.address_string()}] {fmt % args}{RESET}")

    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path.rstrip('/')
        if not path:
            path = '/'

        # Try exact file first
        filepath = os.path.join(ROOT, path.lstrip('/'))
        if os.path.isfile(filepath):
            self.serve_file(filepath)
            return

        # Try with .html extension
        if not os.path.splitext(filepath)[1]:
            html_path = filepath + '.html'
            if os.path.isfile(html_path):
                self.serve_file(html_path)
                return

        # SPA fallback — serve index.html for all unknown paths
        index = os.path.join(ROOT, 'index.html')
        if os.path.isfile(index):
            self.serve_file(index)
        else:
            self.send_error(404, 'index.html not found')

    def serve_file(self, filepath):
        ext = os.path.splitext(filepath)[1].lower()
        content_type = MIME.get(ext, 'application/octet-stream')
        try:
            with open(filepath, 'rb') as f:
                data = f.read()
            self.send_response(200)
            self.send_header('Content-Type', content_type)
            self.send_header('Content-Length', str(len(data)))
            self.send_header('Cache-Control', 'no-cache')
            self.end_headers()
            self.wfile.write(data)
        except Exception as e:
            self.send_error(500, str(e))

if __name__ == '__main__':
    os.chdir(ROOT)
    httpd = HTTPServer(('', PORT), SPAHandler)
    print(f"{GREEN}Drobnostík dev server běží na http://localhost:{PORT}{RESET}")
    print(f"{YELLOW}Ctrl+C pro zastavení{RESET}")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print(f"\n{YELLOW}Server zastaven.{RESET}")
