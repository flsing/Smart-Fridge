# coding: utf-8
from sqlalchemy import Boolean, CheckConstraint, Column, Date, ForeignKey, Integer, Numeric, SmallInteger, String, Table, Text, Time, text
from sqlalchemy.orm import relationship
from sqlalchemy.sql.sqltypes import NullType
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


t_access = Table(
    'access', metadata,
    Column('chef_id', ForeignKey(u'chef.chef_id')),
    Column('report_id', ForeignKey(u'report.report_id')),
    Column('admin_id', ForeignKey(u'admin.admin_id'))
)


class Admin(Base):
    __tablename__ = 'admin'
    __table_args__ = (
        CheckConstraint(u"(dob >= '1900-01-01'::date) AND (dob <= '1999-01-01'::date)"),
    )

    admin_id = Column(Numeric, primary_key=True)
    name = Column(String(30), nullable=False)
    dob = Column(Date, nullable=False)
    email = Column(String(320), nullable=False, unique=True)
    country = Column(String)

    orders = relationship(u'MealOrder', secondary='reviews')


class Chef(Base):
    __tablename__ = 'chef'

    chef_id = Column(Numeric, primary_key=True)
    name = Column(String(30), nullable=False)
    dob = Column(Date)
    email = Column(String(320), nullable=False, unique=True)
    country = Column(String)

    meals = relationship(u'Meal', secondary='creates')


t_creates = Table(
    'creates', metadata,
    Column('meal_id', ForeignKey(u'meal.meal_id')),
    Column('chef_id', ForeignKey(u'chef.chef_id'))
)


class Fridge(Base):
    __tablename__ = 'fridge'

    fridge_id = Column(Numeric, primary_key=True)
    adminid = Column(ForeignKey(u'admin.admin_id', ondelete=u'RESTRICT', onupdate=u'CASCADE'))
    temperature = Column(Numeric(5, 0), nullable=False)
    date = Column(Date, nullable=False)
    time = Column(Time(True), nullable=False)

    admin = relationship(u'Admin')


class IngrOrder(Base):
    __tablename__ = 'ingr_order'

    order_id = Column(Numeric, primary_key=True)
    creator_id = Column(ForeignKey(u'fridge.fridge_id'), ForeignKey(u'chef.chef_id'))
    ingr_id = Column(ForeignKey(u'ingredient.ingr_id'))
    count = Column(Integer)

    creator = relationship(u'Chef')
    creator1 = relationship(u'Fridge')
    ingr = relationship(u'Ingredient')


class Ingredient(Base):
    __tablename__ = 'ingredient'

    ingr_id = Column(Numeric, primary_key=True)
    name = Column(String(30), nullable=False)
    count = Column(SmallInteger)
    price_per_item = Column(NullType)
    threshold = Column(SmallInteger)
    date = Column(Date, server_default=text("now()"))


class Meal(Base):
    __tablename__ = 'meal'

    meal_id = Column(Numeric, primary_key=True)
    name = Column(String(300), nullable=False)
    description = Column(Text)


class MealOrder(Base):
    __tablename__ = 'meal_order'

    order_id = Column(Numeric, primary_key=True)
    creator_id = Column(ForeignKey(u'regular_user.reg_id'))
    meal_id = Column(ForeignKey(u'meal.meal_id'))
    count = Column(Integer)
    state = Column(Boolean)

    creator = relationship(u'RegularUser')
    meal = relationship(u'Meal')


t_meals = Table(
    'meals', metadata,
    Column('meal_id', ForeignKey(u'meal.meal_id')),
    Column('ingr_id', ForeignKey(u'ingredient.ingr_id')),
    Column('quantity', Integer)
)


t_orders = Table(
    'orders', metadata,
    Column('id', ForeignKey(u'admin.admin_id'), ForeignKey(u'regular_user.reg_id')),
    Column('order_id', ForeignKey(u'ingr_order.order_id'))
)


class RegularUser(Base):
    __tablename__ = 'regular_user'

    reg_id = Column(Numeric, primary_key=True)
    name = Column(String(30))
    dob = Column(Date, nullable=False)
    email = Column(String(320), nullable=False, unique=True)
    country = Column(String)


class Report(Base):
    __tablename__ = 'report'

    report_id = Column(Numeric, primary_key=True)
    name = Column(String(120))
    description = Column(Text)


t_requests = Table(
    'requests', metadata,
    Column('chef_id', ForeignKey(u'chef.chef_id')),
    Column('order_id', ForeignKey(u'ingr_order.order_id')),
    Column('fridge_id', ForeignKey(u'fridge.fridge_id')),
    Column('reg_id', ForeignKey(u'regular_user.reg_id'))
)


t_reviews = Table(
    'reviews', metadata,
    Column('order_id', ForeignKey(u'meal_order.order_id')),
    Column('admin_id', ForeignKey(u'admin.admin_id'))
)
