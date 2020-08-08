;; Emacs probably requires hard links to work properly from v27.
;; How to install from repo:
;; cd ~/.emacs.d/
;; ln /home/grfork/reps/dotfiles/init-straight.el init.el
;; ln /home/grfork/reps/dotfiles/init-straight.org

(require 'org)
(org-babel-load-file
 (expand-file-name "init-straight.org" user-emacs-directory))
