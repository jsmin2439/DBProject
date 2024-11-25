from flask import Flask, request, render_template, render_template_string, session, redirect, url_for, jsonify, g
import pymysql
from hashlib import sha256
import webbrowser
import time
import contextlib

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # 세션 관리를 위한 비밀 키 추가

# MySQL 데이터베이스에 연결
conn = pymysql.connect(
    host='localhost',
    user='root',
    password='root',
    database='DBProject',
    charset='utf8mb4'
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

def get_db_connection():
    try:
        global conn, cursor
        # 연결이 끊어졌는지 확인
        if not conn.open:
            conn = pymysql.connect(
                host='localhost',
                user='root',
                password='root',
                database='DBProject',
                charset='utf8mb4'
            )
            cursor = conn.cursor()
        else:
            try:
                # 연결 상태 확인
                conn.ping(reconnect=True)
            except:
                # 연결 재설정
                conn = pymysql.connect(
                    host='localhost',
                    user='root',
                    password='root',
                    database='DBProject',
                    charset='utf8mb4'
                )
                cursor = conn.cursor()
        return conn, cursor
    except Exception as e:
        print(f"데이터베이스 연결 오류: {e}")
        raise

def execute_query(query, params=None):
    max_retries = 3
    retry_count = 0
    
    while retry_count < max_retries:
        try:
            conn, cursor = get_db_connection()
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            conn.commit()
            return cursor
        except pymysql.Error as e:
            retry_count += 1
            if retry_count == max_retries:
                raise e
            print(f"쿼리 실행 재시도 {retry_count}/{max_retries}")
            time.sleep(1)  # 재시도 전 1초 대기

def get_db():
    if 'db' not in g:
        g.db = pymysql.connect(
            host='localhost',
            user='root',
            password='root',
            database='DBProject',
            charset='utf8mb4',
            autocommit=True
        )
        g.db.ping(reconnect=True)
    return g.db

def get_cursor():
    if 'cursor' not in g:
        g.cursor = get_db().cursor()
    return g.cursor

@contextlib.contextmanager
def get_db_cursor():
    try:
        db = get_db()
        cursor = get_cursor()
        yield cursor
        db.commit()
    except Exception as e:
        db.rollback()
        raise e
    finally:
        cursor.close()

@app.route('/')
def home():
    user_name = session.get('user_name')
    cursor.execute("SELECT NUM, NAME, ARTIST, PLACE, DATE, IMAGE FROM Concert")
    concerts = cursor.fetchall()
    print("home", session)
    return render_template('main.html', user_name=user_name, concerts=concerts)

@app.route('/user/<user_name>', methods=['GET', 'POST'])
def user_profile(user_name):
    session_user_name = session.get('user_name')
    if session_user_name != user_name:
        return render_template_string('<script>alert("잘못된 접근입니다."); window.location.href="/";</script>')

    if request.method == 'POST':
        bank = request.form.get('bank')
        account = request.form.get('account')
        if bank and account:
            cursor.execute("SELECT ID FROM Member WHERE NAME = %s", (user_name,))
            user_id = cursor.fetchone()[0]
            cursor.execute("INSERT INTO Account (BANK, ID_Member, ACCOUNT) VALUES (%s, %s, %s)", (bank, user_id, account))
            conn.commit()

    cursor.execute("SELECT ID, NAME, PHONE, ADDRESS, POST FROM Member WHERE NAME = %s", (user_name,))
    user = cursor.fetchone()

    cursor.execute("""
        SELECT DISTINCT Concert.NAME, Concert.ARTIST, Concert.PLACE, Concert.DATE, Member_Orders.SALEPRICE, Concert_Detail.NUM_Seat, Concert_Detail.CLASS_Seat, Member_Orders.NUM
        FROM Member_Orders
        JOIN Concert ON Member_Orders.NUM_Concert = Concert.NUM
        JOIN Concert_Detail ON Member_Orders.NUM_Seat = Concert_Detail.NUM_Seat
        JOIN Member ON Member_Orders.ID_Member = Member.ID
        WHERE Member.NAME = %s AND Member_Orders.REFUND = 0
    """, (user_name,))
    orders = cursor.fetchall()

    cursor.execute("""
        SELECT DISTINCT Concert.NAME, Concert.ARTIST, Concert.PLACE, Concert.DATE, Member_Orders.SALEPRICE, Concert_Detail.NUM_Seat, Concert_Detail.CLASS_Seat, Account.BANK, Account.ACCOUNT, Member_Orders.NUM
        FROM Member_Orders
        JOIN Concert ON Member_Orders.NUM_Concert = Concert.NUM
        JOIN Concert_Detail ON Member_Orders.NUM_Seat = Concert_Detail.NUM_Seat
        JOIN Member ON Member_Orders.ID_Member = Member.ID
        JOIN Account ON Member.ID = Account.ID_Member
        WHERE Member.NAME = %s AND Member_Orders.REFUND = 1
        ORDER BY Member_Orders.NUM DESC
        LIMIT 5
    """, (user_name,))
    refunds = cursor.fetchall()

    cursor.execute("SELECT NUM, BANK, ACCOUNT FROM Account WHERE ID_Member = (SELECT ID FROM Member WHERE NAME = %s)", (user_name,))
    accounts = cursor.fetchall()

    cursor.execute("""
            SELECT Wishlist.NUM, Concert.NAME, Concert.ARTIST, Concert.PLACE, Concert.DATE, Concert_Detail.NUM_Seat AS Wishlist_Seat, Concert_Detail.CLASS_Seat, Concert_Detail.PRICE
            FROM Wishlist
                    JOIN Concert ON Wishlist.NUM_Concert = Concert.NUM
                    JOIN Concert_Detail ON Wishlist.NUM_Seat = Concert_Detail.NUM_Seat
            WHERE Wishlist.ID_Member = (SELECT ID FROM Member WHERE NAME = %s)
            AND Concert_Detail.NUM_Concert = Wishlist.NUM_Concert
        """, (user_name,))
    wishlist_items = cursor.fetchall()

    if user:
        return render_template('user_profile.html', user=user, user_name=session_user_name, orders=orders, accounts=accounts, refunds=refunds, wishlist_items=wishlist_items)
    else:
        return render_template_string('<script>alert("사용자 정보를 찾을 수 없습니다."); window.location.href="/";</script>')

@app.route('/delete_bank/<int:account_id>', methods=['POST'])
def delete_bank(account_id):
    try:
        execute_query("DELETE FROM Account WHERE NUM = %s", (account_id,))
        return redirect(url_for('user_profile', user_name=session.get('user_name')))
    except Exception as e:
        return render_template_string(f'<script>alert("계좌 삭제 실패: {e}"); window.location.href="/user/{session.get("user_name")}";</script>')

@app.route('/concert/<int:concert_id>')
def concert_details(concert_id):
    user_name = session.get('user_name')
    cursor.execute("SELECT NAME, ARTIST, PLACE, DATE, IMAGE FROM Concert WHERE NUM = %s", (concert_id,))
    concert = cursor.fetchone()
    return render_template('concert_details.html', concert=concert, concert_id=concert_id, user_name=user_name)


# main.py
@app.route('/concert/<int:concert_id>/seats', methods=['GET', 'POST'])
def concert_seats(concert_id):
    user_name = session.get('user_name')
    non_member = session.get('non_member')
    session['concert_id'] = concert_id
    
    if not user_name and not non_member:    
        print("seat1", session)
        return redirect(url_for('non_member'))

    selected_seat = None
    if request.method == 'POST':
        selected_seat = request.form.get('seat')
        if not user_name and not non_member:
            session['selected_seat'] = selected_seat
            print("seat2", session)
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
                           user_name=user_name, non_member=non_member, selected_seat=selected_seat,
                           purchased_seat_numbers=purchased_seat_numbers)

@app.route('/concert/<int:concert_id>/seats_status', methods=['GET'])
def seats_status(concert_id):
    try:
        with get_db_cursor() as cursor:
            cursor.execute(
                "SELECT NUM_Seat, CLASS_Seat, PRICE, RESERVATION FROM Concert_Detail WHERE NUM_Concert = %s",
                (concert_id,)
            )
            seats = cursor.fetchall()
            return jsonify(seats)
    except Exception as e:
        print(f"Error in seats_status: {e}")
        return jsonify([]), 500

@app.route('/concert/<int:concert_id>/select_seat', methods=['POST'])
def select_seat(concert_id):
    seat_num = request.form['seat']
    action = request.form['action']  # 'select' 또는 'release'
    try:
        with get_db_cursor() as cursor:
            if action == 'select':
                cursor.execute(
                    "UPDATE Concert_Detail SET RESERVATION = 2 WHERE NUM_Concert = %s AND NUM_Seat = %s AND RESERVATION = 0",
                    (concert_id, seat_num)
                )
            else:
                cursor.execute(
                    "UPDATE Concert_Detail SET RESERVATION = 0 WHERE NUM_Concert = %s AND NUM_Seat = %s AND RESERVATION = 2",
                    (concert_id, seat_num)
                )
            return jsonify(success=True)
    except Exception as e:
        print(f"Error in select_seat: {e}")
        return jsonify(success=False, error=str(e))

@app.route('/non_member', methods=['GET', 'POST'])
def non_member():
    if request.method == 'POST':
        phone = request.form['phone']
        name = request.form['name']
        post = request.form.get('post', 0, type=int)
        address = request.form.get('address', '')
        account = request.form.get('account', '')
        bank = request.form.get('bank', '')

        try:
            cursor.execute(
                "INSERT INTO Non_Member (PHONE, NAME, ADDRESS, POST, ACCOUNT, BANK) VALUES (%s, %s, %s, %s, %s, %s)",
                (phone, name, address, post, account, bank)
            )
            conn.commit()
            session['non_member'] = {'phone': phone, 'name': name, 'post': post, 'address': address, 'account': account, 'bank': bank}
            concert_id = session.get('concert_id')
            selected_seat = session.get('selected_seat')
            return redirect(url_for('concert_seats', concert_id=concert_id, selected_seat=selected_seat))
        except pymysql.Error as err:
            return render_template_string(f'<script>alert("등록 실패: {err}"); window.location.href="/non_member";</script>')

    concert_id = request.args.get('concert_id')
    if (concert_id):
        session['concert_id'] = concert_id

    return render_template('non_member.html')

@app.route('/concert/<int:concert_id>/confirm', methods=['GET', 'POST'])
def concert_confirm(concert_id):
    if request.method == 'POST':
        seat_num = request.form['seat']
        sale_price = request.form['price']
        concert_date = request.form['date']
        user_name = session.get('user_name')
        non_member = session.get('non_member')

        print("confirm", session)
        try:
            if user_name:
                cursor.execute(
                    "SELECT ID FROM Member WHERE NAME = %s", (user_name,)
                )
                user_id = cursor.fetchone()[0]
                cursor.execute(
                    "INSERT INTO Member_Orders (SALEPRICE, DATE, ID_Member, NUM_Seat, NUM_Concert, REFUND, EXCHANGE) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                    (sale_price, concert_date, user_id, seat_num, concert_id, 0, 0)
                )
            elif non_member:
                cursor.execute(
                    "INSERT INTO Non_Member_Orders (SALEPRICE, DATE, NUM_Concert, PHONE_Non_Member, NUM_Seat, REFUND, EXCHANGE) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                    (sale_price, concert_date, concert_id, non_member['phone'], seat_num, 0, 0)
                )
            conn.commit()

            cursor.execute("UPDATE Concert_Detail SET RESERVATION = 1 WHERE NUM_Concert = %s AND NUM_Seat = %s", (concert_id, seat_num))
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

@app.route('/concert/<int:concert_id>/confirm')
def confirm_purchase(concert_id):
    seat_num = request.args.get('seat')
    # 좌석 상태를 계속 '선택 중'으로 유지
    cursor.execute(
        "UPDATE Concert_Detail SET RESERVATION = 2 WHERE NUM_Concert = %s AND NUM_Seat = %s",
        (concert_id, seat_num)
    )
    conn.commit()

@app.route('/non_member_login', methods=['GET', 'POST'])
def non_member_login():
    if request.method == 'POST':
        name = request.form['name']
        phone = request.form['phone']
        cursor.execute("SELECT * FROM Non_Member WHERE NAME = %s AND PHONE = %s", (name, phone))
        non_member = cursor.fetchone()
        if non_member:
            session['non_member'] = {'name': name, 'phone': phone}
            return redirect(url_for('non_member_orders'))
        else:
            return render_template_string('<script>alert("이름 또는 전화번호가 일치하지 않습니다."); window.location.href="/non_member_login";</script>')
    return render_template('non_member_login.html')

@app.route('/non_member_refund/<int:order_id>', methods=['GET', 'POST'])
def non_member_refund(order_id):
    non_member = session.get('non_member')
    if not non_member:
        return redirect(url_for('non_member_login'))

    if request.method == 'POST':
        bank = request.form.get('bank')
        account = request.form.get('account')
        if bank and account:
            try:
                cursor.execute("UPDATE Non_Member SET BANK = %s, ACCOUNT = %s WHERE PHONE = %s", (bank, account, non_member['phone']))
                conn.commit()
                cursor.execute("UPDATE Non_Member_Orders SET REFUND = 1 WHERE NUM = %s", (order_id,))
                conn.commit()
                cursor.execute("""
                    UPDATE Concert_Detail
                    SET RESERVATION = 0
                    WHERE NUM_Seat = (SELECT NUM_Seat FROM Non_Member_Orders WHERE NUM = %s)
                """, (order_id,))
                conn.commit()
                return render_template_string('<script>alert("환불이 성공적으로 처리되었습니다!"); window.location.href="/non_member_orders";</script>')
            except pymysql.Error as err:
                return render_template_string(f'<script>alert("환불 실패: {err}"); window.location.href="/non_member_orders";</script>')

    return render_template('non_member_refund.html', order_id=order_id)

@app.route('/non_member_orders', methods=['GET', 'POST'])
def non_member_orders():
    non_member = session.get('non_member')
    if not non_member:
        return render_template_string('<script>alert("비회원 정보를 입력해주세요."); window.location.href="/non_member_login";</script>')

    phone = non_member['phone']
    cursor.execute("""
        SELECT DISTINCT Concert.NAME, Concert.ARTIST, Concert.PLACE, Concert.DATE, Non_Member_Orders.SALEPRICE, Concert_Detail.NUM_Seat, Concert_Detail.CLASS_Seat, Non_Member_Orders.NUM
        FROM Non_Member_Orders
        JOIN Concert ON Non_Member_Orders.NUM_Concert = Concert.NUM
        JOIN Concert_Detail ON Non_Member_Orders.NUM_Seat = Concert_Detail.NUM_Seat
        WHERE Non_Member_Orders.PHONE_Non_Member = %s AND Non_Member_Orders.REFUND = 0
    """, (phone,))
    orders = cursor.fetchall()

    cursor.execute("""
        SELECT DISTINCT Concert.NAME, Concert.ARTIST, Concert.PLACE, Concert.DATE, Non_Member_Orders.SALEPRICE, Concert_Detail.NUM_Seat, Concert_Detail.CLASS_Seat, Non_Member.BANK, Non_Member.ACCOUNT, Non_Member_Orders.NUM
        FROM Non_Member_Orders
        JOIN Concert ON Non_Member_Orders.NUM_Concert = Concert.NUM
        JOIN Concert_Detail ON Non_Member_Orders.NUM_Seat = Concert_Detail.NUM_Seat
        JOIN Non_Member ON Non_Member_Orders.PHONE_Non_Member = Non_Member.PHONE
        WHERE Non_Member_Orders.PHONE_Non_Member = %s AND Non_Member_Orders.REFUND = 1
        ORDER BY Non_Member_Orders.NUM DESC
        LIMIT 5
    """, (phone,))
    refunds = cursor.fetchall()

    return render_template('non_member_orders.html', orders=orders, refunds=refunds, non_member=non_member)

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
                # 회원의 예약 정보 조회
                cursor.execute("SELECT NUM, NUM_Seat FROM Member_Orders WHERE ID_Member = %s AND REFUND = 0",(user_id,))
                orders = cursor.fetchall()

                # 예약 정보 환불 처리 및 Concert_Seat 테이블 업데이트
                for order in orders:
                    order_id, seat_num = order
                    cursor.execute("UPDATE Member_Orders SET REFUND = 1 WHERE NUM = %s", (order_id,))
                    cursor.execute("UPDATE Concert_Detail SET RESERVATION = 0 WHERE NUM_Seat = %s", (seat_num,))

                conn.commit()

                # Account 테이블에서 해당 사용자의 계좌 정보 삭제
                cursor.execute("DELETE FROM Account WHERE ID_Member = %s", (user_id,))
                conn.commit()

                # Member_Orders 테이블에서 해당 사용자의 주문 정보 삭제
                cursor.execute("DELETE FROM Member_Orders WHERE ID_Member = %s", (user_id,))
                conn.commit()

                # Member 테이블에서 사용자 삭제
                cursor.execute("DELETE FROM Member WHERE ID = %s", (user_id,))
                conn.commit()

                session.pop('user_name', None)
                return render_template_string('<script>alert("회원 탈퇴가 완료되었습니다."); window.location.href="/";</script>')
            except pymysql.Error as err:
                return render_template_string(f'<script>alert("회원 탈퇴 실패: {err}"); window.location.href="/delete_account";</script>')
        else:
            return render_template_string('<script>alert("ID 또는 비밀번호가 잘못되었습니다."); window.location.href="/delete_account";</script>')

    return render_template('delete_account.html')

@app.route('/refund/<int:order_id>', methods=['GET', 'POST'])
def refund(order_id):
    user_name = session.get('user_name')
    if not user_name:
        return redirect(url_for('login'))

    if request.method == 'POST':
        account_id = request.form.get('account_id')
        if account_id:
            try:
                # Member_Orders의 REFUND 값을 1로 업데이트
                cursor.execute("UPDATE Member_Orders SET REFUND = 1 WHERE NUM = %s", (order_id,))
                conn.commit()

                # Concert_Detail의 RESERVATION 값을 0으로 업데이트
                cursor.execute("""
                    UPDATE Concert_Detail
                    SET RESERVATION = 0
                    WHERE NUM_Seat = (SELECT NUM_Seat FROM Member_Orders WHERE NUM = %s)
                """, (order_id,))
                conn.commit()

                return render_template_string('<script>alert("환불이 성공적으로 처리되었습니다!"); window.location.href="/user/%s";</script>' % user_name)
            except pymysql.Error as err:
                return render_template_string(f'<script>alert("환불 실패: {err}"); window.location.href="/user/{user_name}";</script>')

    cursor.execute("SELECT NUM, BANK, ACCOUNT FROM Account WHERE ID_Member = (SELECT ID FROM Member WHERE NAME = %s)", (user_name,))
    accounts = cursor.fetchall()
    return render_template('refund.html', accounts=accounts, order_id=order_id)

@app.route('/concert/<int:concert_id>/wishlist', methods=['GET'])
def add_to_wishlist(concert_id):
    user_name = session.get('user_name')
    if not user_name:
        return redirect(url_for('login'))

    seat_num = request.args.get('seat')
    if seat_num:
        try:
            cursor.execute("SELECT ID FROM Member WHERE NAME = %s", (user_name,))
            user_id = cursor.fetchone()[0]
            cursor.execute("INSERT INTO Wishlist (ID_Member, NUM_Concert, NUM_Seat) VALUES (%s, %s, %s)", (user_id, concert_id, seat_num))
            conn.commit()
            return render_template_string('<script>alert("위시리스트에 추가되었습니다!"); window.location.href="/concert/%s/seats";</script>' % concert_id)
        except pymysql.Error as err:
            return render_template_string(f'<script>alert("위시리스트 추가 실패: {err}"); window.location.href="/concert/{concert_id}/seats";</script>')

    return redirect(url_for('concert_seats', concert_id=concert_id))

@app.route('/wishlist/buy/<int:wishlist_id>', methods=['POST'])
def buy_from_wishlist(wishlist_id):
    user_name = session.get('user_name')
    if not user_name:
        return redirect(url_for('login'))

    cursor.execute("SELECT ID FROM Member WHERE NAME = %s", (user_name,))
    user_id = cursor.fetchone()[0]
    cursor.execute("""
        SELECT Wishlist.NUM_Concert, Wishlist.NUM_Seat, Concert_Detail.PRICE, Concert.DATE
        FROM Wishlist
        JOIN Concert_Detail ON Wishlist.NUM_Seat = Concert_Detail.NUM_Seat
        JOIN Concert ON Wishlist.NUM_Concert = Concert.NUM
        WHERE Wishlist.NUM = %s AND Wishlist.ID_Member = %s
    """, (wishlist_id, user_id))
    item = cursor.fetchone()
    if item:
        concert_id, seat_num, price, date = item
        try:
            cursor.execute("""
                INSERT INTO Member_Orders (SALEPRICE, DATE, ID_Member, NUM_Seat, NUM_Concert, REFUND, EXCHANGE)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (price, date, user_id, seat_num, concert_id, 0, 0))
            cursor.execute("UPDATE Concert_Detail SET RESERVATION = 1 WHERE NUM_Seat = %s", (seat_num,))
            cursor.execute("DELETE FROM Wishlist WHERE NUM = %s", (wishlist_id,))
            conn.commit()
            return render_template_string('<script>alert("구매가 완료되었습니다!"); window.location.href="/user/%s";</script>' % user_name)
        except pymysql.Error as err:
            return render_template_string(f'<script>alert("구매 실패: {err}"); window.location.href="/user/{user_name}";</script>')
    return redirect(url_for('view_wishlist'))

@app.route('/wishlist/delete/<int:wishlist_id>', methods=['POST'])
def delete_from_wishlist(wishlist_id):
    user_name = session.get('user_name')
    if not user_name:
        return redirect(url_for('login'))
    try:
        cursor.execute("DELETE FROM Wishlist WHERE NUM = %s AND ID_Member = (SELECT ID FROM Member WHERE NAME = %s)", (wishlist_id, user_name))
        conn.commit()
        return render_template_string('<script>alert("위시리스트에서 삭제되었습니다!"); window.location.href="/user/%s";</script>' % user_name)
    except pymysql.Error as err:
        return render_template_string(f'<script>alert("위시리스트 삭제 실패: {err}"); window.location.href="/user/{user_name}";</script>')

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

# 앱이 종료될 때 데이터베이스 연결 닫기
@app.teardown_appcontext
def close_db(e=None):
    db = g.pop('db', None)
    cursor = g.pop('cursor', None)
    
    if cursor:
        cursor.close()
    if db:
        db.close()

if __name__ == "__main__":
    app.run('0.0.0.0', port=5001, debug=True)