# KIISE Database Society of Korea Digital Library
## 구성

- `frontend`: React + Vite
- `backend`: Express
- `database`: MySQL

## 기능

- 메인 페이지
- 논문 목록 게시판
- 논문 상세 조회

---

## 1. WSL2 기본 설치

Ubuntu 기준:

```bash
sudo apt update
sudo apt install -y curl git build-essential mysql-server
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

버전 확인:

```bash
node -v
npm -v
mysql --version
```

---

## 2. MySQL 설정

MySQL 실행:

```bash
sudo service mysql start
```

MySQL 접속:

```bash
sudo mysql
```

DB 초기화(권장):

```bash
cp backend/.env.example backend/.env
# backend/.env에서 DB_PASSWORD, JWT_SECRET 등을 실제 값으로 수정
bash database/init_db.sh
```

---

## 3. 백엔드 실행

```bash
cd backend
npm install
npm run dev
```

기본 주소:
- `http://localhost:4000`

헬스체크:
- `http://localhost:4000/api/health`

---

## 4. 프론트엔드 실행

새 터미널:

```bash
cd frontend
npm install
npm run dev
```

기본 주소:
- `http://localhost:5173`

---

## 5. 디렉터리 구조

```text
kcc-portal/
├── backend/
│   ├── config/
│   ├── controllers/
│   ├── routes/
│   ├── .env.example
│   ├── package.json
│   └── server.js
├── database/
│   └── init.sql
├── frontend/
│   ├── src/
│   │   ├── api/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── styles/
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
└── README.md
```

---
