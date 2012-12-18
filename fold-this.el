;;; fold-this.el --- Just fold this region please

;; Copyright (C) 2012 Magnar Sveen <magnars@gmail.com>

;; Author: Magnar Sveen <magnars@gmail.com>
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(defvar fold-this-keymap (make-sparse-keymap))
(define-key fold-this-keymap (kbd "<return>") 'fold-this-unfold-at-point)
(define-key fold-this-keymap (kbd "C-g") 'fold-this-unfold-at-point)

;;;###autoload
(defun fold-this (beg end)
  (interactive "r")
  (let ((o (make-overlay beg end nil t nil)))
    (overlay-put o 'type 'fold-this)
    (overlay-put o 'invisible t)
    (overlay-put o 'keymap fold-this-keymap)
    (overlay-put o 'modification-hooks '(fold-this--unfold-overlay))
    (overlay-put o 'display ".")
    (overlay-put o 'before-string ".")
    (overlay-put o 'evaporate t))
  (deactivate-mark))

;;;###autoload
(defun fold-this-all (beg end)
  (interactive "r")
  (let ((string (buffer-substring (region-beginning)
                                  (region-end))))
    (save-excursion
      (goto-char (point-min))
      (while (search-forward string (point-max) t)
        (fold-this (match-beginning 0) (match-end 0)))))
  (deactivate-mark))

;;;###autoload
(defun fold-this-unfold-all ()
  (interactive)
  (mapc 'fold-this--delete-my-overlay
        (overlays-in (point-min) (point-max))))

;;;###autoload
(defun fold-this-unfold-at-point ()
  (interactive)
  (mapc 'fold-this--delete-my-overlay
        (overlays-at (point))))

(defun fold-this--delete-my-overlay (it)
  (when (eq (overlay-get it 'type) 'fold-this)
    (delete-overlay it)))

(defun fold-this--unfold-overlay (overlay after? beg end &optional length)
  (delete-overlay overlay))

(provide 'fold-this)
;;; fold-this.el ends here
