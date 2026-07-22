class_name ShipmentClass extends RefCounted

# Items included in the shipment and their quantities.
var shipment: Dictionary[Plant, int]
# Currency included with the shipment.
var payment: Dictionary

# Callback executed when the shipment is accepted.
var on_accepted: Callable
# Callback executed when the shipment is rejected.
var on_rejected: Callable

# Emitted when the shipment is accepted by the receiver.
signal accepted
# Emitted when the shipment is rejected by the receiver.
signal rejected

# Represents the current state of the shipment.
enum Status {
	PENDING, # Shipment has been created but not resolved.
	ACCEPTED, # Shipment has been accepted by the receiver.
	REJECTED, # Shipment has been rejected by the receiver.
}

# Current state of the shipment lifecycle.
var _status: Status = Status.PENDING

const RECEIPT_METHOD := &"shipment_receipt"

## Initializes the shipment.
## <_on_accepted> is called when the shipment is accepted.
## <_on_rejected> is called when the shipment is rejected.
func _init(_on_accepted, _on_rejected) -> void:
	on_accepted = _on_accepted
	on_rejected = _on_rejected

# Ships to a receiver that has <RECEIPT_METHOD>, returns an Error.
func ship_to(receiver) -> Error:
	if receiver == null:
		return ERR_INVALID_PARAMETER
		
	if receiver.has_method(RECEIPT_METHOD):
		receiver.call(RECEIPT_METHOD, self)
		return OK
	else:
		return ERR_METHOD_NOT_FOUND
	

# Accepts the shipment, then runs the callback previously defined.
func accept(...response):
	if _status != Status.PENDING:
		return
	
	_status = Status.ACCEPTED
	
	if on_accepted.is_valid():
		on_accepted.callv(response)
	accepted.emit()

# Rejects the shipment, then runs the callback previously defined.
func reject(...response):
	if _status != Status.PENDING:
		return
		
	_status = Status.REJECTED
	
	if on_rejected.is_valid():
		on_rejected.callv(response)
	rejected.emit()
	
# Returns the current status.
func get_status() -> Status:
	return _status
	
