(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-time-mode t)
 '(inhibit-startup-screen t)
 '(load-home-init-file t t)
 '(sh-basic-offset 2)
 '(show-paren-mode t)
 '(tex-dvi-view-command "xdvi")
 '(transient-mark-mode (quote (only . t))))
 '(package-selected-packages '(use-package)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
;; '(default ((t (:inherit nil :stipple nil :background "SystemWindow" :foreground "SystemWindowText" :inverse-video nil :box nil :str ike-through nil :overline nil :underline nil :slant normal :weight normal :height 163 :width normal :foundry "outline" :family "Courier New"))))
)

; To turn on auto-fill mode just once for one buffer, enter M-x auto-fill-mode
; To turn on auto-fill mode for every buffer in text mode:
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'c-mode-hook 'turn-on-auto-fill)
(add-hook 'java-mode-hook 'turn-on-auto-fill)
(add-hook 'fundamental-mode-hook 'turn-on-auto-fill)
(add-hook 'tex-mode-hook 'turn-on-auto-fill)
; To turn on auto-fill mode for all major modes:
; Not sure if this supercedes above lines
(setq-default auto-fill-function 'do-auto-fill)

;; User info
(setq user-full-name "Francis O'Donovan")
;;(setq user-mail-address "user@name.com")

;; Disable the silly ring
;; (setq ring-bell-function '(lambda()))

;;;;Enable the bell- but make it visible and not aural.
(setq visible-bell t)

(setq hostname (getenv "HOSTNAME"))

;;;;Require C-x C-c prompt. I've closed too often by accident.
;;;;http://www.dotemacs.de/dotfiles/KilianAFoth.emacs.html
(global-set-key [(control x) (control c)]
  (function
   (lambda () (interactive)
     (cond ((y-or-n-p "Quit? ")
        (save-buffers-kill-emacs))))))
;;;;C-x k is a command I use often, but C-x C-k (an easy mistake) is
;;;;bound to nothing!
;;;;Set C-x C-k to same thing as C-x k.
(global-set-key "\C-x\C-k" 'kill-this-buffer)

;;;;Change pasting behavior. Normally, it pastes where the mouse
;;;;is at, which is not necessarily where the cursor is. This changes
;;;;things so all pastes, whether they be middle-click or C-y or menu,
;;;;all paste at the cursor.
(setq mouse-yank-at-point t)

;;;;While we are at it, always flash for parens.
(show-paren-mode 1)

;;;;The autosave is typically done by keystrokes, but I'd like to save
;;;;after a certain amount of time as well.
(setq auto-save-timeout 1800)

;;;;Call a function which will have the time displayed in the modeline
(display-time)

;;;;Show column number in mode line
(setq column-number-mode t)

;;;;;Accelerate the cursor when scrolling.
(load "accel" t t)

;;;;Start scrolling when 2 lines from top/bottom
(setq scroll-margin 2)

;;;;;Push the mouse out of the way when the cursor approaches.
(mouse-avoidance-mode 'jump)

(condition-case nil
  (load (expand-file-name "~/.emacs.d/elpa/package.el"))
  (require 'package)
  (add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
  (when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
  (package-initialize)
  (error (message "package plugin unavailable, skipping load ...")))

;;;SavePlace- this puts the cursor in the last place you editted
;;;a particular file. This is very useful for large files.
(require 'saveplace)
(setq-default save-place t)
; If I get an error about
; 'Wrong type argument listp \.\.\.'
; delete ~/.emacs-places and start over.

;;;;Completion ignores filenames ending in any string in this list.
;(setq completion-ignored-extensions
                    ;  '(".o" ".elc" ".class" "java~" ".ps" ".abs" ".mx" ".~jv" ))

;;;We can also get completion in the mini-buffer as well.
(icomplete-mode t)

;;;Text files supposedly end in new lines. Or they should.
(setq require-final-newline t)

;;;;"Recentf is a minor mode that builds a list of recently opened
;;;;files. This list is is automatically saved across Emacs sessions.
;;;;You can then access this list through a menu."
;;;;http://www.emacswiki.org/cgi-bin/wiki/recentf-buffer.el
(require 'recentf)
(setq recentf-auto-cleanup 'never) ;;To protect tramp
(recentf-mode 1)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;;  Don't display passwords
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;;(set-default-font
;; "-adobe-courier-medium-r-normal--18-180-75-75-m-110-iso8859-1")

; Use aspell
(setq-default ispell-program-name"aspell")
; Turn on auto spell check for text mode.
 (dolist (hook '(text-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))

;; Load pandoc-mode
;(add-to-list 'load-path "~/.emacs.d")
;(require 'cl)
; http://joostkremers.github.com/pandoc-mode/
;(load "pandoc-mode")
;(add-to-list 'auto-mode-alist '("\\.md\\'" . pandoc-mode))

(setq debug-on-error t)

(let ((default-directory "/usr/local/share/emacs/site-lisp/"))
  (normal-top-level-add-subdirs-to-load-path))

; (condition-case nil
;   (require 'git-messenger)
;   (setq git-messenger:show-detail t)
;   (error (message "git-messenger plugin unavailable, skipping load ...")))
;
;(condition-case nil
;  (require 'gitattributes-mode)
;  (add-to-list 'auto-mode-alist '("^\.gitattributes$"
;                . gitattributes-mode))
;  (error (message "gitattributes-mode plugin unavailable, skipping load ...")))
;
;(condition-case nil
;  (require 'gitconfig-mode)
;  (add-to-list 'auto-mode-alist '("^\.gitconfig$" . gitconfig-mode))
;  (error (message "gitconfig-mode plugin unavailable, skipping load ...")))
;
;(condition-case nil
;  (require 'gitignore-mode)
;  (add-to-list 'auto-mode-alist '("^\.gitignore$" . gitignore-mode))
;  (add-to-list 'auto-mode-alist '("\.git/info/attributes$"
;                . gitignore-mode))
;  (add-to-list 'auto-mode-alist '("\.git/config$" . gitignore-mode))
;  (add-to-list 'auto-mode-alist '("\.git/info/exclude$" . gitignore-mode))
;  (error (message "gitignore-mode plugin unavailable, skipping load ...")))
;
;(condition-case nil
;  (require 'inf-ruby)
;  (autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby
;process" t)
;  (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
;  (error (message "inf-ruby plugin unavailable, skipping load ...")))
;
;(condition-case nil
;  (require 'markdown-mode)
;  (add-to-list 'auto-mode-alist '("\.markdown$" . markdown-mode))
;  (add-to-list 'auto-mode-alist '("\.mdown$" . markdown-mode))
;  (add-to-list 'auto-mode-alist '("\.md$" . markdown-mode))
;  (error (message "inf-ruby plugin unavailable, skipping load ...")))
;
;; For mouseterm https://github.com/saitoha/mouseterm-plus/releases/latest
(unless window-system
  (xterm-mouse-mode 1)
  (global-set-key [mouse-4] '(lambda ()
                   (interactive)
                   (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                   (interactive)
                   (scroll-up 1))))

;;; https://github.com/yoshiki/yaml-mode
;(require 'yaml-mode)
;    (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
;
;;; https://joostkremers.github.io/pandoc-mode/
;(require 'pandoc-mode)
;  (add-hook 'pandoc-mode-hook 'pandoc-load-default-settings)
;
;;; http://jblevins.org/projects/markdown-mode/
;(autoload 'markdown-mode "markdown-mode"
;   "Major mode for editing Markdown files" t)
;(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
;(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;(autoload 'gfm-mode "gfm-mode"
;   "Major mode for editing GitHub Flavored Markdown files" t)
;(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
;
;;; https://github.com/Sterlingg/json-snatcher
;(require 'json-snatcher)
;  (defun js-mode-bindings ()
;     "Sets a hotkey for using the json-snatcher plugin"
;       (when (string-match  "\\.json$" (buffer-name))
;             (local-set-key (kbd "C-c C-g") 'jsons-print-path)))
;     (add-hook 'js-mode-hook 'js-mode-bindings)
;     (add-hook 'js2-mode-hook 'js-mode-bindings)
;
;;; https://github.com/dunn/homebrew-mode
;(add-to-list 'load-path "homebrew-mode")
;(require 'homebrew-mode)
;(global-homebrew-mode)
;
;;; https://github.com/nonsequitur/inf-ruby
;(autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
;(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
;(add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)

;; https://github.com/sellout/emacs-color-theme-solarized
;(add-to-list 'custom-theme-load-path "/usr/local/share/emacs/site-lisp/solarized-emacs")
;(load-theme 'solarized t)
;(setq solarized-termcolors 256)
;(add-to-list 'default-frame-alist '(background-mode . dark))

;; Don't use TABS for indentations.
(setq-default indent-tabs-mode nil)

;; Set the number to the number of columns to use.
(setq-default fill-column 120)

;; Show line number in the mode line.
(line-number-mode 1)

;; Show column number in the mode line.
(column-number-mode 1)

;; Enable syntax highlighting. This will also highlight lines that form a region.
(global-font-lock-mode 1)

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))
(use-package python-black
  :demand t
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim)
)
