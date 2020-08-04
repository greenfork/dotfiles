;;; Additional personal configuration for Prelude package:
;;; https://github.com/bbatsov/prelude
;;; File location: ~/.emacs.d/personal/personal-prelude.el

;;; Code:

(set-frame-font "Fantasque Sans Mono 12" nil t)
(toggle-scroll-bar -1)
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(global-set-key (kbd "C-o") 'pop-to-mark-command)
(key-chord-define-global "jj" 'avy-goto-char-2)
(setq prelude-format-on-save nil)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ruby-insert-encoding-magic-comment nil)
(add-hook 'js2-mode-hook 'prettier-js-mode)

(setq prelude-whitespace nil)
(prelude-require-package 'ws-butler)
(add-hook 'prog-mode-hook #'ws-butler-mode)

(prelude-require-package 'hl-fill-column)
(require 'hl-fill-column)
(add-hook 'prog-mode-hook (lambda ()
                            (set-fill-column 80)
                            (hl-fill-column-mode)))

;;; Nim programming language
;;; first install `nim-mode' and `indent-guide', `flycheck-nim' from MELPA
;; (setenv "PATH" (concat (getenv "PATH") ":/home/grfork/.nimble/bin"))
;; (setq exec-path (append exec-path '("/home/grfork/.nimble/bin")))
;; (setq nimsuggest-path "/home/grfork/.nimble/bin/nimsuggest")
;; (add-hook 'nim-mode-hook 'nimsuggest-mode) ;; leaks memory
;; (add-hook 'nimsuggest-mode-hook 'company-mode)
;; (add-hook 'nimsuggest-mode-hook 'flycheck-mode)
;; (add-hook 'nim-mode-hook 'indent-guide-mode)
;; (add-hook 'nim-mode-hook 'subword-mode)

;;; Elixir programming language
;;; first install `elixir-mode' and `alchemist' from MELPA
;; (add-hook 'elixir-mode-hook 'alchemist-mode)

;;; Company mode
(progn
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-f") 'company-complete-selection)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map [return] nil)
  (define-key company-active-map (kbd "RET") nil))

;;; I have `super' key in use with my window manager, the following
;;; settings are intended to remove or change any use of this key
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
