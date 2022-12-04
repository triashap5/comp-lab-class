proc take_picture {args} {
  global take_picture

  # when called with no parameter, render the image
  if {$args == {}} {
    set f [format $take_picture(format) $take_picture(frame)]
    # take 1 out of every modulo images
    if { [expr $take_picture(frame) % $take_picture(modulo)] == 0 } {
      render $take_picture(method) $f
      # call any unix command, if specified
      if { $take_picture(exec) != {} } {
        set f [format $take_picture(exec) $f $f $f $f $f $f $f $f $f $f]
        eval "exec $f"
      }
    }
    # increase the count by one
    incr take_picture(frame)
    return
  }
  lassign $args arg1 arg2
  # reset the options to their initial stat
  # (remember to delete the files yourself
  if {$arg1 == "reset"} {
    set take_picture(frame)  0
    set take_picture(format) "./animate.%06d.rgb"
    set take_picture(method) snapshot
    set take_picture(modulo) 1
    set take_picture(exec)    {}
    return
  }
  # set one of the parameters
  if [info exists take_picture($arg1)] {
    if { [llength $args] == 1} {
      return "$arg1 is $take_picture($arg1)"
    }
    set take_picture($arg1) $arg2
    return
  }
  # otherwise, there was an error
  error {take_picture: [ | reset | frame | format  | \
method  | modulo ]}
}
# to complete the initialization, this must be the first function
# called.  Do so automatically.
take_picture reset
take_picture format "/home/whitead/tmp/animate.%06d.dat.tga"
#take_picture method TachyonInternal
#take_picture exec {/usr/lib/vmd/tachyon_LINUXAMD64 -aasamples 4 %s -format TARGA -o %s.tga res 1280 720}




display resize 1920 1080
axes location off
display cuedensity 0.1500000
display height 11.000000
display distance -10.0
display nearclip set 1.0
display farclip set 21.0
#color Display Background white
#display shadows on
#display ambientocclusion on
#display dof on
#display dof_fnumber 68.0




pbc set {15.66 15.66 15.66} -all


mol addrep 0
mol addrep 0
mol addrep 0


mol modstyle 0 0 DynamicBonds 1.300000 0.100000 20.000000
mol modselect 0 0 not name V
mol modmaterial 0 0 Diffuse
mol smoothrep 0 0 2
mol showperiodic 0 0 xyzXYZ
mol numperiodic 0 0 1


mol modstyle 1 0 VDW 0.300000 20.000000
mol modmaterial 1 0 Diffuse
mol modselect 1 0 not name V
mol smoothrep 0 1 2
mol showperiodic 0 1 xyzXYZ
mol numperiodic 0 1 1


mol modstyle 2 0 VDW 0.300000 12.000000
mol modmaterial 2 0 Diffuse
mol modselect 2 0 name V

mol modstyle 3 0 VDW 0.400000 20.000000
mol modmaterial 3 0 Diffuse
mol modselect 3 0 name OH
mol smoothrep 0 3 2
mol modcolor 3 0 ColorID 12



set nf [molinfo top get numframes]

animate goto 0
animate speed 1

#  open hydronium index file
set fp [open "hindices.txt"]

 
for {set i 0} {$i < $nf} {incr i} {

    #update visual for hydronium
    gets $fp line
    if [eof $fp] break

    mol modselect 3 0 index [expr $line * 1]
	     
    #recenter molecules 
    pbc wrap -center com -centersel "name V"
#    pbc unwrap -now
    #remove all non-V views
    mol showrep 0 0 0
    mol showrep 0 1 0
    mol showrep 0 2 1
    mol showrep 0 3 0
    
    # recenter view on com of vs
    display resetview

    #make sure the zoom isn't too close
    set sm [molinfo top get scale_matrix]
    set zoom [lindex [lindex [lindex $sm 0] 0] 0]
    if {$zoom > 0.40 } {
	scale by [expr 0.40 / $zoom ]
    }
    
    
    #    display resize 1920 1080
    display resize 1280 760
#    display resize 640 380

    
    #turn views back on and V view off
    mol showrep 0 0 1
    mol showrep 0 1 1
    mol showrep 0 2 0
    mol showrep 0 3 1

    rotate y to [expr fmod($i / 20., 360)  ]
    rotate z to [expr fmod($i / 40., 360) ]
  
    
    # and take the picture if in stride
    if {$i % 1 == 0} {
	take_picture
    }

    animate goto $i
}

close $fp
