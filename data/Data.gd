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
			
	
	func serialize() -> Dictionary:
		var ser_people = []
		for p in people:
			ser_people.append(p.serialize())
		return {
			"name": name,
			"people": ser_people
		}
	
	
	func deserialize(d: Dictionary) -> bool:
		if !("name" in d) or !(d["name"] is String):
			print("[ ERROR ] 'name' not found while deserializing Debitarium")
			return false
			
		if !("people" in d) or !(d["people"] is Array):
			print("[ ERROR ] 'people' not found while deserializing Debitarium")
			return false
			
		name = d["name"]
		var ser_people = d["people"]
		for ser_p in ser_people:
			var p = Person.new("")
			if !p.deserialize(ser_p):
				return false
			people.append(p)
		
		return len(name) > 0 and len(people) > 0
	

class Person:
	var name: String
	var balance: Balance
	
	func _init(_name: String):
		name = _name
		balance = Balance.new()
		
		
	func serialize() -> Dictionary:
		return {
			"name": name,
			"balance": balance.serialize()
		}
	
	func deserialize(d: Dictionary) -> bool:
		if !("name" in d) or !(d["name"] is String):
			print("[ ERROR ] 'name' not found while deserializing Person")
			return false
			
		if !("balance" in d) or !(d["balance"] is Array):
			print("[ ERROR ] 'balance' not found while deserializing Person")
			return false
			
		name = d["name"]
		if !balance.deserialize(d["balance"]):
			return false
		
		return true
		

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

	func serialize() -> int:
		return tot_cents
		
	
	func deserialize(v: int) -> bool:
		tot_cents = v
		return true
		
		
class Transaction:
	var cash: Cash
	var description: String
	
	func _init(_cash: Cash, _desc: String):
		cash = _cash
		description = _desc
	
	func serialize() -> Dictionary:
		return {
			"cash": cash.serialize(),
			"description": description
		}
		
	func deserialize(d: Dictionary) -> bool:
		if !("cash" in d) or !(d["cash"] is int):
			print("[ ERROR ] 'cash' not found while deserializing Transaction")
			return false
		if !("description" in d) or !(d["description"] is String):
			print("[ ERROR ] 'description' not found while deserializing Transaction")
			return false
			
		if !cash.deserialize(d["cash"]):
			return false
			
		description = d["description"]
		
		return true
		
		
class Balance:
	var transactions: Array # of Transaction

	func _init():
#		# DEBUG
		transactions.append(Transaction.new(Cash.new(1, 0, true), "swag"))
		transactions.append(Transaction.new(Cash.new(2, 50, false), "less swag"))
		pass
	
	
	func serialize() -> Array:
		var ser_transactions = []
		for t in transactions:
			ser_transactions.append(t.serialize())
		return ser_transactions
		
		
	func deserialize(arr: Array) -> bool:
		for ser_t in arr:
			var t = Transaction.new(Cash.new(0, 0, false), "")
			if !t.deserialize(ser_t):
				return false
			transactions.append(t)
		return true
		
	
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

