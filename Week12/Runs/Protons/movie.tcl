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
    set take_picture(format) "./animate.%04d.rgb"
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
take_picture format animate.%04d.dat
take_picture method Tachyon
take_picture exec {~/local/lib/vmd/tachyon_LINUXAMD64 -aasamples 12 %s -format TARGA -o %s.tga res 600 500}



display resize 600 500
display cuedensity 0.0

mol new { proton_aimd_1ns_every0.5fs-pos-1.xyz} type {xyz}
mol modselect 0 top protein
mol modcolor 0 top Name
mol modstyle 0 top Licorice 0.300000 10.000000 10.000000
mol modmaterial 0 top AOEdgy

color Name C gray
scale by 1.2


axes location off
color Display Background white
display shadows on
display ambientocclusion on

#mol addrep top
#mol modselect 1 top protein
#mol modcolor 1 top resname transparent
#mol modstyle 1 top surf

#Now that everything is loaded, here's the script to make the movie
# take control of the updating
display update off
for {set i 0} {$i < 180} {incr i 1} {	
	# force the update
	display update
	# and take the picture
	take_picture
	#rotate
	rotate y by 1
}

material change opacity AOChalky 0.000000
mol addrep top
mol modmaterial 1 top AOChalky
mol modcolor 1 top colorID 22 
mol modstyle 1 top Surf 1.400000 0.000000

for {set i 0.0} {$i < 1.0} {set i [expr $i + 0.05]} {
		material change opacity AOChalky [expr $i]
		# force the update
		display update
		# and take the picture
		take_picture
}

#make sure its exactly 1, otherwise rendering is very expensive
material change opacity AOChalky 1.0

for {set i 0} {$i < 180} {incr i 1} {	
	# force the update
	display update
	# and take the picture
	take_picture
	#rotate
	rotate y by 1
}

