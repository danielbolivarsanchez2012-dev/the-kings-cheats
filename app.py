from flask import Flask, request, jsonify, render_template, session, redirect, url_for
import json
import os
import secrets
import string
from datetime import datetime, timedelta
from functools import wraps

app = Flask(__name__)
app.secret_key = "super_secret_key_the_kings_cheats_2026"

# ==========================================
# CONFIGURACIÓN DE ARCHIVO LOCAL
# ==========================================
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

# ==========================================
# CREDENCIALES DE ADMIN
# ==========================================
ADMIN_USER = "Admin"
ADMIN_PASS = "The Kings Cheats"

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('logged_in'):
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

# ========== VERIFICACIÓN ==========
@app.route("/verify", methods=["POST"])
def verify():
    data = request.get_json()
    key = data.get("key", "").strip()
    
    keys = load_keys()
    if key not in keys:
        return jsonify({"valid": False, "message": "❌ Key no existe."})
    
    info = keys[key]
    
    if not info.get("active", True):
        msg = info.get("message") or "Tu key ha sido desactivada."
        return jsonify({"valid": False, "message": f"🚫 {msg}"})
    
    if info.get("expires_at"):
        exp_str = info["expires_at"].replace('Z', '+00:00')
        exp = datetime.fromisoformat(exp_str)
        if datetime.now() > exp:
            return jsonify({"valid": False, "message": "⏰ Tu key ha expirado."})
    
    info["uses"] = info.get("uses", 0) + 1
    save_keys(keys)
    return jsonify({"valid": True})

# ========== VISTAS Y API ==========
@app.route("/")
def index():
    return redirect(url_for('admin'))

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        user = request.form.get("username")
        pwd = request.form.get("password")
        if user == ADMIN_USER and pwd == ADMIN_PASS:
            session['logged_in'] = True
            return redirect(url_for('admin'))
        else:
            return render_template("login.html", error="Usuario o contraseña incorrectos")
    return render_template("login.html")

@app.route("/logout")
def logout():
    session.pop('logged_in', None)
    return redirect(url_for('login'))

@app.route("/admin")
@login_required
def admin():
    return render_template("admin.html")

@app.route("/api/keys", methods=["GET"])
@login_required
def list_keys():
    return jsonify(load_keys())

@app.route("/api/keys/create", methods=["POST"])
@login_required
def create_key():
    data = request.get_json() or {}
    key = generate_key()
    keys = load_keys()
    
    days = int(data.get("days", 30))
    expires_at = (datetime.now() + timedelta(days=days)).isoformat() if days > 0 else None
    
    keys[key] = {
        "active": True,
        "expires_at": expires_at,
        "uses": 0,
        "user_roblox": data.get("user_roblox", "Desconocido"),
        "user_discord": data.get("user_discord", ""),
        "plan": data.get("plan", "Personalizado"),
        "message": "",
        "admin_note": ""
    }
    save_keys(keys)
    return jsonify({"key": key, "info": keys[key]})

@app.route("/api/keys/<key>/toggle", methods=["POST"])
@login_required
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
    return jsonify({"success": True, "active": keys[key]["active"]})

@app.route("/api/keys/<key>/extend", methods=["POST"])
@login_required
def extend_key(key):
    data = request.get_json()
    days = int(data.get("days", 7))
    keys = load_keys()
    
    if key not in keys:
        return jsonify({"error": "No existe"}), 404
        
    info = keys[key]
    now_utc = datetime.now()
    
    if info.get("expires_at"):
        exp_str = info["expires_at"].replace('Z', '+00:00')
        current_exp = datetime.fromisoformat(exp_str)
        if current_exp < now_utc:
            current_exp = now_utc
    else:
        current_exp = now_utc
        
    new_exp = (current_exp + timedelta(days=days)).isoformat()
    keys[key]["expires_at"] = new_exp
    keys[key]["active"] = True
    save_keys(keys)
    return jsonify({"success": True})

@app.route("/api/keys/<key>/note", methods=["POST"])
@login_required
def add_note(key):
    data = request.get_json()
    keys = load_keys()
    if key in keys:
        keys[key]["admin_note"] = data.get("note", "")
        save_keys(keys)
    return jsonify({"success": True})

@app.route("/api/keys/<key>", methods=["DELETE"])
@login_required
def delete_key(key):
    keys = load_keys()
    if key in keys:
        del keys[key]
        save_keys(keys)
    return jsonify({"ok": True})

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)