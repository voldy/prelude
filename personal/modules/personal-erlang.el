;;; Code:

;; take care about soft tabs
(add-hook 'erlang-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)
            (setq-default tab-width 4)))

(add-hook 'erlang-mode-hook
          (lambda () (modify-syntax-entry ?_ "w")))

(add-to-list 'auto-mode-alist '("rebar.config$" . erlang-mode))
(add-to-list 'auto-mode-alist '(".erlang$" . erlang-mode))
(add-to-list 'auto-mode-alist '("sys.config$" . erlang-mode))
(add-to-list 'auto-mode-alist '("app.config$" . erlang-mode))
(add-to-list 'auto-mode-alist '("Emakefile$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.rel$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.app$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.appSrc$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.app.src$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.escript$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.[heyx]rl$" . erlang-mode))

;; add include directory to default compile path
(defvar erlang-compile-extra-opts
  '(bin_opt_info debug_info
                 (i . "../include")
                 (i . "../deps")
                 (i . "../deps/annotations/include")
                 (d . \'TEST\')))

;; define where put beam files
(setq erlang-compile-outdir "../ebin")

(setq erl-nodename-cache 'emacs@127.0.0.1)
(setq inferior-erlang-machine-options
       '("-name" "emacs@127.0.0.1"))
(setq distel-modeline-node "emacs@127.0.0.1")
(setq wrangler-erl-node "emacs@127.0.0.1")

(add-to-list 'load-path
             (expand-file-name "vendor/wrangler/elisp" prelude-personal-dir))

(require 'wrangler)

;; enable compilation in time to verify errors
(require 'erlang-flymake)

(defun ebm-find-rebar-top-recr (dirname)
  (let* ((project-dir (locate-dominating-file dirname "rebar.config")))
    (if project-dir
        (let* ((parent-dir
                (file-name-directory (directory-file-name project-dir)))
               (top-project-dir
                (if (and parent-dir (not (string= parent-dir "/")))
                                    (ebm-find-rebar-top-recr parent-dir)
                                  nil)))
          (if top-project-dir
              top-project-dir
            project-dir))
      project-dir)))

(defun ebm-find-rebar-top ()
  (interactive)
  (let* ((dirname (file-name-directory (buffer-file-name)))
         (project-dir (ebm-find-rebar-top-recr dirname)))
    (if project-dir
        project-dir
      (erlang-flymake-get-app-dir))))

(defun ebm-directory-dirs (dir name)
  "Find all directories in DIR."
  (unless (file-directory-p dir)
    (error "Not a directory `%s'" dir))
  (let ((dir (directory-file-name dir))
        (dirs '())
        (files (directory-files dir nil nil t)))
    (dolist (file files)
      (unless (member file '("." ".."))
        (let ((absolute-path (expand-file-name (concat dir "/" file))))
          (when (file-directory-p absolute-path)
            (if (string= file name)
                (setq dirs (append
                            (cons absolute-path
                                  (ebm-directory-dirs absolute-path name))
                            dirs))
              (setq dirs (append
                          (ebm-directory-dirs absolute-path name)
                          dirs)))))))
    dirs))

(defun ebm-get-deps-code-path-dirs ()
  (ebm-directory-dirs (ebm-find-rebar-top) "ebin"))
(defun ebm-get-deps-include-dirs ()
  (ebm-directory-dirs (ebm-find-rebar-top) "include"))

(fset 'erlang-flymake-get-code-path-dirs 'ebm-get-deps-code-path-dirs)
(fset 'erlang-flymake-get-include-dirs-function 'ebm-get-deps-include-dirs)
(erlang-flymake-only-on-save)

(provide 'personal-erlang)
;;; personal-erlang.el ends here
