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


;Code to place the data in the desired block
(defun c:PageNumbers (/ aline file Control current dwg BOMpage BOMCurrent ConnectionsPage ConnectionsCurrent LayoutPage LayoutCurrent InterconnectPage InterconnectCurrent)
(setq Control 0)
(setq BOMpage 0)
(setq ConnectionsPage 0)
(setq LayoutPage 0)
(setq InterconnectPage 0)  
  
(setq dwg (getvar "dwgname"))
;(close file)
;code to read the wdp and extract the control pages numbers
(setq file (open (ace_getactiveproject) "r"))
  (while (setq aline (read-line file))
        ;check if it is a dwg title
        (if (wcmatch aline "02*")  
                (if (wcmatch aline "*CONTROL*")
                  ;check for control drawing
                    (progn
                      (setq Control (+ 1 Control))
                      (princ (strcat "Checking: " aline "\n"))
                          (if (wcmatch aline dwg)
                          ;check for current page in count
                            (progn
                                (setq current Control)
                                (princ (strcat "current page: " aline "\n"))
                            );progn
                          );if
                    );progn
                );if
        ); if
    
      (if (wcmatch aline "02*")  
                (if (wcmatch aline "*BOM*")
                  ;check for control drawing
                    (progn
                      (setq BOMpage (+ 1 BOMpage))
                      (princ (strcat "Checking: " aline "\n"))
                          (if (wcmatch aline dwg)
                          ;check for current page in count
                            (progn
                                (setq BOMCurrent BOMpage)
                                (princ (strcat "current page: " aline "\n"))
                            ) ;prog
                          );if
                    );progn
                );if
        ); if
    
      (if (wcmatch aline "02*")  
                (if (wcmatch aline "*LAYOUT*")
                  ;check for control drawing
                    (progn
                      (setq LayoutPage (+ 1 LayoutPage))
                      (princ (strcat "Checking: " aline "\n"))
                          (if (wcmatch aline dwg)
                          ;check for current page in count
                            (progn
                                (setq LayoutCurrent LayoutPage)
                                (princ (strcat "current page: " aline "\n"))
                            ) ;prog
                          );if
                    );progn
                );if
        ); if
        (if (wcmatch aline "02*")  
                (if (wcmatch aline "*CONNECTION*")
                  ;check for control drawing
                    (progn
                      (setq ConnectionsPage (+ 1 ConnectionsPage))
                      (princ (strcat "Checking: " aline "\n"))
                          (if (wcmatch aline dwg)
                          ;check for current page in count
                            (progn
                                (setq ConnectionsCurrent ConnectionsPage)
                                (princ (strcat "current page: " aline "\n"))
                            ) ;prog
                          );if
                    );progn
                );if
        ); if
        (if (wcmatch aline "02*")  
                (if (wcmatch aline "*INTERCONNECT*")
                  ;check for control drawing
                    (progn
                      (setq InterconnectPage (+ 1 InterconnectPage))
                      (princ (strcat "Checking: " aline "\n"))
                          (if (wcmatch aline dwg)
                          ;check for current page in count
                            (progn
                                (setq InterconnectCurrent InterconnectPage)
                                (princ (strcat "current page: " aline "\n"))
                            ) ;prog
                          );if
                    );progn
                );if
        ); if
    ); while
(princ) 

(close file) 
  ;presuming the titleblock is at 0 0 0 then you can update it with the below code to show the correct sheet number should only be called if it is meant to be used
  (if (> current 0)
          (setpropertyvalue (SSNAME(ssget "_x" '((0 . "insert") (10 0.0000 0.0000 0.0000)))0) "SHEET" (strcat "SHEET " (rtos current 2 0) " OF " (rtos Control 2 0)))
          (princ "No Change")
  ) ;if
  (if (> BOMCurrent 0)
          (setpropertyvalue (SSNAME(ssget "_x" '((0 . "insert") (10 0.0000 0.0000 0.0000)))0) "SHEET" (strcat "BOM SHEET " (rtos BOMCurrent 2 0) " OF " (rtos BOMpage 2 0)))
          (princ "No Change")
  ) ;if
  (if (> ConnectionsCurrent 0)
          (setpropertyvalue (SSNAME(ssget "_x" '((0 . "insert") (10 0.0000 0.0000 0.0000)))0) "SHEET" (strcat "CONNECTIONS SHEET " (rtos ConnectionsCurrent 2 0) " OF " (rtos ConnectionsPage 2 0)))
          (princ "No Change")
  ) ;if
  (if (> LayoutCurrent 0)
          (setpropertyvalue (SSNAME(ssget "_x" '((0 . "insert") (10 0.0000 0.0000 0.0000)))0) "SHEET" (strcat " PANEL LAYOUT SHEET " (rtos LayoutCurrent 2 0) " OF " (rtos LayoutPage 2 0)))
          (princ "No Change")
  ) ;if
  (if (> InterconnectCurrent 0)
          (setpropertyvalue (SSNAME(ssget "_x" '((0 . "insert") (10 0.0000 0.0000 0.0000)))0) "SHEET" (strcat "INTERCONNECT SHEET " (rtos InterconnectCurrent 2 0) " OF " (rtos InterconnectPage 2 0)))
          (princ "No Change")
  ) ;if
);end

