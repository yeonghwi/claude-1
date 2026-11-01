# 폴리텍 뉴스 (Plain HTML + Supabase 실습)

## 파일 구조
```
index.html      공지사항 목록 (홈)
notice.html     공지사항 상세
board.html      자유게시판 목록 + 글쓰기(회원)
post.html       자유게시판 상세 + 삭제(본인)
login.html      로그인 / 회원가입
admin.html      관리자 페이지 (공지 작성·수정·삭제)
css/style.css   공통 스타일
js/supabase.js  Supabase 연결 설정 + 공통 함수
supabase/schema.sql  DB 테이블 + 보안정책(RLS)
```

## 1. Supabase 준비
1. https://supabase.com 에서 새 프로젝트 생성
2. **SQL Editor** 에서 `supabase/schema.sql` 내용을 붙여넣고 Run
3. **Authentication > Sign In / Providers > Email** 에서 `Confirm email` 끄기 (실습용: 가입 즉시 로그인)
4. **Project Settings > API** 의 `Project URL`, `anon public` 키를 `js/supabase.js` 에 붙여넣기

## 2. 관리자 지정
1. 사이트의 `login.html` 에서 관리자로 쓸 이메일로 회원가입
2. SQL Editor 에서 실행:
   ```sql
   insert into admins (user_id)
     select id from auth.users where email = '관리자이메일@example.com';
   ```
3. `admin.html` 접속 → 로그인 → 공지 작성

## 3. 로컬 실행
VS Code의 Live Server 확장, 또는:
```bash
npx serve .
```

## 4. Vercel 배포
빌드 과정이 없는 정적 사이트이므로 폴더를 그대로 올리면 됩니다.
- GitHub에 올린 뒤 Vercel에서 Import (Framework Preset: **Other**), 또는
- `npx vercel` 실행

## 보안 포인트 (수업용)
- anon 키는 공개되어도 되는 키입니다. 실제 권한은 `schema.sql` 의 **RLS 정책**이 DB에서 검사합니다.
- 화면에서 버튼을 숨기는 것은 편의일 뿐, 숨겨도 RLS가 없으면 누구나 API로 수정할 수 있습니다.
