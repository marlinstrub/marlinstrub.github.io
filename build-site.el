;; Load the publishing system.
(require 'ox-publish)

;; Source-block syntax highlighting via htmlize. Vendored under lisp/ so
;; the batch build (emacs -Q --script) does not depend on package init or
;; the user's elpa. Output type 'css makes htmlize emit CSS classes that
;; style.css colors — keeps the palette in the site, not the emacs theme.
(add-to-list 'load-path
             (expand-file-name "lisp"
                               (file-name-directory load-file-name)))
(require 'htmlize)
(setq org-html-htmlize-output-type 'css)

;; Wrap exported source blocks in a peek-with-see-more shell. The block
;; defaults to a clipped preview (~5 lines) with a soft fade at the
;; bottom and a small "see more" button centered below; checking the
;; hidden checkbox via its label expands the block to full height.
;; Pure HTML/CSS — no JS — via the :checked sibling selector. Each
;; block needs a unique id so the label/checkbox pair is unambiguous;
;; a per-export counter handles that.
(defvar mps-org-html-src-peek-skip-langs
  '("bibtex")
  "Languages whose source blocks should NOT be wrapped in a peek.
Bibtex entries on publications.html already sit inside their own
disclosure (the per-entry \"bibtex\" toggle), so adding the peek shell
on top would create redundant chrome.")

(defvar mps-org-html-src-peek-counter 0
  "Counter for unique src-peek checkbox ids; reset at the start of each export.")

(defun mps-org-html-src-peek-reset-counter (&rest _)
  "Reset the src-peek id counter so each exported file starts at peek-1."
  (setq mps-org-html-src-peek-counter 0))

(add-hook 'org-export-before-processing-functions
          #'mps-org-html-src-peek-reset-counter)

(defun mps-org-html-peek-src-block (text backend _info)
  "Wrap HTML-exported source-block TEXT in a click-to-expand peek wrapper."
  (if (and (org-export-derived-backend-p backend 'html)
           (string-match "class=\"src src-\\([^\" ]+\\)\"" text))
      (let ((lang (match-string 1 text)))
        (if (member lang mps-org-html-src-peek-skip-langs)
            text
          (cl-incf mps-org-html-src-peek-counter)
          (let ((id (format "peek-%d" mps-org-html-src-peek-counter)))
            (format "<div class=\"src-peek\">\n<input type=\"checkbox\" id=\"%s\" hidden>\n<div class=\"src-peek-content\">\n%s\n</div>\n<label for=\"%s\"></label>\n</div>"
                    id text id))))
    text))

(add-to-list 'org-export-filter-src-block-functions
             #'mps-org-html-peek-src-block)

;; Pull a #+RESULTS-style example block into the .src-peek-content of
;; the peek wrapper immediately preceding it, so source and output are
;; clipped/expanded together. Run as a final-output filter because the
;; source-block filter only sees the source, not the sibling that
;; follows it in document order.
(defun mps-org-html-merge-result-into-peek (text backend _info)
  "Move <pre class=\"example\"> into the preceding .src-peek-content."
  (if (org-export-derived-backend-p backend 'html)
      (replace-regexp-in-string
       "\\(<div class=\"src-peek-content\">\\(?:.\\|\n\\)*?\\)\\(\n</div>\n<label for=\"peek-[0-9]+\"></label>\n</div>\\)\\([\n\t ]*<pre class=\"example\">\\(?:.\\|\n\\)*?</pre>\\)"
       "\\1\\3\\2"
       text)
    text))

(add-to-list 'org-export-filter-final-output-functions
             #'mps-org-html-merge-result-into-peek)

;; Let org use imagemagick to set the image to the desired width.
(setq org-image-actual-width nil)

;; Define the publishing project.
(setq org-publish-project-alist
      (list
       (list "mps-content"
             :recursive t
             :base-directory "./content"
             :publishing-directory "./public"
             :publishing-function 'org-html-publish-to-html
             :with-author nil
             :with-creator nil
             :with-date t
             :with-toc nil
             :section-numbers nil
             :time-stamp-file nil)
       (list "mps-blog"
             :recursive t
             :base-directory "./content/blog"
             :publishing-directory "./public/blog"
             :publishing-function 'org-html-publish-to-html
             :with-author nil
             :with-creator nil
             :with-date t
             :with-toc nil
             :section-numbers nil
             :time-stamp-file nil)
       (list "mps-css"
             :recursive nil
             :base-directory "./style"
             :base-extension "css\\|js"
             :publishing-directory "./public"
             :publishing-function 'org-publish-attachment)
       (list "mps-assets"
             :recursive nil
             :base-directory "./assets"
             :base-extension "pdf\\|svg\\|jpg\\|png\\|gif\\|mp4"
             :publishing-directory "./public/assets"
             :publishing-function 'org-publish-attachment)
       ;; Publish favicon.ico to the site root so browsers' default
       ;; /favicon.ico request resolves and the console 404 disappears.
       (list "mps-favicon"
             :recursive nil
             :base-directory "./assets"
             :base-extension "ico"
             :publishing-directory "./public"
             :publishing-function 'org-publish-attachment)))

;; Remove the validation link.
(setq org-html-validation-link nil)

;; Remove default headers and style.
(setq org-html-head-include-scripts nil)
(setq org-html-head-include-default-style nil)

;; Include my own css style.
(setq org-html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">")

;; Inject bibtex copy-button behaviour.
(setq org-html-head (concat org-html-head "<script src=\"bibtex-copy.js\" defer></script>"))

;; Open all links in external tabs, unless specified otherwise.
(setq org-html-head (concat org-html-head "<base target=\"_blank\">"))

;; Default preview image for social/chat link unfurling. Per-page description
;; comes from each file's #+description and is emitted natively by org.
(setq org-html-head
      (concat org-html-head
              "<meta property=\"og:image\" content=\"https://www.marlinstrub.com/assets/profile_picture.jpg\">"))

;; Favicons. The .ico is served from the site root for the browsers' default
;; request; the SVG and apple-touch-icon variants are referenced explicitly.
(setq org-html-head
      (concat org-html-head
              "<link rel=\"icon\" type=\"image/svg+xml\" href=\"/assets/favicon.svg\">"
              "<link rel=\"icon\" type=\"image/x-icon\" href=\"/favicon.ico\">"
              "<link rel=\"apple-touch-icon\" href=\"/assets/apple-touch-icon.png\">"))

;; Footer with contact links. Icons are inline Tabler Icons (outline):
;; mail, brand-github, brand-linkedin. Stroke colour follows currentColor.
(setq org-html-postamble t)
(setq org-html-postamble-format
      '(("en" "<nav class=\"site-footer\">
<a href=\"mailto:marlin.strub@gmail.com\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" aria-hidden=\"true\"><path d=\"M3 7a2 2 0 0 1 2 -2h14a2 2 0 0 1 2 2v10a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2v-10z\"/><path d=\"M3 7l9 6l9 -6\"/></svg>Email</a>
<span class=\"separator\">·</span>
<a href=\"https://github.com/marlinstrub\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" aria-hidden=\"true\"><path d=\"M9 19c-4.3 1.4 -4.3 -2.5 -6 -3m12 5v-3.5c0 -1 .1 -1.4 -.5 -2c2.8 -.3 5.5 -1.4 5.5 -6a4.6 4.6 0 0 0 -1.3 -3.2a4.2 4.2 0 0 0 -.1 -3.2s-1.1 -.3 -3.5 1.3a12.3 12.3 0 0 0 -6.2 0c-2.4 -1.6 -3.5 -1.3 -3.5 -1.3a4.2 4.2 0 0 0 -.1 3.2a4.6 4.6 0 0 0 -1.3 3.2c0 4.6 2.7 5.7 5.5 6c-.6 .6 -.6 1.2 -.5 2v3.5\"/></svg>GitHub</a>
<span class=\"separator\">·</span>
<a href=\"https://linkedin.com/in/marlinstrub\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" aria-hidden=\"true\"><path d=\"M4 4m0 2a2 2 0 0 1 2 -2h12a2 2 0 0 1 2 2v12a2 2 0 0 1 -2 2h-12a2 2 0 0 1 -2 -2z\"/><path d=\"M8 11l0 5\"/><path d=\"M8 8l0 .01\"/><path d=\"M12 16l0 -5\"/><path d=\"M16 16v-3a2 2 0 0 0 -4 0\"/></svg>LinkedIn</a>
</nav>")))

;; Generate the html. The 't' is for discarding cached values.
(org-publish-all t)

(message "Build complete.")
