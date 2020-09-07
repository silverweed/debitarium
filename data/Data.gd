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
		
	
class Balance:
	var transactions: Array # of Cash

	func calc_balance() -> Cash:
		var result = Cash.new(0, 0, false)
		for t in transactions:
			assert(t is Cash and t != null)
			result = result.sum(t)
		return result
		

# represents one monetary value
class Cash:
	var tot_cents: int
	
	func _init(_ints: int, _cents: int, neg: bool):
		assert(_ints >= 0)
		assert(_cents >= 0 and _cents < 100)
		tot_cents = _cents + _ints * 100
		if neg:
			tot_cents *= -1
	
		
	func sum(other: Cash) -> Cash:
		var new_tot_cents = tot_cents + other.tot_cents
		var new_ints = abs(int(new_tot_cents / 100))
		var new_cents = abs(int(new_tot_cents % 100))
		var new_neg = new_tot_cents < 0
		return Cash.new(new_ints, new_cents, new_neg)
		
	
	func positive_ints() -> int:
		return int(abs(tot_cents) / 100)
	
	func positive_cents() -> int:
		return int(abs(tot_cents)) % 100
	
	func is_neg() -> bool:
		return tot_cents < 0
		
	func to_str() -> String:
		var st = "-" if is_neg() else ""
		st += str(positive_ints())
		if positive_cents() > 0:
			st += ",%d" % positive_cents()
		st += "€"
		return st
