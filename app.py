from flask import Flask, request, jsonify, render_template, session, redirect, url_for
import os
import secrets
import string
from datetime import datetime, timedelta, timezone
from supabase import create_client, Client
from functools import wraps

app = Flask(__name__)
app.secret_key = "super_secret_key_the_kings_cheats_2026" # Cambia esto si quieres

# ==========================================
# CONEXIÓN A SUPABASE
# ==========================================
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# ==========================================
# CREDENCIALES DE ADMIN
# ==========================================
ADMIN_USER = "Admin"
ADMIN_PASS = "The Kings Cheats"

# Decorador para proteger las rutas
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('logged_in'):
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

def generate_key(prefix="TKC"):
    rand = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(12))
    return f"{prefix}-{rand[:4]}-{rand[4:8]}-{rand[8:]}"

# ========== VERIFICACIÓN (Lo llama Solara/Xeno) ==========
@app.route("/verify", methods=["POST"])
def verify():
    data = request.get_json()
    key = data.get("key", "").strip()
    
    try:
        response = supabase.table('keys').select('*').eq('id', key).execute()
    except Exception as e:
        return jsonify({"valid": False, "message": "Error de base de datos."})

    if not response.data:
        return jsonify({"valid": False, "message": "Key no existe."})
    
    info = response.data[0]
    
    if not info.get("active", True):
        msg = info.get("message") or "Tu key ha sido desactivada."
        return jsonify({"valid": False, "message": f"{msg}"})
    
    if info.get("expires_at"):
        try:
            exp_str = info["expires_at"].replace('Z', '+00:00')
            exp = datetime.fromisoformat(exp_str)
            if datetime.now(timezone.utc) > exp:
                return jsonify({"valid": False, "message": "Tu key ha expirado."})
        except:
            pass
    
    supabase.table('keys').update({"uses": info.get("uses", 0) + 1}).eq('id', key).execute()
    return jsonify({"valid": True})

# ========== VISTAS Y API DEL PANEL ==========
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
    response = supabase.table('keys').select('*').execute()
    keys_dict = {item['id']: item for item in response.data}
    return jsonify(keys_dict)

@app.route("/api/keys/create", methods=["POST"])
@login_required
def create_key():
    data = request.get_json() or {}
    custom_key = data.get("custom_key", "").strip()
    key = custom_key if custom_key else generate_key()
    
    days = int(data.get("days", 30))
    now_utc = datetime.now(timezone.utc)
    expires_at = (now_utc + timedelta(days=days)).isoformat() if days > 0 else None
    
    new_key_data = {
        "id": key,
        "active": True,
        "expires_at": expires_at,
        "uses": 0,
        "user_roblox": data.get("user_roblox", "Desconocido"),
        "user_discord": data.get("user_discord", ""),
        "plan": data.get("plan", "Personalizado"),
        "message": "",
        "admin_note": ""
    }
    
    try:
        supabase.table('keys').insert(new_key_data).execute()
        return jsonify({"key": key, "info": new_key_data})
    except Exception as e:
        return jsonify({"error": "Esa Key ya existe o hubo un error."}), 400

@app.route("/api/keys/<key>/toggle", methods=["POST"])
@login_required
def toggle_key(key):
    data = request.get_json()
    response = supabase.table('keys').select('*').eq('id', key).execute()
    
    if not response.data:
        return jsonify({"error": "No existe"}), 404
    
    info = response.data[0]
    new_state = data.get("active", not info.get("active", True))
    
    update_data = {"active": new_state}
    if not new_state:
        update_data["message"] = data.get("message", "Desactivada por el administrador.")
    else:
        update_data["message"] = ""
        
    supabase.table('keys').update(update_data).eq('id', key).execute()
    return jsonify({"success": True, "active": new_state})

@app.route("/api/keys/<key>/extend", methods=["POST"])
@login_required
def extend_key(key):
    data = request.get_json()
    days = int(data.get("days", 7))
    
    response = supabase.table('keys').select('*').eq('id', key).execute()
    if not response.data:
        return jsonify({"error": "No existe"}), 404
    
    info = response.data[0]
    now_utc = datetime.now(timezone.utc)
    
    if info.get("expires_at"):
        exp_str = info["expires_at"].replace('Z', '+00:00')
        current_exp = datetime.fromisoformat(exp_str)
        if current_exp < now_utc:
            current_exp = now_utc
    else:
        current_exp = now_utc
        
    new_exp = (current_exp + timedelta(days=days)).isoformat()
    supabase.table('keys').update({"expires_at": new_exp, "active": True}).eq('id', key).execute()
    return jsonify({"success": True})

@app.route("/api/keys/<key>/note", methods=["POST"])
@login_required
def add_note(key):
    data = request.get_json()
    note = data.get("note", "")
    supabase.table('keys').update({"admin_note": note}).eq('id', key).execute()
    return jsonify({"success": True})

@app.route("/api/keys/<key>", methods=["DELETE"])
@login_required
def delete_key(key):
    supabase.table('keys').delete().eq('id', key).execute()
    return jsonify({"ok": True})

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)