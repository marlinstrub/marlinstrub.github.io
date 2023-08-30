;; Load the publishing system.
(require 'ox-publish)

;; Define the publishing project.
(setq org-publish-project-alist
      (list
       (list "mps-content"
             :recursive t
             :base-directory "./content"
             :publishing-directory "./public"
             :publishing-function 'org-html-publish-to-html
             :with-author nil
             :with-creator t
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
             :base-extension "pdf\\|jpg\\|gif"
             :publishing-directory "./public/assets"
             :publishing-function 'org-publish-attachment)))

;; Remove the validation link.
(setq org-html-validation-link nil)

;; Remove default headers and include our own css style.
(setq org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-html-head "<link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">
<link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>
<link href=\"https://fonts.googleapis.com/css2?family=Roboto+Mono:ital,wght@0,300;0,400;1,300&display=swap\" rel=\"stylesheet\">
<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">")

;; Generate the html. The 't' is for discarding cached values.
(org-publish-all t)

(message "Build complete.")
