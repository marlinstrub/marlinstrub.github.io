;; Load the publishing system.
(require 'ox-publish)

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
       (list "mps-css"
             :recursive nil
             :base-directory "./style"
             :base-extension "css"
             :publishing-directory "./public"
             :publishing-function 'org-publish-attachment)
       (list "mps-assets"
             :recursive nil
             :base-directory "./assets"
             :base-extension "pdf\\|svg\\|jpg\\|gif\\|mp4"
             :publishing-directory "./public/assets"
             :publishing-function 'org-publish-attachment)))

;; Remove the validation link.
(setq org-html-validation-link nil)

;; Remove default headers and style.
(setq org-html-head-include-scripts nil)
(setq org-html-head-include-default-style nil)

;; Include my own css style.
(setq org-html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">")

;; Open all links in external tabs, unless specified otherwise.
(setq org-html-head (concat org-html-head "<base target=\"_blank\">"))

;; Default preview image for social/chat link unfurling. Per-page description
;; comes from each file's #+description and is emitted natively by org.
(setq org-html-head
      (concat org-html-head
              "<meta property=\"og:image\" content=\"https://www.marlinstrub.com/assets/profile_picture.jpg\">"))

;; Footer with contact links.
(setq org-html-postamble t)
(setq org-html-postamble-format
      '(("en" "<nav class=\"site-footer\">
<a href=\"mailto:marlin.strub@gmail.com\">Email</a>
<span class=\"separator\">·</span>
<a href=\"https://github.com/marlinstrub\">GitHub</a>
<span class=\"separator\">·</span>
<a href=\"https://linkedin.com/in/marlinstrub\">LinkedIn</a>
</nav>")))

;; Generate the html. The 't' is for discarding cached values.
(org-publish-all t)

(message "Build complete.")
