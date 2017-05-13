# import psycopg2
from flask import Flask, request, render_template
# from flask import redirect, url_for
from flask_sqlalchemy import SQLAlchemy
# from models import Ingredient, Admin, Chef, RegularUser

# conn = psycopg2.connect(database="fsing047", user="fsing047", password="Lallouz24",host="web0.site.uottawa.ca", port="15432")
# cursor = conn.cursor()


app = Flask(__name__)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://fsing047:Lallouz24@web0.site.uottawa.ca:15432/fsing047'
db = SQLAlchemy(app)


@app.route('/')
def index():
    return render_template('index.html')


# @app.route('/post_ingredient')# methods=['POST'])
# def post_ingredient():
#     ingr = None
#     if request.method == 'POST':
#         ingr = Ingredient(request.form['Ingredient'], request.form['Quantity'])
#         db.session.add(ingr)
#         db.session.commit()
#         return render_template('userIngredientList.html')
#     return render_template('userIngredientList.html')

# @app.route('/all_ingredient', methods=['GET','POST'])
# def all_ingredient():
#     ing = Ingredient.query.filter_by(ingredient=ingredient).first()
#     ingr = db.session.query(Ingredient).all()
#     return render_template('userIngredientList.html', ingr=ingr,ing=ing)


if __name__ == "__main__":
    app.debug = True
    app.run()
