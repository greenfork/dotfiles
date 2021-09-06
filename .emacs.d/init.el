;;; init.el --- greenfork's Emacs init file -*- lexical-binding: t -*-

;;; Commentary:
;; So far nothing.

;;; Code:

(setq inhibit-startup-echo-area-message "grfork") ; read the docstring

;;; Actually try to use `custom.el' file. We load it at the very beginning
;;; so that further values values can override any settings in the custom
;;; file. Not all values are supposed to be in `custom.el', some default
;;; values are better specified in the config file.
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(org-babel-load-file
 (expand-file-name "org-init.org" user-emacs-directory))

(provide 'init)
;;; init.el ends here
