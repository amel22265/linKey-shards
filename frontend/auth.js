
// shared between login.html and signup.html

const API_URL = 'http://127.0.0.1:8000';

const loginForm = document.getElementById('login-form');
if (loginForm) {
  loginForm.addEventListener('submit', handleLogin);
}

const signupForm = document.getElementById('signup-form');
if (signupForm) {
  signupForm.addEventListener('submit', handleSignup);
}

async function handleSignup(event) {
  event.preventDefault();

  const name = document.getElementById('signup-name').value;
  const username = document.getElementById('signup-username').value;
  const email = document.getElementById('signup-email').value;
  const password = document.getElementById('signup-password').value;

  try {
    const response = await fetch(`${API_URL}/auth/signup`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, username, email, password })
    });

    if (!response.ok) {
      const errorData = await response.json();
      showError('signup', errorData.detail || 'Signup failed.');
      return;
    }

    await autoLoginAfterSignup(email, password);

  } catch (err) {
    console.error(err);
    showError('signup', 'Could not reach the server.');
  }
}
async function handleLogin(event) {
  event.preventDefault();

  const email = document.getElementById('login-email').value;
  const password = document.getElementById('login-password').value;

  try {
    const response = await fetch(`${API_URL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });

    if (!response.ok) {
      const errorData = await response.json();
      showError('login', errorData.detail || 'Invalid email or password.');
      return;
    }

    const data = await response.json();
    await handleAuthSuccess(data.access_token, 'login');

  } catch (err) {
    showError('login', 'Could not reach the server.');
  }
}


async function autoLoginAfterSignup(email, password) {
  try {
    const response = await fetch(`${API_URL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });

    if (!response.ok) {
      showError('signup', 'Account created, but auto-login failed.');
      return;
    }

    const data = await response.json();
    await handleAuthSuccess(data.access_token, 'signup');

  } catch (err) {
    showError('signup', 'Account created, but could not reach the server.');
  }
}



async function handleAuthSuccess(token, flowType) {
  localStorage.setItem('token', token);

  if (flowType === 'signup') {
    await playBadgeReveal();
  }

  document.body.classList.add('page-fade-out');
  await new Promise(resolve => setTimeout(resolve, 400));

  window.location.href = 'dashboard.html';
}

function playBadgeReveal() {
  return new Promise((resolve) => {
    const overlay = document.getElementById('badge-reveal-overlay');
    const svgEl = document.getElementById('badgeSvg');
    console.log('playBadgeReveal:', { overlay, svgEl }); 
    if (!overlay || !svgEl) {
      resolve();
      return;
    }

    overlay.classList.add('active');
    requestAnimationFrame(() => {
      svgEl.classList.remove('play');
      void svgEl.getBoundingClientRect();
      svgEl.classList.add('play');
    });

    setTimeout(resolve, 3600);
  });
}

function showError(formType, message) {
  const errorEl = document.getElementById(`${formType}-error`);
  if (errorEl) {
    errorEl.textContent = message;
    errorEl.style.display = 'block';
  }
}