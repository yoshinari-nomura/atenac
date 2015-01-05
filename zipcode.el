;;; zipcode --- Lookup and insert Japanese address from zip code

;; Author:  Yoshinari Nomura <nom@quickhack.net>
;;
;; Created: 2015-01-05

;;; Commentary:

;;; Code:

(require 'json)

(defconst zipcode-regexp "\\([0-9]\\{3\\}\\)-?\\([0-9]\\{4\\}\\)")
(defconst zipcode-api-url "http://zipcloud.ibsnet.co.jp/api/search?zipcode=")

(defun zipcode-before-point ()
  "Get zip number before point at the same line."
  (save-excursion
    (if (re-search-backward zipcode-regexp (point-at-bol) t)
        (concat (buffer-substring (match-beginning 1) (match-end 1))
                (buffer-substring (match-beginning 2) (match-end 2))))))

(defun zipcode-lookup-address (zipcode)
  "Lookup address string from ZIPCODE using API."
  (let* ((url (concat zipcode-api-url (url-encode-url zipcode)))
         (addresses
          (with-temp-buffer
            (unless (zerop (call-process "curl" nil t nil "-s" url))
              (error "Error: Zipcode API Failed"))
            (assoc-default 'results (json-read-from-string (buffer-string))))))
    (if (arrayp addresses)
        (let ((address (aref addresses 0)))
          (concat
           (assoc-default 'address1 address)
           (assoc-default 'address2 address)
           (assoc-default 'address3 address))))))

(defun zipcode-insert-address (zipcode)
  "Insert address string from ZIPCODE using API."
  (interactive (list (read-string "Zipcode: " (zipcode-before-point))))
  (let ((address (zipcode-lookup-address zipcode)))
    (if address
        (insert address)
      (message "No matched address for %s" zipcode))))

(provide 'zipcode)

;;;  zipcode.el ends here
