# GPS 座標顯示器

<img width="858" height="1907" alt="image" src="https://github.com/user-attachments/assets/470702c7-a21c-40ef-8ffc-50227059b60d" />


即時顯示 GPS 座標的 Godot 2D 應用，使用 [PraxisMapper GodotGPSPlugin](https://github.com/PraxisMapper/GodotGPSPlugin)。

## 需求

- Godot 4.6.1 或以上
- Android 裝置（GPS 功能僅在 Android 上可用）

## 安裝步驟

1. **下載 GPS 插件 AAR 檔**（若 `addons/PraxisMapperGPSPlugin/` 內尚無 `.aar` 檔）：
2. 以 Godot 編輯器開啟此專案（`project.godot`）
3. **專案 → 專案設定 → 插件**：勾選啟用 `PraxisMapperGPSPlugin`
4. **專案 → 匯出**：新增 Android 匯出範本
   - 下載並設定 Android SDK / JDK 路徑
   - 在 **權限** 中勾選：
     - `Access Coarse Location`
     - `Access Fine Location`
5. 匯出 APK 並安裝到 Android 裝置

## 使用方式

1. 在 Android 裝置上安裝並開啟應用
2. 點擊「啟用 GPS 定位」按鈕
3. 允許應用取用裝置位置
4. 即時檢視緯度、經度、精確度、海拔、速度與方位

## 專案結構

```
TestGDGPS/
├── addons/
│   └── PraxisMapperGPSPlugin/    # GPS 插件
├── scenes/
│   └── main.tscn                 # 主場景
├── scripts/
│   └── main.gd                   # 主邏輯
├── project.godot
├── export_presets.cfg            # Android 匯出設定（含定位權限）
└── icon.svg
```

## 備註

- 若在 PC 或非 Android 環境執行，會顯示提示訊息，GPS 不會啟用
- 依 [Google 政策](https://developer.android.com/training/permissions/requesting)，建議在用戶主動點擊後再請求權限，本應用已依此設計
