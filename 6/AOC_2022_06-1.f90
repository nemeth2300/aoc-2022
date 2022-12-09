! Not my produest code

program main
   implicit none

   integer, parameter :: INPUT_MAX_LENGTH = 4096
   integer, parameter :: MARKER_LENGTH = 4

   integer, parameter :: FILE_PATH_MAX_SIZE = 1024
   integer, parameter :: FILE_UNIT = 10

   character (len=FILE_PATH_MAX_SIZE), parameter :: file_path = "input.txt"

   character (len=INPUT_MAX_LENGTH) :: input
   character (len=MARKER_LENGTH) :: current_input
   integer :: index

   integer :: i, j

   open(unit=FILE_UNIT, file=file_path, status="old")
   read(unit=FILE_UNIT, fmt=*) input
   close(FILE_UNIT)

   main_loop: do index=1, INPUT_MAX_LENGTH
      current_input = input(index:index+MARKER_LENGTH)

      do i=1,MARKER_LENGTH
         do j=1,MARKER_LENGTH
            if (i /=j .AND. current_input(i:i) == current_input(j:j)) then
               cycle main_loop
            end if
         end do
      end do

      exit
   end do main_loop

   print *, index+MARKER_LENGTH-1

end program main

