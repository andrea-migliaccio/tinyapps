// Shared i18n + footer year. Each page defines window.T = { it: {...}, en: {...} } before loading this.
function setLang(l) {
  document.documentElement.lang = l;
  document.querySelectorAll("[data-i18n]").forEach(el => el.textContent = window.T[l][el.dataset.i18n]);
  document.querySelectorAll("[data-i18n-html]").forEach(el => el.innerHTML = window.T[l][el.dataset.i18nHtml]);
  document.querySelectorAll(".lang button").forEach(b => b.classList.toggle("active", b.dataset.lang === l));
  localStorage.setItem("lang", l);
}
document.querySelectorAll(".lang button").forEach(b => b.onclick = () => setLang(b.dataset.lang));
setLang(localStorage.getItem("lang") || ((navigator.language || "it").startsWith("it") ? "it" : "en"));
document.getElementById("year").textContent = new Date().getFullYear();
