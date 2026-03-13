extends Node2D

## 即時顯示 GPS 座標的 Godot 2D 應用
## 使用 PraxisMapper GodotGPSPlugin (https://github.com/PraxisMapper/GodotGPSPlugin)

var gps_provider = null

# UI 參照
@onready var permission_button: Button = %PermissionButton
@onready var lat_label: Label = %LatLabel
@onready var lon_label: Label = %LonLabel
@onready var accuracy_label: Label = %AccuracyLabel
@onready var alt_label: Label = %AltLabel
@onready var speed_label: Label = %SpeedLabel
@onready var bearing_label: Label = %BearingLabel
@onready var status_label: Label = %StatusLabel


func _ready() -> void:
	# 非 Android 平台提示
	if OS.get_name() != "Android":
		status_label.text = "此應用需在 Android 裝置上執行才能取得 GPS"
		permission_button.disabled = true
		return

	get_tree().on_request_permissions_result.connect(_on_permission_result)
	permission_button.pressed.connect(_on_permission_button_pressed)

	# 若已授權則直接啟用
	var allowed = OS.request_permissions()
	if allowed:
		_enable_gps()


func _on_permission_button_pressed() -> void:
	status_label.text = "請求定位權限中..."
	OS.request_permissions()


func _on_permission_result(perm_name: StringName, was_granted: bool) -> void:
	if perm_name == "android.permission.ACCESS_FINE_LOCATION" and was_granted:
		_enable_gps()
	elif perm_name == "android.permission.ACCESS_FINE_LOCATION" and not was_granted:
		status_label.text = "未授權定位權限，無法取得 GPS"
		permission_button.text = "重試授權"


func _enable_gps() -> void:
	gps_provider = Engine.get_singleton("PraxisMapperGPSPlugin")
	if gps_provider == null:
		status_label.text = "GPS 插件未載入，請確認已啟用 PraxisMapperGPSPlugin 並匯出為 Android"
		permission_button.visible = false
		return

	gps_provider.onLocationUpdates.connect(_on_location_update)
	gps_provider.StartListening()

	status_label.text = "正在接收 GPS 訊號..."
	permission_button.visible = false


func _on_location_update(loc: Dictionary) -> void:
	# latitude, longitude, accuracy, altitude, verticalAccuracyMeters, speed, time, bearing
	var lat = loc.get("latitude", 0.0)
	var lon = loc.get("longitude", 0.0)
	var accuracy = loc.get("accuracy", 0.0)
	var altitude = loc.get("altitude", 0.0)
	var speed = loc.get("speed", 0.0)
	var bearing = loc.get("bearing", 0.0)

	lat_label.text = "緯度: %.6f" % lat
	lon_label.text = "經度: %.6f" % lon
	accuracy_label.text = "精確度: %.1f m" % accuracy
	alt_label.text = "海拔: %.1f m" % altitude
	var speed_kmh = speed * 3.6
	speed_label.text = "速度: %.2f km/h" % speed_kmh
	bearing_label.text = "方位: %.1f °" % bearing

	status_label.text = "即時更新中"
