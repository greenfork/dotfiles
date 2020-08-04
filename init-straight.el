;; How to install from repo:
;; cd ~/.emacs.d/
;; ln -s /home/grfork/reps/dotfiles/init-straight.el init.el
;; ln -s /home/grfork/reps/dotfiles/init-straight.org

(require 'org)
(org-babel-load-file
 (expand-file-name "init-straight.org" user-emacs-directory))
