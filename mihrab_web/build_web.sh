#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Step 1: Build mihrab_tv for web ==="
cd "$REPO_ROOT/mihrab_tv"
flutter build web --release --base-href "/tv/"

echo "=== Step 2: Copy TV build to mihrab_web/web/tv/ ==="
rm -rf "$SCRIPT_DIR/web/tv"
mkdir -p "$SCRIPT_DIR/web/tv"
cp -r build/web/* "$SCRIPT_DIR/web/tv/"

echo "=== Step 3: Inject fullscreen button ==="
# Insert fullscreen button before </body> in the TV index.html
FULLSCREEN_HTML='
  <!-- Fullscreen Toggle Button -->
  <style>
    #fullscreen-btn {
      position: fixed;
      bottom: 20px;
      right: 20px;
      z-index: 99999;
      width: 48px;
      height: 48px;
      border-radius: 50%;
      border: none;
      background: rgba(0, 0, 0, 0.6);
      color: #fff;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0.4;
      transition: opacity 0.3s;
    }
    #fullscreen-btn:hover {
      opacity: 1;
    }
    #fullscreen-btn svg {
      width: 24px;
      height: 24px;
      fill: #fff;
    }
  </style>
  <button id="fullscreen-btn" title="Toggle Fullscreen">
    <svg id="fs-enter" viewBox="0 0 24 24"><path d="M7 14H5v5h5v-2H7v-3zm-2-4h2V7h3V5H5v5zm12 7h-3v2h5v-5h-2v3zM14 5v2h3v3h2V5h-5z"/></svg>
    <svg id="fs-exit" viewBox="0 0 24 24" style="display:none"><path d="M5 16h3v3h2v-5H5v2zm3-8H5v2h5V5H8v3zm6 11h2v-3h3v-2h-5v5zm2-11V5h-2v5h5V8h-3z"/></svg>
  </button>
  <script>
    (function() {
      var btn = document.getElementById("fullscreen-btn");
      var enterIcon = document.getElementById("fs-enter");
      var exitIcon = document.getElementById("fs-exit");
      function updateIcons() {
        var isFs = !!document.fullscreenElement;
        enterIcon.style.display = isFs ? "none" : "block";
        exitIcon.style.display = isFs ? "block" : "none";
      }
      btn.addEventListener("click", function() {
        if (!document.fullscreenElement) {
          document.documentElement.requestFullscreen().catch(function(){});
        } else {
          document.exitFullscreen().catch(function(){});
        }
      });
      document.addEventListener("fullscreenchange", updateIcons);
    })();
  </script>'

# Use perl to inject the fullscreen HTML before </body>
perl -i -p0e "s|</body>|${FULLSCREEN_HTML}\n</body>|s" "$SCRIPT_DIR/web/tv/index.html"

echo "=== Step 4: Build mihrab_web ==="
cd "$SCRIPT_DIR"
flutter build web --release

echo "=== Done! Output at mihrab_web/build/web/ ==="
