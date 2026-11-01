// Supabase 대시보드 > Project Settings > API 에서 복사해 넣으세요.
// anon(publishable) 키는 브라우저에 공개되어도 되는 키입니다. (보안은 RLS가 담당)
const SUPABASE_URL = 'https://YOUR-PROJECT.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR-ANON-KEY';

const db = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// 2026-10-08T... -> 2026.10.08.
function formatDate(iso) {
  const d = new Date(iso);
  const mm = String(d.getMonth() + 1).padStart(2, '0');
  const dd = String(d.getDate()).padStart(2, '0');
  return `${d.getFullYear()}.${mm}.${dd}.`;
}

// 사용자가 입력한 글을 HTML로 넣을 때 태그가 실행되지 않도록 변환
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

// 상단 메뉴의 로그인/로그아웃 표시
async function renderNav() {
  const el = document.getElementById('auth-menu');
  if (!el) return;
  const { data: { user } } = await db.auth.getUser();
  if (user) {
    el.innerHTML = `<span>${escapeHtml(user.email)}</span> <a href="#" id="logout">로그아웃</a>`;
    document.getElementById('logout').onclick = async (e) => {
      e.preventDefault();
      await db.auth.signOut();
      location.href = 'index.html';
    };
  } else {
    el.innerHTML = '<a href="login.html">로그인</a>';
  }
}
renderNav();
