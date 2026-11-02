from flask import Flask, request, jsonify, render_template
import json
import os
import secrets
import string
from datetime import datetime, timedelta

app = Flask(__name__)

KEYS_FILE = "keys.json"

def load_keys():
    if not os.path.exists(KEYS_FILE):
        return {}
    with open(KEYS_FILE, "r") as f:
        return json.load(f)

def save_keys(keys):
    with open(KEYS_FILE, "w") as f:
        json.dump(keys, f, indent=2)

def generate_key(prefix="TKC"):
    rand = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(12))
    return f"{prefix}-{rand[:4]}-{rand[4:8]}-{rand[8:]}"

# Código del menú que se envía al script de Roblox
MAIN_MENU_CODE = '''
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TheKingsCheats"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "👑 The Kings Cheats - VIP"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame
'''

# ========== VERIFICACIÓN (Lo llama Solara) ==========
@app.route("/verify", methods=["POST"])
def verify():
    data = request.get_json()
    key = data.get("key", "").strip()
    
    keys = load_keys()
    
    if key not in keys:
        return jsonify({"valid": False, "message": "❌ Key no existe. Verifica que esté bien escrita."})
    
    info = keys[key]
    
    # Verificar si está activa
    if not info.get("active", True):
        msg = info.get("message", "Tu key ha sido desactivada por incumplir las reglas.")
        return jsonify({"valid": False, "message": f"🚫 {msg}"})
    
    # Verificar expiración
    if info.get("expires_at"):
        exp = datetime.fromisoformat(info["expires_at"])
        if datetime.now() > exp:
            return jsonify({"valid": False, "message": "⏰ Tu key ha expirado. Contacta para renovarla."})
    
    # Actualizar usos
    info["uses"] = info.get("uses", 0) + 1
    info["last_used"] = datetime.now().isoformat()
    save_keys(keys)
    
    return jsonify({"valid": True, "script": MAIN_MENU_CODE})

# ========== PANEL WEB ==========
@app.route("/admin")
def admin():
    return render_template("admin.html")

@app.route("/api/keys", methods=["GET"])
def list_keys():
    return jsonify(load_keys())

@app.route("/api/keys/create", methods=["POST"])
def create_key():
    data = request.get_json() or {}
    key = generate_key()
    keys = load_keys()
    
    days = int(data.get("days", 30))
    expires_at = (datetime.now() + timedelta(days=days)).isoformat() if days > 0 else None
    
    keys[key] = {
        "active": True,
        "created_at": datetime.now().isoformat(),
        "expires_at": expires_at,
        "uses": 0,
        "user_roblox": data.get("user_roblox", "Desconocido"),
        "user_discord": data.get("user_discord", ""),
        "plan": data.get("plan", "Personalizado"),
        "message": ""
    }
    save_keys(keys)
    
    return jsonify({"key": key, "info": keys[key]})

@app.route("/api/keys/<key>/toggle", methods=["POST"])
def toggle_key(key):
    data = request.get_json()
    keys = load_keys()
    if key not in keys:
        return jsonify({"error": "No existe"}), 404
    
    keys[key]["active"] = data.get("active", not keys[key].get("active", True))
    if not keys[key]["active"]:
        keys[key]["message"] = data.get("message", "Desactivada por el administrador.")
    else:
        keys[key]["message"] = ""
        
    save_keys(keys)
    return jsonify({"success": True, "info": keys[key]})

@app.route("/api/keys/<key>", methods=["DELETE"])
def delete_key(key):
    keys = load_keys()
    if key in keys:
        del keys[key]
        save_keys(keys)
    return jsonify({"ok": True})

# Ajuste para que Render se conecte correctamente
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)