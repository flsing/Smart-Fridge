from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from app import app


print(app)
@app.route("/")
def home():
	return render_template("index.html")
	
@app.route("/")
def user_page():
	return render_template("")

