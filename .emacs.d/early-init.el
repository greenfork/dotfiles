;;; early-init.el --- Early Init File -*- lexical-binding: t -*-

;; Copyright (c) 2020-2021  Protesilaos Stavrou <info@protesilaos.com>
;; Copyright (c) 2021 Dmitry Matveyev <public@greenfork.me>

;; Author: Protesilaos Stavrou <info@protesilaos.com>
;; URL: https://protesilaos.com/dotemacs
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1"))

;; This file is NOT part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See my dotfiles: https://gitlab.com/protesilaos/dotfiles

;;; Code:

;; Do not resize the frame at this early stage.
(setq frame-inhibit-implied-resize t)

;; Disable GUI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-splash-screen t)
(setq use-dialog-box t)                 ; only for mouse events
(setq use-file-dialog nil)
(setq default-frame-alist '((undecorated . t))) ; hide top window title bar
(set-frame-parameter nil 'alpha-background 80) ; in version 29 there will be opacity

(setq inhibit-startup-screen t)
(setq inhibit-startup-buffer-menu t)

(setq package-enable-at-startup nil)    ; as recommended in straight.el

;; (setq native-comp-async-report-warnings-errors 'silent) ; emacs28 with native compilation

;;; early-init.el ends here
