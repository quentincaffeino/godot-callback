
extends Reference

const errors = preload('../assets/translations/errors.en.gd').messages
const ArrayUtils = preload('../vendor/quentincaffeino/array-utils/src/Utils.gd')


enum TYPE \
{
	UNKNOWN,
	VARIABLE,
	METHOD
}

# @var  Reference
var _target

# @var  string
var _name

# @var  int
var _type


# @param  Reference  target
# @param  string     name
# @param  int        type
func _init(target, name, type = UNKNOWN):
	self._target = target
	self._name = name

	if type == UNKNOWN:
		type = self.getType(self._target, self._name)

	self._type = type


func getTarget():  # Reference
	return self._target


func getName():  # string
	return self._name


# Ensure callback target exists
func ensure():  # boolean
	if self._target:
		var wr = weakref(self._target)
		if wr.get_ref() == null:
			print(errors['qc.callback.ensure.target_destroyed'] % self._name)
			return false
	else:
		print(errors['qc.callback.ensure.target_destroyed'] % self._name)
		return false

	if self.getType(self._target, self._name) == UNKNOWN:
		print(errors['qc.callback.target_missing_mv'] % [ self._target, self._name ])
		return false

	return true


# @param  Variant[]  argv
func call(argv = []):  # Variant
	argv = ArrayUtils.toArray(argv)

	# Ensure callback target still exists
	if !ensure():
		print(errors['qc.callback.call.ensure_failed'] % [ self._target, self._name ])
		return

	# Execute call
	if self._type == VARIABLE:
		self._target.set(self._name, argv[0])
		return self._target.get(self._name)

	elif self._type == METHOD:
		return self._target.callv(self._name, argv)
	
	print(errors['qc.callback.call.unknown_type'] % [ self._target, self._name ])


# @param  Reference  target
# @param  string     name
# @param  int        type
static func canCreate(target, name, type = UNKNOWN):  # int
	if typeof(target) != TYPE_OBJECT:
		print(errors['qc.callback.canCreate.first_arg'] % str(typeof(target)))
		return UNKNOWN

	if typeof(name) != TYPE_STRING:
		print(errors['qc.callback.canCreate.second_arg'] % str(typeof(name)))
		return UNKNOWN

	if type <= UNKNOWN or type > TYPE.size():
		type = getType(target, name)

		if type == UNKNOWN:
			print(errors['qc.callback.target_missing_mv'] % [ target, name ])

	return type


# @param  Reference  target
# @param  string     name
static func getType(target, name):  # int
	# Is it a METHOD
	if target.has_method(name):
		return METHOD

	# Is it a VARIABLE
	if name in target:
		return VARIABLE

	return UNKNOWN
