A Project to orgonise the page numbers in a project that is split into multiple DWG files instead of using the paperspace.

The system of naming is dictated by the project layout i am currently using but can be addapted to fit whatever system is needed.

The code works by gabbing the file infomation from the WDP file in an autocad electrical drawing (presuming the drawing starts with 2 numbers.

Next it indexes through the project to find all the instances that match the keywords used.

The matches are as follows:

all files require 2 numbers before the description.

  -The word CONTROL 
  -The word LAYOUT
  -The word BOM
  -The word Connection
  -the word Interconnect
