from flask import Flask, request, render_template, render_template_string, session, redirect, url_for
import pymysql
from hashlib import sha256
import webbrowser

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # 세션 관리를 위한 비밀 키 추가

# MySQL 데이터베이스에 연결
conn = pymysql.connect(
    host='localhost',
    user='root',
    password='!als137963',
    database='DBProject'
)
cursor = conn.cursor()

# 비밀번호 해시 함수
def hash_password(password):
    return sha256(password.encode()).hexdigest()

# 새로운 사용자 추가 함수
def signup(user_id, name, phone, address, post, password):
    hashed_password = hash_password(password)
    try:
        cursor.execute(
            "INSERT INTO Member (ID, NAME, PHONE, ADDRESS, POST, PASSWORD) VALUES (%s, %s, %s, %s, %s, %s)",
            (user_id, name, phone, address, post, hashed_password)
        )
        conn.commit()
        return "Signup successful"
    except pymysql.Error as err:
        return f"Error: {err}"

def verify_user(user_id, password):
    hashed_password = hash_password(password)
    try:
        cursor.execute("SELECT NAME FROM Member WHERE ID = %s AND PASSWORD = %s", (user_id, hashed_password))
        user = cursor.fetchone()
        if user:
            return user[0]  # 사용자의 이름 반환
        else:
            return None
    except pymysql.Error as err:
        return None

@app.route('/')
def home():
    user_name = session.get('user_name')
    cursor.execute("SELECT NUM, NAME, ARTIST, PLACE, DATE FROM Concert")
    concerts = cursor.fetchall()
    return render_template('main.html', user_name=user_name, concerts=concerts)

@app.route('/concert/<int:concert_id>')
def concert_details(concert_id):
    cursor.execute("SELECT NAME, ARTIST, PLACE, DATE FROM Concert WHERE NUM = %s", (concert_id,))
    concert = cursor.fetchone()
    return render_template('concert_details.html', concert=concert)

@app.route('/concert/<int:concert_id>/seats')
def concert_seats(concert_id):
    cursor.execute("SELECT NUM_Seat, CLASS_Seat, PRICE, RESERVATION FROM Concert_Detail WHERE NUM_Concert = %s", (concert_id,))
    seats = cursor.fetchall()
    return render_template('concert_seats.html', seats=seats)

@app.route('/signup', methods=['GET', 'POST'])
def signup_route():
    if request.method == 'POST':
        user_id = request.form['id']
        name = request.form['name']
        phone = request.form['phone']
        address = request.form.get('address', '')
        post = request.form.get('post', '')
        password = request.form['password']
        message = signup(user_id, name, phone, address, post, password)
        if message == "Signup successful":
            return render_template_string('<script>alert("Signup successful!"); window.location.href="/signup";</script>')
        else:
            return message
    return render_template('signup.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user_id = request.form.get('id', None)
        password = request.form.get('password', None)
        if not user_id or not password:
            return render_template_string('<script>alert("ID와 비밀번호를 입력해주세요!"); window.location.href="/login";</script>')
        user_name = verify_user(user_id, password)
        if user_name:
            session['user_name'] = user_name  # 사용자의 이름을 세션에 저장
            return render_template_string('<script>alert("Login successful!"); window.location.href="/";</script>')
        else:
            return render_template_string('<script>alert("Invalid credentials!"); window.location.href="/login";</script>')
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('user_name', None)  # 세션에서 사용자 이름 제거
    return redirect(url_for('home'))

@app.route('/seats')
def seats():
    return render_template('concert_seats.html')

@app.route('/contact')
def contact():
    user_name = session.get('user_name')
    return render_template('contact.html', user_name=user_name)

if __name__ == "__main__":
    webbrowser.open("http://127.0.0.1:5000")
    app.run(debug=True)

# 앱이 종료될 때 데이터베이스 연결 닫기
@app.teardown_appcontext
def close_connection(exception):
    cursor.close()
    conn.close()