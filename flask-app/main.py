from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello():
    return 'Hello world with Flask'

@app.route("/healthz")
def healthz():
    # Always return 200 OK for health checks
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
