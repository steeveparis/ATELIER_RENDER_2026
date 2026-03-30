from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def home():
    return "Ceci est le site web pour afficher sur Render"

@app.route("/health")
def health():
    return {"status": "Tout est ok ou pas"}

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))
    app.run(host="0.0.0.0", port=port)

@app.route("/info")
def info():
    return {
        "app": "Flask Render",
        "student": "steeveparis",
        "version": "v1"
    }

@app.route("/env")
def env():
    return {"env": os.getenv("ENV")}
