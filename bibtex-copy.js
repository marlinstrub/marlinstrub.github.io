(function () {
    function attachButton(pre) {
        var details = pre.closest("details");
        if (!details) {
            return;
        }
        var summary = details.querySelector("summary");
        if (!summary || summary.querySelector(".bibtex-copy-button")) {
            return;
        }
        var button = document.createElement("button");
        button.type = "button";
        button.className = "bibtex-copy-button";
        button.textContent = "Copy";
        button.setAttribute("aria-label", "Copy bibtex entry to clipboard");

        var resetTimeout = null;
        function flash(label, stateClass) {
            button.textContent = label;
            button.classList.remove("copied", "failed");
            if (stateClass) {
                button.classList.add(stateClass);
            }
            if (resetTimeout) {
                clearTimeout(resetTimeout);
            }
            resetTimeout = setTimeout(function () {
                button.textContent = "Copy";
                button.classList.remove("copied", "failed");
                resetTimeout = null;
            }, 1500);
        }

        button.addEventListener("click", function (event) {
            event.preventDefault();
            event.stopPropagation();
            var text = pre.textContent;
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(text).then(
                    function () { flash("Copied", "copied"); },
                    function () { flash("Failed", "failed"); }
                );
            } else {
                flash("Failed", "failed");
            }
        });

        summary.appendChild(button);
    }

    function init() {
        var blocks = document.querySelectorAll("pre.src-bibtex");
        for (var i = 0; i < blocks.length; i += 1) {
            attachButton(blocks[i]);
        }
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();
