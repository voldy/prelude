;;; Code:

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar personal-packages
  '(django-theme
    ruby-mode
    erlang
    web-mode
    magit
    magit-gh-pulls
    magit-push-remote
    magithub
    nav
    dash-at-point
    dired-details)
  "A list of personal packages to ensure are installed at launch.")

(defun personal-packages-installed-p ()
  (loop for p in personal-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

(unless (personal-packages-installed-p)
  (message "%s" "Emacs Prelude is now refreshing personal package database...")
  (dolist (p personal-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(provide 'personal-packages)
;;; personal-packages.el ends here
