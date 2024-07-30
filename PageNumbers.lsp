;;--------------=={ SheetNumber.lsp - Sheet number indexer }==----------;;
;;                                                                      ;;
;;  This program allows the user to update the sheet number in          ;;
;;  projects where use of %s is not allowed, this is done by getting    ;;
;;  the number of sheets from the wdp file then checking the current    ;;
;;  page title compared with the wdp file position then updating the    ;;
;;  standard block used for the title block that is placed at 0,0,0     ;;
;;                                                                      ;;
;;----------------------------------------------------------------------;;
;;  Author:  Matthew Ayestaran										                    	;;
;;----------------------------------------------------------------------;;
;;  Version 1.0    -    2024-07-21                                      ;;
;;                                                                      ;;
;;  - First release.                                                    ;;
;;----------------------------------------------------------------------;;

(defun c:PageNumbers (/ aline file dwg current Control BOMpage BOMCurrent ConnectionsPage ConnectionsCurrent LayoutPage LayoutCurrent InterconnectPage InterconnectCurrent)
  ;; Initialize counters
  (setq Control 0
        BOMpage 0
        ConnectionsPage 0
        LayoutPage 0
        InterconnectPage 0)
  
  ;; Get the current drawing name
  (setq dwg (getvar "dwgname"))
  
  ;; Open the active project file
  (setq file (open (ace_getactiveproject) "r"))
  
  ;; Loop through each line in the file
  (while (setq aline (read-line file))
    ;; Check if it is a drawing title and update counters accordingly
    (cond
      ((wcmatch aline "02*")
       (cond
         ((wcmatch aline "*CONTROL*")
          (setq Control (+ 1 Control))
          (princ (strcat "Checking: " aline "\n"))
          (if (wcmatch aline dwg)
            (setq current Control)
            (princ (strcat "Current page: " aline "\n"))))
         
         ((wcmatch aline "*BOM*")
          (setq BOMpage (+ 1 BOMpage))
          (princ (strcat "Checking: " aline "\n"))
          (if (wcmatch aline dwg)
            (setq BOMCurrent BOMpage)
            (princ (strcat "Current page: " aline "\n"))))
         
         ((wcmatch aline "*LAYOUT*")
          (setq LayoutPage (+ 1 LayoutPage))
          (princ (strcat "Checking: " aline "\n"))
          (if (wcmatch aline dwg)
            (setq LayoutCurrent LayoutPage)
            (princ (strcat "Current page: " aline "\n"))))
         
         ((wcmatch aline "*CONNECTION*")
          (setq ConnectionsPage (+ 1 ConnectionsPage))
          (princ (strcat "Checking: " aline "\n"))
          (if (wcmatch aline dwg)
            (setq ConnectionsCurrent ConnectionsPage)
            (princ (strcat "Current page: " aline "\n"))))
         
         ((wcmatch aline "*INTERCONNECT*")
          (setq InterconnectPage (+ 1 InterconnectPage))
          (princ (strcat "Checking: " aline "\n"))
          (if (wcmatch aline dwg)
            (setq InterconnectCurrent InterconnectPage)
            (princ (strcat "Current page: " aline "\n"))))))))
  
  ;; Close the file
  (close file)
  
  ;; Update the sheet numbers in the title block
  (when (> current 0)
    (setpropertyvalue (ssname (ssget "_x" '((0 . "INSERT") (10 0.0000 0.0000 0.0000))) 0) "SHEET"
                      (strcat "SHEET " (rtos current 2 0) " OF " (rtos Control 2 0)))
    (princ "No Change"))
  
  (when (> BOMCurrent 0)
    (setpropertyvalue (ssname (ssget "_x" '((0 . "INSERT") (10 0.0000 0.0000 0.0000))) 0) "SHEET"
                      (strcat "BOM SHEET " (rtos BOMCurrent 2 0) " OF " (rtos BOMpage 2 0)))
    (princ "No Change"))
  
  (when (> ConnectionsCurrent 0)
    (setpropertyvalue (ssname (ssget "_x" '((0 . "INSERT") (10 0.0000 0.0000 0.0000))) 0) "SHEET"
                      (strcat "CONNECTIONS SHEET " (rtos ConnectionsCurrent 2 0) " OF " (rtos ConnectionsPage 2 0)))
    (princ "No Change"))
  
  (when (> LayoutCurrent 0)
    (setpropertyvalue (ssname (ssget "_x" '((0 . "INSERT") (10 0.0000 0.0000 0.0000))) 0) "SHEET"
                      (strcat "PANEL LAYOUT SHEET " (rtos LayoutCurrent 2 0) " OF " (rtos LayoutPage 2 0)))
    (princ "No Change"))
  
  (when (> InterconnectCurrent 0)
    (setpropertyvalue (ssname (ssget "_x" '((0 . "INSERT") (10 0.0000 0.0000 0.0000))) 0) "SHEET"
                      (strcat "INTERCONNECT SHEET " (rtos InterconnectCurrent 2 0) " OF " (rtos InterconnectPage 2 0)))
    (princ "No Change"))
  
  (princ))

;; End of code
