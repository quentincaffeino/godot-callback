
extends Reference

const Utils = preload('./Utils.gd')
const Callback = preload('./Callback.gd')
const FuncRefCallback = preload('./FuncRefCallback.gd')
const errors = preload('../assets/translations/errors.en.gd').messages
 

# @var  Reference
var _target

# @var  string|null
var _name

# @var  int
var _type


# @param  Reference  target
func _init(target):
	self._target = target


# @param  string  name
func setName(name):  # CallbackBuilder
	self._name = name


func build():  # Callback|null
	if typeof(self._target) != TYPE_OBJECT:
		print(errors['qc.callback.canCreate.first_arg'] % str(typeof(self._target)))
		return null

	if Utils.isFunkRef(self._target):
		return FuncRefCallback.new(target, Utils.Type.METHOD)

	if typeof(name) != TYPE_STRING:
		print(errors['qc.callback.canCreate.second_arg'] % str(typeof(name)))
		return null

	var type = getType(target, name)
	if type == Utils.Type.UNKNOWN:
		print(errors['qc.callback.target_missing_mv'] % [ target, name ])
		return null

	return Callback.new(target, name, type)
