extends CanvasLayer

@onready var coin_display: Label = $CoinDisplay
@onready var health_display: Label = $HealthDisplay
var player : Player

func _ready():
	Global.gained_coins.connect(update_coin_display)


func update_coin_display():
	coin_display.text = "Coins: " + str(Global.coins)

func update_health_display():
	health_display.text = "Health left:" + str(Global.player.max_health)
