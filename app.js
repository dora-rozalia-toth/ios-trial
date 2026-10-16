/* AI Boards — iPad panel prototype — behavior
   Two independent flags drive everything: sidebarOpen, governAIOpen.
   Opening GovernAI auto-collapses the sidebar (per Figma annotation #1);
   the sidebar can then be re-opened so both panes can coexist. */

(function () {
  "use strict";

  const ipad = document.getElementById("ipad");
  const workspace = document.getElementById("workspace");

  const SIDEBAR_W = 320;
  const AI_W = 400;

  const state = { sidebar: true, ai: false };

  function render() {
    workspace.style.setProperty("--sw", (state.sidebar ? SIDEBAR_W : 0) + "px");
    workspace.style.setProperty("--aw", (state.ai ? AI_W : 0) + "px");
    ipad.dataset.sidebar = state.sidebar ? "open" : "closed";
    ipad.dataset.ai = state.ai ? "open" : "closed";

    const panel = document.querySelector(".governai");
    if (panel) panel.setAttribute("aria-hidden", state.ai ? "false" : "true");

    const fab = document.querySelector(".ai-fab");
    if (fab) fab.setAttribute("aria-label", state.ai ? "Close GovernAI" : "Open GovernAI");

    syncHelper();
  }

  function toggleSidebar() {
    state.sidebar = !state.sidebar;
    render();
  }

  function toggleAI() {
    state.ai = !state.ai;
    // Annotation #1: when the AI panel opens, the sidenav collapses.
    if (state.ai) state.sidebar = false;
    render();
  }

  // ---- Event delegation for all data-action controls ----
  document.addEventListener("click", function (e) {
    const el = e.target.closest("[data-action]");
    if (!el) return;
    const action = el.getAttribute("data-action");
    if (action === "toggle-sidebar") toggleSidebar();
    else if (action === "toggle-ai") toggleAI();
  });

  // ---- Tab switches (visual only) ----
  function wireTablist(selector, activeClass) {
    document.querySelectorAll(selector).forEach(function (group) {
      group.querySelectorAll("[role='tab']").forEach(function (tab) {
        tab.addEventListener("click", function () {
          group.querySelectorAll("[role='tab']").forEach(function (t) {
            t.classList.remove(activeClass);
            t.setAttribute("aria-selected", "false");
          });
          tab.classList.add(activeClass);
          tab.setAttribute("aria-selected", "true");
        });
      });
    });
  }
  wireTablist(".segmented", "active");
  wireTablist(".gov-tabs", "active");

  // ---- Outline rows: toggle expand caret / move selection (visual only) ----
  document.querySelectorAll(".outline .row").forEach(function (row) {
    row.addEventListener("click", function () {
      if (row.querySelector(".caret")) {
        row.classList.toggle("expanded");
      }
      if (row.classList.contains("leaf")) {
        document.querySelectorAll(".outline .row.selected")
          .forEach(function (r) { r.classList.remove("selected"); });
        row.classList.add("selected");
      }
    });
  });

  // ---- Quick-state helper buttons ----
  const presets = {
    sidebar: { sidebar: true,  ai: false },
    ai:      { sidebar: false, ai: true  },
    both:    { sidebar: true,  ai: true  },
    none:    { sidebar: false, ai: false }
  };
  document.querySelectorAll(".helper-states button").forEach(function (btn) {
    btn.addEventListener("click", function () {
      const p = presets[btn.getAttribute("data-state")];
      if (!p) return;
      state.sidebar = p.sidebar;
      state.ai = p.ai;
      render();
    });
  });

  function syncHelper() {
    let key = "none";
    if (state.sidebar && state.ai) key = "both";
    else if (state.ai) key = "ai";
    else if (state.sidebar) key = "sidebar";
    document.querySelectorAll(".helper-states button").forEach(function (btn) {
      btn.classList.toggle("on", btn.getAttribute("data-state") === key);
    });
  }

  // ---- Fit the 1366×1024 canvas into the viewport ----
  function fit() {
    const margin = 36;
    const bottomRoom = 92; // helper bar
    const sx = (window.innerWidth - margin * 2) / 1366;
    const sy = (window.innerHeight - margin - bottomRoom) / 1024;
    const scale = Math.min(sx, sy, 1);
    ipad.style.transform = "scale(" + scale + ")";
  }
  window.addEventListener("resize", fit);
  fit();
  render();
})();
