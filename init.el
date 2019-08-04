;;; init.el --- My init file for Emacs -*- lexical-binding: t -*-
;;; Commentary:

;; Use Emacs for everything but coding (excluding eLisp).
;; Coding is done with Kakoune, alright?

;;; Code:

;; TODO: Rebind to smth useful
;; digit-argument	【Alt+0】 to 【Alt+9】
;; negative-argument	【Alt+-】
;; move-to-window-line	【Alt+r】
;; prefix for highlighting	【Alt+s】
;; tab-to-tab-stop	【Alt+i】
;; indent-new-comment-line	【Alt+j】
;; tmm-menubar	【Alt+'】
;; back-to-indentation	【Alt+m】
;; tags-loop-continue	【Alt+,】
;; find-tag	【Alt+.】


(setq package-archives '(;("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(eval-when-compile
  (require 'use-package)
  (setq use-package-always-ensure t))

;; Essentials
(toggle-scroll-bar -1)
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(add-to-list 'default-frame-alist '(height . 46))
(add-to-list 'default-frame-alist '(width . 184))
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(set-face-attribute 'default nil :font "Iosevka" :height 90)
(global-auto-revert-mode 1)
(delete-selection-mode 1)
(global-subword-mode 1)

(setq-default
 indicate-empty-lines 1
 tab-width 4
 fill-column 80)

(setq
 scroll-conservatively most-positive-fixnum
 column-number-mode t
 auto-save-timeout 60
 load-prefer-newer t
 read-file-name-completion-ignore-case t
 indent-tabs-mode nil
 require-final-newline t
 uniquify-buffer-name-style 'forward
 gc-cons-threshold 800000
 create-lockfiles nil
 backup-directory-alist '(("." . "~/.emacs.d/backup"))
 backup-by-copying t    ; Don't delink hardlinks
 version-control t      ; Use version numbers on backups
 delete-old-versions t  ; Automatically delete excess backups
 kept-new-versions 20   ; how many of the newest versions to keep
 kept-old-versions 5    ; and how many of the old
 )

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "M-/") 'hippie-expand)

(use-package crux
  :bind (("M-o" . crux-smart-open-line)
         ("M-O" . crux-smart-open-line-above)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-c D" . crux-delete-file-and-buffer)
         ("C-c r" . crux-rename-file-and-buffer)
         ("C-^" . crux-top-join-line)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line))
  :config (progn
            (crux-with-region-or-line kill-region)
            (crux-with-region-or-line kill-ring-save)))

(add-hook 'prog-mode-hook 'my-prog-mode-hook)
(defun my-prog-mode-hook ()
  "Prog mode hook consisting of built-in functions and packages."
  (show-paren-mode 1)
  (electric-pair-local-mode t)
  (setq show-trailing-whitespace t))

(use-package diminish
  :config (progn
            (diminish 'eldoc-mode)
            (diminish 'subword-mode)))
(use-package which-key
  :diminish
  :config (which-key-mode t))
(use-package anzu
  :diminish
  :config (global-anzu-mode 1))
(use-package ido
  :init (setq ido-enable-flex-matching t
              ido-everywhere 1)
  :config (ido-mode 1))
(use-package ido-completing-read+
  :config (ido-ubiquitous-mode 1))
(use-package smex
  :config (smex-initialize)
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)))
(use-package ido-yes-or-no
  :config (ido-yes-or-no-mode 1))
(use-package winner
  :config (winner-mode 1))
;; (use-package highlight-parentheses
;;   :hook (prog-mode . highlight-parentheses-mode))
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package ace-window
  :bind (("C-x o" . ace-window)))
(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-c C-d" . helpful-at-point)))
(use-package flycheck
  :init (global-flycheck-mode))
(use-package cyberpunk-theme
  :config (load-theme 'cyberpunk t))
(use-package erc
  :init (load "~/.emacs.d/.erc-auth"))
;; (use-package ledger-mode
;;   :mode ("\\.journal\\'" "\\.hledger\\'")
;;   :init
;;   (setq ledger-init-file-name (expand-file-name "~/.hledger.journal")
;;     ledger-binary-path (expand-file-name "~/.cabal/bin/hledger"))
;;   (defun find-ledger-file () (interactive) (find-file ledger-init-file-name)))
(use-package hledger-mode
  :mode ("\\.journal\\'" "\\.hledger\\'")
  :init (setq hledger-jfile (expand-file-name "~/.hledger.journal"))
  (defun find-ledger-file () (interactive) (find-file hledger-jfile)))
(use-package smooth-scrolling
  :init (setq smooth-scroll-margin 7)
  :hook (prog-mode . smooth-scrolling-mode))
(use-package ox-twbs)
(use-package perspective
  :config (persp-mode))
(use-package company
  :diminish
  :config (progn
            (global-company-mode)
            (define-key company-active-map (kbd "M-n") nil)
            (define-key company-active-map (kbd "M-p") nil)
            (define-key company-active-map (kbd "RET") nil)
            (define-key company-active-map [return] nil)
            (define-key company-active-map (kbd "C-n") 'company-select-next)
            (define-key company-active-map (kbd "C-p") 'company-select-previous)
            (define-key company-active-map (kbd "C-f") 'company-complete-selection)))
(use-package imenu-anywhere
  :bind (("C-." . imenu-anywhere)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
	("1e9001d2f6ffb095eafd9514b4d5974b720b275143fbc89ea046495a99c940b0" default)))
 '(erc-button-google-url "http://www.duckduckgo.com/search?q=%s")
 '(erc-modules
   (quote
	(autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands notifications readonly ring stamp track)))
 '(package-hidden-regexps nil)
 '(package-selected-packages
   (quote
	(imenu-anywhere highlight-defined crux diminish perspective company ox-twbs smooth-scrolling hledger-mode rainbow-delimiters highlight-parentheses flycheck-ledger ido-completing-read+ ido-yes-or-no smex cyberpunk-theme flycheck use-package helpful anzu which-key ace-window))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-unmatched-face ((t (:inherit rainbow-delimiters-base-face :foreground "magenta")))))

(provide 'init)
;;; init.el ends here
