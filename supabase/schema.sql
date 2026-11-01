-- Supabase 대시보드 > SQL Editor 에 전체 붙여넣고 Run 하세요.

-- 1) 관리자 목록 : 여기에 등록된 회원만 공지사항을 쓰고/고치고/지울 수 있음
create table admins (
  user_id uuid primary key references auth.users on delete cascade
);

-- 2) 공지사항 (관리자 작성)
create table notices (
  id bigint generated always as identity primary key,
  title text not null,
  content text not null,
  created_at timestamptz not null default now()
);

-- 3) 자유게시판 (회원 작성)
create table posts (
  id bigint generated always as identity primary key,
  title text not null,
  content text not null,
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  author_email text default (auth.jwt() ->> 'email'),
  created_at timestamptz not null default now()
);

-- RLS(행 단위 보안) 켜기
alter table admins  enable row level security;
alter table notices enable row level security;
alter table posts   enable row level security;

-- admins : 본인이 관리자인지만 확인 가능
create policy "본인 관리자 여부 조회" on admins
  for select using (user_id = auth.uid());

-- notices : 누구나 읽기, 관리자만 쓰기/수정/삭제
create policy "공지 읽기" on notices
  for select using (true);
create policy "공지 작성(관리자)" on notices
  for insert with check (exists (select 1 from admins where user_id = auth.uid()));
create policy "공지 수정(관리자)" on notices
  for update using (exists (select 1 from admins where user_id = auth.uid()));
create policy "공지 삭제(관리자)" on notices
  for delete using (exists (select 1 from admins where user_id = auth.uid()));

-- posts : 누구나 읽기, 로그인 회원만 작성, 작성자 본인만 수정/삭제
create policy "글 읽기" on posts
  for select using (true);
create policy "글 작성(회원)" on posts
  for insert to authenticated with check (user_id = auth.uid());
create policy "글 수정(본인)" on posts
  for update using (user_id = auth.uid());
create policy "글 삭제(본인)" on posts
  for delete using (user_id = auth.uid());

-- 관리자 지정 방법 (회원가입 후 실행, 이메일만 바꾸세요)
-- insert into admins (user_id)
--   select id from auth.users where email = 'admin@example.com';
