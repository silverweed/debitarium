class_name Data
extends Object

class Debitarium:
	var name: String
	var people: Array # of Person

	func _init(_name: String, people_names: Array):
		name = _name
		for p in people_names:
			assert(p is String and p != null)
			people.append(Person.new(p))

class Person:
	var name: String
	var balance: Balance
	
	func _init(_name: String):
		name = _name
		balance = Balance.new()


# represents one monetary value
class Cash:
	var tot_cents: int
	
	static func from_cents(tot_cents: int) -> Cash:
		print("tot = ", tot_cents)
		var new_ints = abs(int(tot_cents / 100))
		var new_cents = abs(int(tot_cents % 100))
		var new_neg = tot_cents < 0
		return Cash.new(new_ints, new_cents, new_neg)
		
	func _init(_ints: int, _cents: int, neg: bool):
		assert(_ints >= 0)
		assert(_cents >= 0 and _cents < 100)
		tot_cents = _cents + _ints * 100
		if neg:
			tot_cents *= -1
	
		
	func sum(other: Cash) -> Cash:
		var new_tot_cents = tot_cents + other.tot_cents
		return from_cents(new_tot_cents)
		
	
	func positive_ints() -> int:
		return int(abs(tot_cents) / 100)
	
	func positive_cents() -> int:
		return int(abs(tot_cents)) % 100
	
	func is_neg() -> bool:
		return tot_cents < 0
		
	func is_zero() -> bool:
		return tot_cents == 0
		
	func to_str() -> String:
		var st = "-" if is_neg() else ""
		st += str(positive_ints())
		if positive_cents() > 0:
			st += ",%02d" % positive_cents()
		st += " €"
		return st
		
	func get_color() -> Color:
		if is_neg():
			return Color(215.0/255.0, 0.0, 0.0)
		elif is_zero():
			return Color.white
		else:
			return Color(5.0/255.0, 164.0/255.0, 0.0)

		
class Transaction:
	var cash: Cash
	var description: String
	
	func _init(_cash: Cash, _desc: String):
		cash = _cash
		description = _desc
		
		
class Balance:
	var transactions: Array # of Transaction

	func _init():
#		# DEBUG
		transactions.append(Transaction.new(Cash.new(1, 0, true), "swag"))
		transactions.append(Transaction.new(Cash.new(2, 50, false), "less swag"))
		pass
		
	
	func remove_transaction(t: Transaction):
		assert(t != null)
		var idx = transactions.find(t)
		assert(idx >= 0)
		transactions.remove(idx)
	
	
	# This should really return a Cash, but due to a bug in the gdscript compiler
	# it can't?
	func calc_balance() -> int:
		var result = 0
		for t in transactions:
			assert(t is Transaction and t != null)
			result += t.cash.tot_cents
		return result
#		var result = Cash.new(0, 0, false)
#		for t in transactions:
#			assert(t is Cash and t != null)
#			result = result.sum(t)
#		return result
		
