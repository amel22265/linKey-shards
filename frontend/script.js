// index.html only — the buttons now navigate to real pages
// instead of morphing the panel in place

document.getElementById('btn-login').addEventListener('click', () => {
  window.location.href = 'login.html';
});

document.getElementById('btn-signup').addEventListener('click', () => {
  window.location.href = 'signup.html';
});
