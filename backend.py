from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
db = SQLAlchemy(app)

class Pet(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	shelter_id = db.Column(db.Integer, db.ForeignKey('shelter.id'))
	name = db.Column(db.String(80))
	breed = db.Column(db.String(80))
	biography = db.Column(db.String(500))
	fundingDone = db.Column(db.Integer)
	fundingGoal = db.Column(db.Integer)

	def __repr__(self):
		return '<Pet %r>' % self.name
	
	def serialize(self):
		return {
			'id': self.id,
			'shelter_id': self.shelter_id,
			'name': self.name,
			'breed': self.breed,
			'biography': self.biography,
			'fundingDone': self.fundingDone,
			'fundingGoal': self.fundingGoal,
		}

class Shelter(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String(80))
	# pets = db.relationship('Pet', backref='shelter', 
	# 	lazy='dynamic')


	def __repr__(self):
		return '<Shelter %r>' % self.name

	def serialize(self):
		return {
			'id': self.id,
			'name': self.name,
		}

class User(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String(80))
	amount = db.Column(db.Integer)

	def __repr__(self):
		return '<User %r>' % self.name

	def serialize(self):
		return {
			'id': self.id,
			'name': self.name,
			'amount': self.amount,
		}

class Donations(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	user_id = db.Column(db.Integer)
	pet_id = db.Column(db.Integer)
	amount = db.Column(db.Integer)

	def serialize(self):
		return {
			'user_id': self.user_id,
			'pet_id': self.pet_id,
			'amount': self.amount,
		}




app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///animals.db'
db.create_all()
db.session.commit()


@app.route("/user", methods= ['POST'])
def user():
	json = request.get_json()
	u = User()
	u.name = json['name']
	u.amount = json['amount']
	db.session.add(u)
	db.session.commit()
	return jsonify(u.serialize())

@app.route("/addShelter", methods = ['POST'])
def addShelter():
	json = request.get_json()
	s = Shelter()

	s.name = json['name']

	db.session.add(s)
	db.session.commit()
	return jsonify(s.serialize())

@app.route("/deleteShelter", methods = ['DELETE'])
def removeShelter():
	json = request.get_json()
	s = Shelter()

@app.route("/addDonation", methods = ['POST'])
def addDonation():
	json = request.get_json()
	d = Donations()
	d.user_id = json['user_id']
	d.pet_id = json['pet_id']
	d.amount = json['amount']

	db.session.add(d)
	u = User.query.get(json['user_id'])
	u.amount = u.amount - int(json['amount'])

	p = Pet.query.get(json['pet_id'])
	p.fundingDone = p.fundingDone + int(json['amount'])
	db.session.commit()


	return jsonify(d.serialize())

@app.route("/")
def hello():
	return 'Hello, world!'

#get all pet IDs in a given shelter

@app.route("/getPets", methods = ['POST'])
def getPets():
	json = request.get_json()
	# print json.items()
	s = Shelter.query.get(json['id']) #fix later
	return jsonify(list(p.serialize() for p in s.pets))



@app.route("/pets")
def pets():
	petList = Pet.query.all()
	return jsonify(list(p.serialize() for p in petList))

@app.route("/shelters")
def shelters():
	shelterList = Shelter.query.all()
	return jsonify(list(s.serialize() for s in shelterList))

@app.route("/users")
def users():
	userList = User.query.all()
	return jsonify(list(u.serialize() for u in userList))



@app.route("/pet", methods = ['POST'])
def pet():
	json = request.get_json()
	p = Pet()

	print request
	print json
	
	p.name = json['name']
	p.breed = json['breed']
	p.shelter_id = json['shelter_id']
	p.biography = json['biography']
	p.fundingGoal = json['fundingGoal']
	p.fundingDone = json['fundingDone']

	db.session.add(p)
	db.session.commit()
	return jsonify(p.serialize())
	
@app.route("/update_funding", methods = ['POST'])
def update_funding():
	json = request.get_json()
	p = Pet.query.get(int(json['id']))
	p.fundingDone += int(json['amount'])
	db.session.commit()
	return jsonify(p.serialize())

@app.route("/update_user_funding", methods = ['POST'])
def update_user_funding():
	json = request.get_json()
	u = User.query.get(int(json['id']))
	u.funds += int(json['amount'])
	db.session.commit()
	return jsonify(u.serialize())

@app.route("/update_biography", methods = ['POST'])
def update_biography():
	json = request.get_json()
	p = Pet.query.get(int(json['id']))
	p.biography = json['biography']
	db.session.commit()
	return jsonify(p.serialize())

@app.route("/update_name", methods = ['POST'])
def update_name():
	json = request.get_json()
	p = Pet.query.get(int(json['id']))
	p.name = json['name']
	db.session.commit()
	return jsonify(p.serialize())
	
if __name__ == "__main__":
	app.run()
