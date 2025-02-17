extends CanvasLayer

var InvSize = 16
var itemsLoad = [
	"res://scenes/items(resource)/1coin.tres"
]

func _ready():
	for i in InvSize:
		var slot := InventorySlot.new()
		slot.init(ItemData.Type.COINS, Vector2(32, 32))
		%inv.add_child(slot)
		
	for i in itemsLoad.size():
		var item := InventoryItem.new()
		item.init(load(itemsLoad[i]))
		%inv.get_child(i).add_child(item)
		
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		self.visable = !self.visable
