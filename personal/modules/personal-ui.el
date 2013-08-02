;;; Code:

;; configure theme
(disable-theme 'zenburn)

(if (display-graphic-p)
    (progn
      (load-theme 'django t))
    (load-theme 'hemisu-dark t))

;; enable fullscreen on start
;;(set-frame-parameter nil 'fullscreen 'fullboth)

;; configure font
(setq default-frame-alist
    '((font . "Inconsolata-20")))

;; configure fringe
(if (fboundp 'fringe-mode)
    (fringe-mode '(nil . 0)))

;; turn off fringe indicators
(setq-default fringe-indicator-alist ())

;; turn off the scroll bars
(scroll-bar-mode 0)

;; turn off the ring bell
(setq ring-bell-function 'ignore)

;; turn off the visible cursor in non-selected windows
(setq-default cursor-in-non-selected-windows nil)

(set-default 'cursor-type 'bar)
;; display ido completation verticaly
(setq ido-decorations
     '("\n-> "
       ""
       "\n   "
       "\n   ..."
       "[" "]"
       " [No match]"
       " [Matched]"
       " [Not readable]"
       " [Too big]"
       " [Confirm]"))

;; enable truncate
(setq-default truncate-lines t)

(provide 'personal-ui)
;;; prelude-ui.el ends here
