const navLinks = document.getElementById("nav-links");
const navToggle = document.getElementById("nav-toggle");
const themeToggle = document.getElementById("theme-toggle");
const progress = document.getElementById("reading-progress");

const savedTheme = localStorage.getItem("bfg-theme");
if (savedTheme === "dark") {
  document.body.classList.add("dark-theme");
  themeToggle.innerHTML = '<i class="ri-sun-line" aria-hidden="true"></i>';
}

navToggle?.addEventListener("click", () => {
  navLinks?.classList.toggle("show");
});

document.querySelectorAll(".nav__links a").forEach((link) => {
  link.addEventListener("click", () => navLinks?.classList.remove("show"));
});

themeToggle?.addEventListener("click", () => {
  document.body.classList.toggle("dark-theme");
  const isDark = document.body.classList.contains("dark-theme");
  localStorage.setItem("bfg-theme", isDark ? "dark" : "light");
  themeToggle.innerHTML = isDark
    ? '<i class="ri-sun-line" aria-hidden="true"></i>'
    : '<i class="ri-moon-line" aria-hidden="true"></i>';
});

function updateProgress() {
  if (!progress) return;
  const scrollTop = window.scrollY;
  const height = document.documentElement.scrollHeight - window.innerHeight;
  const width = height > 0 ? (scrollTop / height) * 100 : 0;
  progress.style.width = `${Math.min(width, 100)}%`;
}

window.addEventListener("scroll", updateProgress, { passive: true });
updateProgress();

document.querySelectorAll("pre").forEach((pre) => {
  const code = pre.querySelector("code");
  if (!code || code.className.includes("mermaid")) return;

  const button = document.createElement("button");
  button.className = "copy-code";
  button.type = "button";
  button.textContent = "Copy";
  button.addEventListener("click", async () => {
    await navigator.clipboard.writeText(code.innerText);
    button.textContent = "Copied";
    window.setTimeout(() => {
      button.textContent = "Copy";
    }, 1400);
  });
  pre.appendChild(button);
});

function prepareMermaid() {
  document.querySelectorAll("pre > code.language-mermaid").forEach((code) => {
    const wrapper = document.createElement("div");
    wrapper.className = "mermaid";
    wrapper.textContent = code.textContent;
    code.closest("pre").replaceWith(wrapper);
  });

  if (window.mermaid) {
    window.mermaid.initialize({
      startOnLoad: false,
      theme: document.body.classList.contains("dark-theme") ? "dark" : "default",
    });
    window.mermaid.run();
  }
}

window.addEventListener("mermaid-ready", prepareMermaid);
prepareMermaid();
