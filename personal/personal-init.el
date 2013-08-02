;;; Code:

(setq prelude-guru nil)
(server-force-delete)
(server-start)

;(byte-recompile-directory (expand-file-name "~/.emacs.d/personal") 0)

;; add the first level subfolders of personal automatically
(prelude-add-subfolders-to-load-path prelude-personal-dir)
(prelude-add-subfolders-to-load-path (expand-file-name "vendor" prelude-personal-dir))
(prelude-add-subfolders-to-load-path (expand-file-name "modules" prelude-personal-dir))

(require 'personal-core)
(require 'personal-packages)
(require 'personal-ui)
(require 'personal-general)
(require 'personal-erlang)
(require 'personal-ruby)
(require 'personal-git)
(require 'personal-keybindings)

(run-with-idle-timer 0.5 nil 'toggle-fullscreen)
