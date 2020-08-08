;;; init.el --- grfork's Emacs init file -*- lexical-binding: t -*-

;;; Commentary:

;; How to install from repo:
;; cd ~/.emacs.d/
;; cp /home/grfork/reps/dotfiles/init-straight.el init.el
;; cp /home/grfork/reps/dotfiles/init-straight.org .

;;; Code:

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(org-babel-load-file
 (expand-file-name "init-straight.org" user-emacs-directory))

;; Copy files to version control.
(copy-file user-init-file "~/reps/dotfiles/init-straight.el" t)
(copy-file (concat (file-name-directory user-init-file) "init-straight.org")
           "~/reps/dotfiles/init-straight.org" t)

(provide 'init)
;;; init.el ends here
