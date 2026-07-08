web: python -c "import http.server, os; http.server.HTTPServer(('0.0.0.0', int(os.environ.get('PORT', 8080))), http.server.BaseHTTPRequestHandler).serve_forever()"
worker: for d in $(seq -w 1 95); do python main2.py $d; done
python main2.py 2A
python main2.py 2B
for d in 971 972 973 974 975 976; do python main2.py $d; done
for d in 977 978 984 986 987 988; do python main2.py $d; done
