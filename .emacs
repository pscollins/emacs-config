;; Add in custom config files
(add-to-list 'load-path "~/.emacs.d/config/")


;; source: http://nex-3.com/posts/45-efficient-window-switching-in-emacs#comments
(defvar real-keyboard-keys
  '(("M-<up>"        . "[1;9A")
    ("M-<down>"      . "[1;9B")
    ("M-<right>"     . "[1;9C")
    ("M-<left>"      . "[1;9D")

    ("M-shift-<up>"        . "[1;10A")
    ("M-shift-<down>"      . "[1;10B")
    ("M-shift-<right>"     . "[1;10C")
    ("M-shift-<left>"      . "[1;10D")

    ("C-<return>"    . "")
    ("C-<delete>"    . "")
    ("C-<up>"        . "\M-[1;5A") 	; broken in xterm w. osx
    ("C-<down>"      . "\M-[1;5B")
    ("C-<right>"     . "\M-[1;5C")
    ("C-<left>"      . "\M-[1;5D"))
  "An assoc list of pretty key strings
and their terminal equivalents.")

(defun key (desc)
  (or (and window-system (read-kbd-macro desc))
      (or (cdr (assoc desc real-keyboard-keys))
          (read-kbd-macro desc))))

(global-set-key (key "M-<left>") 'windmove-left)          ; move to left windnow
(global-set-key (key "M-<right>") 'windmove-right)        ; move to right window
(global-set-key (key "M-<up>") 'windmove-up)              ; move to upper window
(global-set-key (key "M-<down>") 'windmove-down)          ; move to lower window


(global-set-key "4" 'windmove-left)          ; move to left windnow [alt keybinding]
(global-set-key "6" 'windmove-right)        ; move to right window [alt keybinding]
(global-set-key "8" 'windmove-up)              ; move to upper window [alt keybinding]
(global-set-key "2" 'windmove-down)          ; move to lower window [alt keybinding]

(global-set-key (kbd "M-<left>") 'windmove-left)          ; move to left windnow
(global-set-key (kbd "M-<right>") 'windmove-right)        ; move to right window
(global-set-key (kbd "M-<up>") 'windmove-up)              ; move to upper window
(global-set-key (kbd "M-<down>") 'windmove-down)          ; move to lower window



(global-set-key (key "M-shift-<left>") 'previous-buffer)          ; move to left windnow
(global-set-key (key "M-shift-<right>") 'next-buffer)        ; move to right window
;; (global-set-key (key "M-shift-<up>") 'windmove-up)              ; move to upper window
;; (global-set-key (key "M-shift-<down>") 'windmove-down)          ; move to lowner window

;; Keybinding for "recompile" 
;; If a previous compile exists for the buffer, run it. If not, run M-x compile
(global-set-key [(control c) (c)] 'compile-again)
(setq compilation-last-buffer nil)
(defun compile-again (pfx)
 (interactive "p")
 (if (and (eq pfx 1)
	    compilation-last-buffer)
     (progn
       (set-buffer compilation-last-buffer)
       (revert-buffer t t))
   (call-interactively 'compile)))

;; Custom C-mode 
(defun my-c-mode-hook () 
  (linum-mode 1)
  (which-function-mode 1)
  (flymake-mode 1))
(add-hook 'c-mode-hook 'my-c-mode-hook) 
(setq c-eldoc-includes "`pkg-config gtk+-2.0 --cflags` -I./ -I../ ")
(require 'c-eldoc)
(load "c-eldoc")
(add-hook 'c-mode-hook 'c-turn-on-eldoc-mode)

;; Indentation changes for C (http://www.emacswiki.org/emacs/SmartTabs#toc2)
(setq c-default-style "linux")
(setq-default tab-width 4) ; or any other preferred value
(setq cua-auto-tabify-rectangles nil)
(defadvice align (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))
(defadvice align-regexp (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))
(defadvice indent-relative (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))
(defadvice indent-according-to-mode (around smart-tabs activate)
  (let ((indent-tabs-mode indent-tabs-mode))
    (if (memq indent-line-function
	      '(indent-relative
		indent-relative-maybe))
	(setq indent-tabs-mode nil))
    ad-do-it))
(defmacro smart-tabs-advice (function offset)
  `(progn
     (defvaralias ',offset 'tab-width)
     (defadvice ,function (around smart-tabs activate)
       (cond
	(indent-tabs-mode
	 (save-excursion
	   (beginning-of-line)
	   (while (looking-at "\t*\\( +\\)\t+")
	     (replace-match "" nil nil nil 1)))
	 (setq tab-width tab-width)
	 (let ((tab-width fill-column)
	       (,offset fill-column)
	       (wstart (window-start)))
	   (unwind-protect
	       (progn ad-do-it)
	     (set-window-start (selected-window) wstart))))
	(t
	 ad-do-it)))))
(smart-tabs-advice c-indent-line c-basic-offset)
(smart-tabs-advice c-indent-region c-basic-offset)

;; Webmode 
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

;; Associated customizations -- see http://web-mode.org/
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2))
(add-hook 'web-mode-hook  'web-mode-hook)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-indent-style 2)
(setq web-mode-comment-style 2)
(set-face-attribute 'web-mode-css-rule-face nil :foreground "Pink3")
(define-key web-mode-map (kbd "C-n") 'web-mode-tag-match)
(add-to-list 'web-mode-snippets '("mydiv" "<div>" "</div>"))
(setq web-mode-disable-auto-pairing t)
(setq web-mode-disable-css-colorization t)
(setq web-mode-enable-block-faces t)
(setq web-mode-enable-heredoc-fontification t)


;; And set some global  options
(require 'flymake)
(require 'guess-offset)
(setq column-number-mode t)
(require 'install-elisp)
(require 'revive)
(require 'windows)
(require 'flymake-cursor)