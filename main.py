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

@app.route('/user/<user_name>')
def user_profile(user_name):
    session_user_name = session.get('user_name')
    if session_user_name != user_name:
        return render_template_string('<script>alert("잘못된 접근입니다."); window.location.href="/";</script>')

    cursor.execute("SELECT ID, NAME, PHONE, ADDRESS, POST FROM Member WHERE NAME = %s", (user_name,))
    user = cursor.fetchone()

    cursor.execute("""
        SELECT DISTINCT Concert.NAME, Concert.ARTIST, Concert.PLACE, Concert.DATE, Member_Orders.SALEPRICE, Concert_Detail.NUM_Seat, Concert_Detail.CLASS_Seat
        FROM Member_Orders
        JOIN Concert ON Member_Orders.NUM_Concert = Concert.NUM
        JOIN Concert_Detail ON Member_Orders.NUM_Seat = Concert_Detail.NUM_Seat
        WHERE Member_Orders.ID_Member = %s
    """, (user_name,))
    orders = cursor.fetchall()

    if user:
        return render_template('user_profile.html', user=user, user_name=session_user_name, orders=orders)
    else:
        return render_template_string('<script>alert("사용자 정보를 찾을 수 없습니다."); window.location.href="/";</script>')

@app.route('/concert/<int:concert_id>')
def concert_details(concert_id):
    user_name = session.get('user_name')
    cursor.execute("SELECT NAME, ARTIST, PLACE, DATE FROM Concert WHERE NUM = %s", (concert_id,))
    concert = cursor.fetchone()
    return render_template('concert_details.html', concert=concert, concert_id=concert_id, user_name=user_name)


@app.route('/concert/<int:concert_id>/seats', methods=['GET', 'POST'])
def concert_seats(concert_id):
    user_name = session.get('user_name')
    if not user_name:
        return redirect(url_for('non_member'))

    selected_seat = None
    if request.method == 'POST':
        selected_seat = request.form.get('seat')
        if not user_name:
            session['selected_seat'] = selected_seat
            session['concert_id'] = concert_id
            return redirect(url_for('non_member'))

    cursor.execute("SELECT NAME, ARTIST, PLACE, DATE FROM Concert WHERE NUM = %s", (concert_id,))
    concert = cursor.fetchone()
    cursor.execute(
        "SELECT NUM_Seat, CLASS_Seat, PRICE, RESERVATION FROM Concert_Detail WHERE NUM_Concert = %s LIMIT 50",
        (concert_id,))
    seats = cursor.fetchall()
    cursor.execute("SELECT NUM_Seat FROM Member_Orders WHERE NUM_Concert = %s", (concert_id,))
    purchased_seats = cursor.fetchall()
    purchased_seat_numbers = [seat[0] for seat in purchased_seats]

    return render_template('concert_seats.html', concert=concert, seats=seats, concert_id=concert_id,
                           user_name=user_name, selected_seat=selected_seat,
                           purchased_seat_numbers=purchased_seat_numbers)

@app.route('/non_member', methods=['GET', 'POST'])
def non_member():
    if request.method == 'POST':
        phone = request.form['phone']
        name = request.form['name']
        address = request.form.get('address', '')
        post = request.form.get('post', '')
        account = request.form.get('account', '')
        bank = request.form.get('bank', '')

        try:
            cursor.execute(
                "INSERT INTO NON_Member (PHONE, NAME, ADDRESS, POST, ACCOUNT, BANK) VALUES (%s, %s, %s, %s, %s, %s)",
                (phone, name, address, post, account, bank)
            )
            conn.commit()
            concert_id = session.get('concert_id')
            selected_seat = session.get('selected_seat')
            return redirect(url_for('concert_confirm', concert_id=concert_id, seat=selected_seat))
        except pymysql.Error as err:
            return render_template_string(f'<script>alert("등록 실패: {err}"); window.location.href="/non_member";</script>')

    return render_template('non_member.html')

@app.route('/concert/<int:concert_id>/confirm', methods=['GET', 'POST'])
def concert_confirm(concert_id):
    if request.method == 'POST':
        user_name = session.get('user_name')
        seat_num = request.form['seat']

        cursor.execute("SELECT NAME, ARTIST, PLACE, DATE FROM Concert WHERE NUM = %s", (concert_id,))
        concert = cursor.fetchone()
        cursor.execute("SELECT NUM_Seat, CLASS_Seat, PRICE FROM Concert_Detail WHERE NUM_Seat = %s", (seat_num,))
        seat = cursor.fetchone()

        seat_price = seat[2]
        concert_date = concert[3]

        try:
            cursor.execute(
                "INSERT INTO Member_Orders (SALEPRICE, DATE, ID_Member, NUM_Seat, NUM_Concert) VALUES (%s, %s, %s, %s, %s)",
                (seat_price, concert_date, user_name, seat_num, concert_id)
            )
            conn.commit()
            return render_template_string('<script>alert("결제가 성공적으로 완료되었습니다!"); window.location.href="/";</script>')
        except pymysql.Error as err:
            return render_template_string(f'<script>alert("결제 실패: {err}"); window.location.href="/";</script>')
    else:
        user_name = session.get('user_name')
        seat_num = request.args.get('seat')
        cursor.execute("SELECT NAME, ARTIST, PLACE, DATE FROM Concert WHERE NUM = %s", (concert_id,))
        concert = cursor.fetchone()
        cursor.execute("SELECT NUM_Seat, CLASS_Seat, PRICE FROM Concert_Detail WHERE NUM_Seat = %s", (seat_num,))
        seat = cursor.fetchone()
        return render_template('concert_confirm.html', concert=concert, seat=seat, concert_id=concert_id, user_name=user_name)

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
            return render_template_string('<script>alert("회원가입 되었습니다!"); window.location.href="/login";</script>')
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
            return render_template_string('<script>alert("로그인 성공!"); window.location.href="/";</script>')
        else:
            return render_template_string('<script>alert("로그인 실패."); window.location.href="/login";</script>')
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('user_name', None)  # 세션에서 사용자 이름 제거
    return redirect(url_for('home'))

@app.route('/delete_account', methods=['GET', 'POST'])
def delete_account():
    if request.method == 'POST':
        user_name = session.get('user_name')
        if not user_name:
            return redirect(url_for('login'))

        user_id = request.form.get('id', None)
        password = request.form.get('password', None)
        if not user_id or not password:
            return render_template_string('<script>alert("ID와 비밀번호를 입력해주세요!"); window.location.href="/delete_account";</script>')

        hashed_password = hash_password(password)
        cursor.execute("SELECT ID FROM Member WHERE ID = %s AND PASSWORD = %s", (user_id, hashed_password))
        user = cursor.fetchone()
        if user:
            try:
                cursor.execute("DELETE FROM Member_Orders WHERE ID_Member = %s", (user_id,))
                cursor.execute("DELETE FROM Member WHERE ID = %s", (user_id,))
                conn.commit()
                session.pop('user_name', None)
                return render_template_string('<script>alert("회원 탈퇴가 완료되었습니다."); window.location.href="/";</script>')
            except pymysql.Error as err:
                return render_template_string(f'<script>alert("회원 탈퇴 실패: {err}"); window.location.href="/delete_account";</script>')
        else:
            return render_template_string('<script>alert("ID 또는 비밀번호가 잘못되었습니다."); window.location.href="/delete_account";</script>')

    return render_template('delete_account.html')

@app.route('/search')
def search():
    query = request.args.get('query')
    cursor.execute("SELECT NUM, NAME, ARTIST, PLACE, DATE FROM Concert WHERE NAME LIKE %s OR ARTIST LIKE %s", (f"%{query}%", f"%{query}%"))
    results = cursor.fetchall()
    user_name = session.get('user_name')
    return render_template('search_results.html', results=results, user_name=user_name)

@app.route('/seats')
def seats():
    user_name = session.get('user_name')
    return render_template('concert_seats.html', user_name=user_name)

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