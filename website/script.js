// ─── Student Count Animated Counter ───────────────────────────────────────────
// 🎓 STUDENT CHALLENGE: Change targetCount to a different number and watch it animate
const targetCount = 120;

function animateCounter(el, target, duration) {
  let start = 0;
  const step = Math.ceil(target / (duration / 16));
  const timer = setInterval(() => {
    start += step;
    if (start >= target) { start = target; clearInterval(timer); }
    el.textContent = start;
  }, 16);
}

window.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById('studentCount');
  if (el) animateCounter(el, targetCount, 1500);

  // Sticky navbar shadow on scroll
  const navbar = document.querySelector('.navbar');
  window.addEventListener('scroll', () => {
    navbar.style.boxShadow = window.scrollY > 10
      ? '0 4px 24px rgba(0,0,0,0.5)'
      : 'none';
  });

  // Scroll reveal for cards
  observeReveal();
});

// ─── Scroll Reveal ─────────────────────────────────────────────────────────────
function observeReveal() {
  const items = document.querySelectorAll('.card, .timeline-item, .team-card');
  items.forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(28px)';
    el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
  });

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12 });

  items.forEach(el => observer.observe(el));
}

// ─── Demo Modal ────────────────────────────────────────────────────────────────
function launchDemo() {
  document.getElementById('demoModal').classList.remove('hidden');
  document.body.style.overflow = 'hidden';
}

function closeDemoModal() {
  document.getElementById('demoModal').classList.add('hidden');
  document.body.style.overflow = '';
}

// Close modal with Escape key
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') closeDemoModal();
});

// ─── Register Button Toggle ────────────────────────────────────────────────────
// 🎓 STUDENT CHALLENGE: Call toggleRegisterButton() in the browser console to hide/show it
function toggleRegisterButton() {
  const btn = document.getElementById('registerBtn');
  if (!btn) return;
  const isVisible = btn.getAttribute('data-visible') === 'true';
  btn.setAttribute('data-visible', isVisible ? 'false' : 'true');
  console.log(`Register button is now: ${isVisible ? 'HIDDEN' : 'VISIBLE'}`);
}

// ─── Color Theme Switcher ──────────────────────────────────────────────────────
// 🎓 STUDENT CHALLENGE: Call setDemoColor('green') or 'red' or 'purple' in the console
function setDemoColor(color) {
  const btn = document.getElementById('demoBtn');
  if (!btn) return;
  btn.setAttribute('data-color', color);
  console.log(`Demo button color changed to: ${color}`);
}

// ─── Version Tag ───────────────────────────────────────────────────────────────
// 🎓 STUDENT CHALLENGE: Change this version string to mark your own deployment
const VERSION = 'v1.0.0';
const versionEl = document.getElementById('versionTag');
if (versionEl) versionEl.textContent = VERSION;
