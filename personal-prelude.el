;;; Additional personal configuration for Prelude package:
;;; https://github.com/bbatsov/prelude
;;; File location: ~/.emacs.d/personal/personal-prelude.el

(toggle-scroll-bar -1)
(add-to-list 'default-frame-alist
             '(vertical-scroll-bars . nil))

;;; Lua
(prelude-require-packages '(lua-mode))
(setq lua-default-application "/usr/local/bin/lua53")

;;; Company mode
(progn
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-f") 'company-complete-selection)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map [return] nil)
  (define-key company-active-map (kbd "RET") nil))

;;; Prelude minor
(progn
  (define-key prelude-mode-map [(meta shift o)] 'crux-smart-open-line-above)
  (key-chord-define prelude-mode-map "fd" 'crux-kill-whole-line)
  (define-key prelude-mode-map (kbd "s-o") nil) ;; 'crux-smart-open-line-above
  (define-key prelude-mode-map (kbd "s-r") nil) ;; recent files (currently C-c f)
  (define-key prelude-mode-map (kbd "s-p") nil) ;; projectile prefix (currently C-c p)
  (define-key prelude-mode-map (kbd "s-j") nil) ;; 'crux-top-join-line (currently C-^)
  (define-key prelude-mode-map (kbd "s-k") nil) ;; 'crux-kill-whole-line
  (define-key prelude-mode-map (kbd "s-m m") nil) ;; magit stuff
  (define-key prelude-mode-map (kbd "s-m l") nil) ;; magit stuff
  (define-key prelude-mode-map (kbd "s-m f") nil) ;; magit stuff
  (define-key prelude-mode-map (kbd "s-m b") nil) ;; magit stuff
  (define-key prelude-mode-map (kbd "s-w") nil) ;; 'ace-window (currently C-x o)
  (define-key prelude-mode-map (kbd "s-.") nil) ;; 'avy-goto-word-or-subword-1 (currently keychord "jj")
  (define-key prelude-mode-map (kbd "s-y") nil) ;; 'browse-kill-ring (currently keychord "yy")
  )
;;; Prelude global
(progn
  (define-key prelude-mode-map (kbd "C-x p") nil) ;; 'proced (not available on OpenBSD, only Linux)
  )
(setq prelude-flyspell nil)
