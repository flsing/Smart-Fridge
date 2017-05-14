# import psycopg2
from flask import Flask, request, render_template, url_for
# from flask import redirect, url_for
from flask_sqlalchemy import SQLAlchemy
# from models import Ingredient, Admin, Chef, RegularUser

# conn = psycopg2.connect(database="fsing047", user="fsing047", password="Lallouz24",host="web0.site.uottawa.ca", port="15432")
# cursor = conn.cursor()


app = Flask(__name__)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://fsing047:*******@web0.site.uottawa.ca:15432/fsing047'
db = SQLAlchemy(app)

print(app)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if request.form['username'] != app.config['USERNAME']:
            error = 'Invalid username'
        elif request.form['password'] != app.config['PASSWORD']:
            error = 'Invalid password'
        else:
            session['logged_in'] = True
            flash('You were logged in')
            return redirect(url_for('show_entries'))
    return render_template('login.html', error=error)

@app.route('/pickUser')
def pickUser():
    return render_template('pickUser.html')

@app.route('/user')
def user():
    return render_template('user.html')

@app.route('/admin')
def admin():
    return render_template('admin.html')

@app.route('/chef')
def chef():
    return render_template('chef.html')

@app.route('/userIngredientList')
def show_entries():

    cur = app.execute('select title, text from entries order by id desc')
    entries = cur.fetchall()
    return render_template('userIngredientList.html', entries=entries)

@app.route('/userAddIngredients', methods=['POST'])
def add_entry():
    if not session.get('logged_in'):
        abort(401)

    app.execute('insert into entries (title, text) values (?, ?)',
                 [request.form['title'], request.form['text']])
    db.commit()
    flash('New entry was successfully posted')
    return redirect(url_for('show_entries'))


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
