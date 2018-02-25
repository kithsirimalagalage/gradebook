#!/bin/sh
#The next line executes wish - wherever it is \
exec wish "$0" "$@"

package require sqlite3

wm title . "Grade Book"

wm minsize . 300 220

set table "course_list"
set current_cat 1
set data_base gradebook.sqlite


global regno
global index
global name
global phone
global email
global student #! list of student index numbers
global code    #! list of course codes
global N       #! number of course read in
global TGPA

global classname
set code " "
set student " "



# main window
frame .f -background "#dcfcb6"   ;# frame for student info
frame .fb                        ;# frame for buttons
frame .ft                        ;# frame for title


# Buttons for the main window
button .fb.b1 -text "Students"  -command  "student_list_m"
button .fb.b2 -text "Courses" 
button .fb.b3 -text "Results"   -command  "show_result"
button .fb.b4 -text ""  
button .fb.b5 -text "Quit"      -command  "quit"

foreach  y {1 2 3 4 5} { 
	grid .fb.b$y  -in .fb -row 1 -column $y 
}

# label for the class name
#label .f.l1 -textvariable classname -padx 10  
#grid  .f.l1  -in .f -row 1 -column 1

# labels for the course modules
#foreach  y {1 2 3 4 5 6 7 8 9 10 11 12} { 
#        label .ft.lc$y -text " xxx" -padx 10  
#	grid  .ft.lc$y  -in .ft -row $y -column 1
#}

grid .f  -in . -row 2 -column 1
grid .fb -in . -row 1 -column 1 
grid .ft -in . -row 3 -column 1 

#...........................................................................
# Read the student-list and fill the arrays
proc read_names {} {

global regno
global student
global index
global name
global phone
global email

global data_base

sqlite3 db $data_base
  set n 0
  db eval "SELECT indexno,name FROM student_list" x {
    set std $x(indexno)
    lappend student $std
    set index($std) $x(indexno)
    set name($std) $x(name)
#set phone($std)  $x(phone)
#set email($std)  $x(email)
#    puts " $x(indexno) $x(name)"
    incr n
  }
  db close

}

#...........................................................................
proc quit {} {
exit
}

#...........................................................................
# Display the student list in main window
proc student_list_m {} {

global regno
global student
global index
global name
global phone
global email

# frames for the window
frame .ft.fst -background "#dcfcb6"   ;# frame for student info
frame .ft.fbut                        ;# frame for buttons

# Content for the window
set var {index name phone email}

set lw {10 30 10 30}
foreach  y {1 2 3 4} { 
        frame .ft.fst.ft$y  -borderwidth 1 -relief ridge  -background "#dcfcb6"
        grid  .ft.fst.ft$y  -in .ft.fst -row 1 -column $y -sticky e
	label .ft.fst.lt$y -text [lindex $var [expr $y-1]] -width [lindex $lw [expr $y-1]] -padx 10 -background "#dcfcb6"
	grid  .ft.fst.lt$y  -in .ft.fst.ft$y  -row 1 -column 1	-sticky e
}

   set n 2
   set y 1   	
   foreach  x $student {
        frame .ft.fst.f$x$y -borderwidth 1 -background "#dcfc06";#-relief ridge  ;
        grid  .ft.fst.f$x$y  -in .ft.fst -row $n -column $y -sticky e
	button .ft.fst.l$x$y -textvariable [lindex $var [expr $y-1]]($x) -width [lindex $lw [expr $y-1]] -background "#dcfcb6" -command "student $x"
	grid  .ft.fst.l$x$y  -in .ft.fst.f$x$y  -row 1 -column 1	-sticky e
        incr n
   }


foreach  y {2 3 4} { 
   set n 2   	
   foreach  x $student {
        frame .ft.fst.f$x$y -borderwidth 1 -background "#dcfcb6" -relief ridge  ;
        grid  .ft.fst.f$x$y  -in .ft.fst -row $n -column $y -sticky e
	label .ft.fst.l$x$y -textvariable [lindex $var [expr $y-1]]($x) -width [lindex $lw [expr $y-1]] -padx 10 -pady 5 -background "#dcfcb6" 
	grid  .ft.fst.l$x$y  -in .ft.fst.f$x$y  -row 1 -column 1	-sticky e
        incr n
   }
}

# main window
grid .ft.fst   -in .ft  -row 2 -column 1 
grid .ft.fbut  -in .ft  -row 3 -column 1 

}



#...................................................................

# Display the student list (data read from file student-list)
proc student_list {} {

global regno
global student
global index
global name
global phone
global email

toplevel .st
wm title .st "Student List"
#wm minsize .stlist 250 250

# frames for the window
frame .st.fst -background "#dcfcb6"   ;# frame for student info
frame .st.fbut                        ;# frame for buttons

# Buttons for the window
#button .st.fbut.b1 -text "Download" -command "download"
#button .st.fbut.b2 -text "Read" -command  "read_current_prices"
#button .st.fbut.b3 -text "Write" -command "write"
#button .st.fbut.b4 -text "Plot" -command  "plot"
#button .st.fbut.b5 -text "Quit" -command "destroy .st"
#foreach  y {1 2 3 4 5} { 
#	grid .st.fbut.b$y  -in .st.fbut -row 1 -column $y 
#}


# Content for the window
set var {index name phone email}

set lw {10 30 10 30}
foreach  y {1 2 3 4} { 
        frame .st.fst.ft$y  -borderwidth 1 -relief ridge  -background "#dcfcb6"
        grid  .st.fst.ft$y  -in .st.fst -row 1 -column $y -sticky e
	label .st.fst.lt$y -text [lindex $var [expr $y-1]] -width [lindex $lw [expr $y-1]] -padx 10 -background "#dcfcb6"
	grid  .st.fst.lt$y  -in .st.fst.ft$y  -row 1 -column 1	-sticky e
}

   set n 2
   set y 1   	
   foreach  x $student {
        frame .st.fst.f$x$y -borderwidth 1 -background "#dcfc06";#-relief ridge  ;
        grid  .st.fst.f$x$y  -in .st.fst -row $n -column $y -sticky e
	button .st.fst.l$x$y -textvariable [lindex $var [expr $y-1]]($x) -width [lindex $lw [expr $y-1]] -background "#dcfcb6" -command "student $x"
	grid  .st.fst.l$x$y  -in .st.fst.f$x$y  -row 1 -column 1	-sticky e
        incr n
   }


foreach  y {2 3 4} { 
   set n 2   	
   foreach  x $student {
        frame .st.fst.f$x$y -borderwidth 1 -background "#dcfcb6" -relief ridge  ;
        grid  .st.fst.f$x$y  -in .st.fst -row $n -column $y -sticky e
	label .st.fst.l$x$y -textvariable [lindex $var [expr $y-1]]($x) -width [lindex $lw [expr $y-1]] -padx 10 -pady 5 -background "#dcfcb6" 
	grid  .st.fst.l$x$y  -in .st.fst.f$x$y  -row 1 -column 1	-sticky e
        incr n
   }
}

# main window
grid .st.fst   -in .st  -row 2 -column 1 
grid .st.fbut  -in .st  -row 3 -column 1 

}


# ....................................................................................
# read marks from all courses from the database
proc read_grades {} {

  global coursefile marks code student N
# N is the number of courses read so far

global data_base

sqlite3 db $data_base
  set n 0
  db eval "SELECT courseno,results_released FROM courses" x {
    if { $x(results_released) == "1" } {
    set ccode $x(courseno)
    lappend code $ccode
    db eval "SELECT indexno,$ccode FROM student_list" y {
      set std $y(indexno)
      set marks($ccode$std) $y($ccode)

    }

  }
    incr n
  }
  db close

}

# ....................................................................................

proc show_marks {} {

  global code student marks 
  
  toplevel   .mrk
  wm title   .mrk "Student List"
#  wm minsize .mrk 250 250
  
  set bkgcolour "#dcfcb6"

    
# frames for the window
  frame .mrk.fc  -background $bkgcolour  ;# frame for content
  frame .mrk.fbut                        ;# frame for buttons
  frame .mrk.ftit                        ;# frame for title

# Buttons for the window
  button .mrk.fbut.b1 -text "Quit" -command "destroy .mrk"
  grid   .mrk.fbut.b1  -in .mrk.fbut -row 1 -column 1


# Labels for the window
  label .mrk.fc.l1 -text "Index"  -padx 10 -width 5 -background  $bkgcolour
  grid  .mrk.fc.l1 -in .mrk.fc -row 1 -column 1 -sticky e

# Content for the window
# First, course code labels
  set nx 2
  foreach  x $code  {
    label .mrk.fc.l$x -text $x -padx 10  -width 5 -background $bkgcolour
    grid  .mrk.fc.l$x -in .mrk.fc -row 1 -column $nx -sticky e
    incr nx    
  }
# Next, index no., labels and marks for each student for each course  
  set ny 2  
  foreach y $student {
    label .mrk.fc.l$y -textvariable index($y) -padx 10 -width 5 -background $bkgcolour
    grid  .mrk.fc.l$y -in .mrk.fc -row $ny -column 1 -sticky e
    set nx 2
    foreach  x $code  {
	label .mrk.fc.l$x$y -textvariable marks($x$y) -padx 10  -width 5 -background $bkgcolour
	grid  .mrk.fc.l$x$y  -in .mrk.fc -row $ny -column $nx	-sticky e
	incr nx
    }
    incr ny
  }

# pack the window
grid .mrk.ftit  -in .mrk  -row 1 -column 1
grid .mrk.fc    -in .mrk  -row 2 -column 1 
grid .mrk.fbut  -in .mrk  -row 3 -column 1 

}

# ....................................................................................
# display details of each student
proc student {indx} {
  global code name student marks 
  
  toplevel   .std
  wm title   .std $indx
  wm minsize .std 500 500
  
  set bkgcolour "#dcfcb6"

    label .std.l1 -text $indx -padx 10 -width 8  -borderwidth 1 
    grid  .std.l1 -in .std -row 1 -column 1
    label .std.l2 -text $name($indx) -padx 10 -width 20  -borderwidth 1 
    grid  .std.l2 -in .std -row 2 -column 1
 

}
# ....................................................................................
proc convgrade {mark} {
  set grade "ab" 
  if       { $mark ==""}                   { set gpa "ab"
  } elseif { ($mark < 20) }                { set grade "F"  
  } elseif { ($mark > 19) & ($mark < 30) } { set grade "D-" 
  } elseif { ($mark > 29) & ($mark < 40) } { set grade "D"  
  } elseif { ($mark > 39) & ($mark < 45) } { set grade "D+"    
  } elseif { ($mark > 44) & ($mark < 50) } { set grade "C-"    
  } elseif { ($mark > 49) & ($mark < 55) } { set grade "C"     
  } elseif { ($mark > 54) & ($mark < 60) } { set grade "C+"    
  } elseif { ($mark > 59) & ($mark < 65) } { set grade "B-"    
  } elseif { ($mark > 64) & ($mark < 70) } { set grade "B"     
  } elseif { ($mark > 69) & ($mark < 75) } { set grade "B+"      
  } elseif { ($mark > 74) & ($mark < 80) } { set grade "A-"    
  } elseif { ($mark > 79) & ($mark < 90) } { set grade "A"    
  } elseif { ($mark > 89) & ($mark < 100)} { set grade "A+" 
  } else  { set grade "ab" } 
  
  return $grade
}

# ....................................................................................
proc convgpa {mark} {
  set gpa "ab" 

  
  if       { $mark ==""}                   { set gpa "ab"
  } elseif { ($mark < 20) }                { set gpa 0.0  
  } elseif { ($mark > 19) & ($mark < 30) } { set gpa 0.75 
  } elseif { ($mark > 29) & ($mark < 40) } { set gpa 1.00  
  } elseif { ($mark > 39) & ($mark < 45) } { set gpa 1.25    
  } elseif { ($mark > 44) & ($mark < 50) } { set gpa 1.75   
  } elseif { ($mark > 49) & ($mark < 55) } { set gpa 2.00     
  } elseif { ($mark > 54) & ($mark < 60) } { set gpa 2.25  
  } elseif { ($mark > 59) & ($mark < 65) } { set gpa 2.75
  } elseif { ($mark > 64) & ($mark < 70) } { set gpa 3.00
  } elseif { ($mark > 69) & ($mark < 75) } { set gpa 3.25
  } elseif { ($mark > 74) & ($mark < 80) } { set gpa 3.75
  } elseif { ($mark > 79) & ($mark < 100) } { set gpa 4.00}


  return $gpa
}
# ....................................................................................
proc calc_result {} {
  global code student marks result grade gpa TGPA
  foreach  x $code  {
     foreach y $student {
        set result($x$y) $marks($x$y)          
        set grade($x$y) [convgrade $marks($x$y)]  
        set gpa($x$y)   [convgpa   $marks($x$y)]              
     }
  }

#calculate GPA
  foreach y $student {
    set TGPA($y) 0
    set n 0
    foreach x $code {
      if { $gpa($x$y) != "ab" } {
        set TGPA($y) [expr $TGPA($y)+$gpa($x$y)]
        incr n 
      }
    }
  if { $n > 0 } {set TGPA($y) [format {%0.2f} [expr $TGPA($y)/$n]]}

  }

}

# ....................................................................................
proc gpa {} {
  global code student marks result grade gpa
  foreach  x $code  {
     foreach y $student {
        set result($x$y) $gpa($x$y)          
    }
  }
}
# ....................................................................................
proc grd {} {
  global code student marks result grade gpa
  foreach  x $code  {
     foreach y $student {
        set result($x$y) $grade($x$y)          
    }
  }
}
# ....................................................................................
proc mrk {} {
  global code student marks result grade gpa
  foreach  x $code  {
     foreach y $student {
        set result($x$y) $marks($x$y)          
    }
  }
}
# ....................................................................................
proc show_result {} {

  global code student result TGPA
  
  toplevel   .grd
  wm title   .grd "Results"
#  wm minsize .grd 250 250
  
  set bkgcolour "#dcfcb6"
  

# frames for the window
  frame .grd.fc  -background $bkgcolour  ;# frame for content
  frame .grd.fbut                        ;# frame for buttons
  frame .grd.ftit                        ;# frame for title

# Buttons for the window
  button .grd.fbut.b1 -text "Quit" -command "destroy .grd"
  grid   .grd.fbut.b1  -in .grd.fbut -row 1 -column 4
  button .grd.fbut.b2 -text "GPA" -command "gpa"
  grid   .grd.fbut.b2  -in .grd.fbut -row 1 -column 1
  button .grd.fbut.b3 -text "Grade" -command "grd"
  grid   .grd.fbut.b3  -in .grd.fbut -row 1 -column 2  
  button .grd.fbut.b4 -text "Marks" -command "mrk"
  grid   .grd.fbut.b4  -in .grd.fbut -row 1 -column 3  

  
# Labels for the window
  label .grd.fc.l1 -text "Index"  -padx 10 -width 8 -background  $bkgcolour -borderwidth 1 -relief ridge
  grid  .grd.fc.l1 -in .grd.fc -row 1 -column 1 -sticky e

# Content for the window
# First, course code labels
  set nx 2
  foreach  x $code  {
    label .grd.fc.l$x -text $x -padx 10  -width 5 -background $bkgcolour -borderwidth 1 -relief ridge
    grid  .grd.fc.l$x -in .grd.fc -row 1 -column $nx -sticky e
    incr nx    
  }
  
# Next, index no., labels and marks for each student for each course  
  set ny 2  
  foreach y $student {
    label .grd.fc.l$y -textvariable index($y) -padx 10 -width 8 -background $bkgcolour  -borderwidth 1 -relief ridge 
    grid  .grd.fc.l$y -in .grd.fc -row $ny -column 1 -sticky e
    set nx 2
      
    foreach  x $code  {
	label .grd.fc.l$x$y -textvariable result($x$y) -padx 10  -width 5 -background $bkgcolour -borderwidth 1 -relief ridge 	
	grid  .grd.fc.l$x$y  -in .grd.fc -row $ny -column $nx	-sticky e
	incr nx
    }
	label .grd.fc.lGPA$y -textvariable TGPA($y) -padx 10  -width 5 -background $bkgcolour -borderwidth 1 -relief ridge 	
        if { $TGPA($y) < 2.5 } { .grd.fc.lGPA$y configure -background red }
	grid  .grd.fc.lGPA$y  -in .grd.fc -row $ny -column $nx	-sticky e


    incr ny
  }

# pack the window
grid .grd.ftit  -in .grd  -row 1 -column 1
grid .grd.fc    -in .grd  -row 2 -column 1 
grid .grd.fbut  -in .grd  -row 3 -column 1 

}

#...........................................................................


read_names
#read_courses
read_grades
calc_result
