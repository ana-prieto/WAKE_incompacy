!********************************************************************
!
subroutine  intt (ux,uy,uz,gx,gy,gz,hx,hy,hz,ta1,tb1,tc1)
! 
!********************************************************************

USE param
USE variables
USE decomp_2d

implicit none

integer :: ijk,nxyz
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ux,uy,uz
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: gx,gy,gz
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: hx,hy,hz
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ta1,tb1,tc1
!real, dimension(xsize() :: ux,uy,uz,hx,hy,hz,gx,gy,gz

nxyz=xsize(1)*xsize(2)*xsize(3)

if ((nscheme.eq.1).or.(nscheme.eq.2)) then
if ((nscheme.eq.1.and.itime.eq.1.and.ilit.eq.0).or.&
     (nscheme.eq.2.and.itr.eq.1)) then
   do ijk=1,nxyz
      ux(ijk,1,1)=gdt(itr)*ta1(ijk,1,1)+ux(ijk,1,1)
      uy(ijk,1,1)=gdt(itr)*tb1(ijk,1,1)+uy(ijk,1,1) 
      uz(ijk,1,1)=gdt(itr)*tc1(ijk,1,1)+uz(ijk,1,1)
      gx(ijk,1,1)=ta1(ijk,1,1)
      gy(ijk,1,1)=tb1(ijk,1,1)
      gz(ijk,1,1)=tc1(ijk,1,1)            
   enddo
else
   if (nz.gt.1) then
      do ijk=1,nxyz
         ux(ijk,1,1)=adt(itr)*ta1(ijk,1,1)+bdt(itr)*gx(ijk,1,1)+ux(ijk,1,1)
         uy(ijk,1,1)=adt(itr)*tb1(ijk,1,1)+bdt(itr)*gy(ijk,1,1)+uy(ijk,1,1)   
         uz(ijk,1,1)=adt(itr)*tc1(ijk,1,1)+bdt(itr)*gz(ijk,1,1)+uz(ijk,1,1)
         gx(ijk,1,1)=ta1(ijk,1,1)
         gy(ijk,1,1)=tb1(ijk,1,1)
         gz(ijk,1,1)=tc1(ijk,1,1)            
      enddo
   else
      do ijk=1,nxyz
         ux(ijk,1,1)=adt(itr)*ta1(ijk,1,1)+bdt(itr)*gx(ijk,1,1)+ux(ijk,1,1)
         uy(ijk,1,1)=adt(itr)*tb1(ijk,1,1)+bdt(itr)*gy(ijk,1,1)+uy(ijk,1,1)   
         gx(ijk,1,1)=ta1(ijk,1,1)
         gy(ijk,1,1)=tb1(ijk,1,1)
      enddo
   endif
endif
endif

if (nscheme.eq.3) then 
   if (nz.gt.1) then
      if (adt(itr)==0.) then
         do ijk=1,nxyz
            gx(ijk,1,1)=dt*ta1(ijk,1,1)
            gy(ijk,1,1)=dt*tb1(ijk,1,1)
            gz(ijk,1,1)=dt*tc1(ijk,1,1)
         enddo
      else
         do ijk=1,nxyz
            gx(ijk,1,1)=adt(itr)*gx(ijk,1,1)+dt*ta1(ijk,1,1)
            gy(ijk,1,1)=adt(itr)*gy(ijk,1,1)+dt*tb1(ijk,1,1)
            gz(ijk,1,1)=adt(itr)*gz(ijk,1,1)+dt*tc1(ijk,1,1)
         enddo
      endif
      do ijk=1,nxyz
         ux(ijk,1,1)=ux(ijk,1,1)+bdt(itr)*gx(ijk,1,1)
         uy(ijk,1,1)=uy(ijk,1,1)+bdt(itr)*gy(ijk,1,1)
         uz(ijk,1,1)=uz(ijk,1,1)+bdt(itr)*gz(ijk,1,1)
      enddo
   else
      if (adt(itr)==0.) then
         do ijk=1,nxyz
            gx(ijk,1,1)=dt*ta1(ijk,1,1)
            gy(ijk,1,1)=dt*tb1(ijk,1,1)
         enddo
      else
         do ijk=1,nxyz
            gx(ijk,1,1)=adt(itr)*gx(ijk,1,1)+dt*ta1(ijk,1,1)
            gy(ijk,1,1)=adt(itr)*gy(ijk,1,1)+dt*tb1(ijk,1,1)
         enddo
      endif
      do ijk=1,nxyz
         ux(ijk,1,1)=ux(ijk,1,1)+bdt(itr)*gx(ijk,1,1)
         uy(ijk,1,1)=uy(ijk,1,1)+bdt(itr)*gy(ijk,1,1)
      enddo
   endif
endif

if (nscheme==4) then
   if ((itime.eq.1).and.(ilit.eq.0)) then
      if (nrank==0) print *,'start with Euler',itime
      do ijk=1,nxyz !start with Euler
         ux(ijk,1,1)=dt*ta1(ijk,1,1)+ux(ijk,1,1)
         uy(ijk,1,1)=dt*tb1(ijk,1,1)+uy(ijk,1,1) 
         uz(ijk,1,1)=dt*tc1(ijk,1,1)+uz(ijk,1,1)
         gx(ijk,1,1)=ta1(ijk,1,1)
         gy(ijk,1,1)=tb1(ijk,1,1)
         gz(ijk,1,1)=tc1(ijk,1,1)            
      enddo
   else
      if  ((itime.eq.2).and.(ilit.eq.0)) then
          if (nrank==0) print *,'then with AB2',itime
         do ijk=1,nxyz
            ux(ijk,1,1)=1.5*dt*ta1(ijk,1,1)-0.5*dt*gx(ijk,1,1)+ux(ijk,1,1)
            uy(ijk,1,1)=1.5*dt*tb1(ijk,1,1)-0.5*dt*gy(ijk,1,1)+uy(ijk,1,1)
            uz(ijk,1,1)=1.5*dt*tc1(ijk,1,1)-0.5*dt*gz(ijk,1,1)+uz(ijk,1,1)
            hx(ijk,1,1)=gx(ijk,1,1)
            hy(ijk,1,1)=gy(ijk,1,1)
            hz(ijk,1,1)=gz(ijk,1,1)
            gx(ijk,1,1)=ta1(ijk,1,1)
            gy(ijk,1,1)=tb1(ijk,1,1)
            gz(ijk,1,1)=tc1(ijk,1,1)
         enddo 
      else
         do ijk=1,nxyz
            ux(ijk,1,1)=adt(itr)*ta1(ijk,1,1)+bdt(itr)*gx(ijk,1,1)+&
                 cdt(itr)*hx(ijk,1,1)+ux(ijk,1,1)
            uy(ijk,1,1)=adt(itr)*tb1(ijk,1,1)+bdt(itr)*gy(ijk,1,1)+&
                 cdt(itr)*hy(ijk,1,1)+uy(ijk,1,1)
            uz(ijk,1,1)=adt(itr)*tc1(ijk,1,1)+bdt(itr)*gz(ijk,1,1)+&
                 cdt(itr)*hz(ijk,1,1)+uz(ijk,1,1)
            hx(ijk,1,1)=gx(ijk,1,1)
            hy(ijk,1,1)=gy(ijk,1,1)
            hz(ijk,1,1)=gz(ijk,1,1)
            gx(ijk,1,1)=ta1(ijk,1,1)
            gy(ijk,1,1)=tb1(ijk,1,1)
            gz(ijk,1,1)=tc1(ijk,1,1)
         enddo
      endif
   endif
endif


return
end subroutine intt

!********************************************************************
!
subroutine corgp (ux,gx,uy,uz,px,py,pz)
! 
!********************************************************************

USE decomp_2d
USE variables
USE param
USE var
USE MPI

implicit none

integer :: ijk,nxyz
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ux,uy,uz,px,py,pz
real(mytype),dimension(ysize(1),ysize(2),ysize(3)) :: gx

nxyz=xsize(1)*xsize(2)*xsize(3)

do ijk=1,nxyz
   ux(ijk,1,1)=-px(ijk,1,1)+ux(ijk,1,1)
   uy(ijk,1,1)=-py(ijk,1,1)+uy(ijk,1,1) 
   uz(ijk,1,1)=-pz(ijk,1,1)+uz(ijk,1,1) 
enddo

if (itype==2) then !channel flow
   call transpose_x_to_y(ux,gx)
   call channel(gx)
   call transpose_y_to_x(gx,ux)
endif

return
end subroutine corgp

!*********************************************************
!
subroutine inflow (ux,uy,uz,phi)
!  
!*********************************************************

USE param
USE IBM
USE variables
USE decomp_2d

implicit none

integer  :: k,j
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ux,uy,uz,phi
real(mytype) :: r1,r2,r3,y,um

call ecoule(ux,uy,uz)

call random_number(bxo)
call random_number(byo)
call random_number(bzo)

if (iin.eq.1) then  
   do k=1,xsize(3)
   do j=1,xsize(2)
      bxx1(j,k)=bxx1(j,k)+bxo(j,k)*noise1
      bxy1(j,k)=bxy1(j,k)+byo(j,k)*noise1
      bxz1(j,k)=bxz1(j,k)+bzo(j,k)*noise1
   enddo
   enddo
   if (iscalar==1) then
      do k=1,xsize(3)
      do j=1,xsize(2)
         phi(1,j,k)=0.
      enddo
      enddo
   endif
endif

return
end subroutine inflow 

!*********************************************************
!
subroutine outflow (ux,uy,uz,phi)
!
!*********************************************************

USE param
USE variables
USE decomp_2d
USE MPI

implicit none

integer :: j,k,i, code
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ux,uy,uz,phi
real(mytype) :: udx,udy,udz,uddx,uddy,uddz,uxmax,&
     uxmin,vphase,cx,coef,uxmax1,uxmin1

udx=1./dx
udy=1./dy
udz=1./dz
uddx=0.5/dx
uddy=0.5/dy
uddz=0.5/dz
cx=0.5*(u1+u2)*gdt(itr)*udx

!!$uxmax=-1609.
!!$uxmin=1609.
!!$do k=1,xsize(3)
!!$do j=1,xsize(2)
!!$   if (ux(nx-1,j,k).gt.uxmax) uxmax=ux(nx-1,j,k)
!!$   if (ux(nx-1,j,k).lt.uxmin) uxmin=ux(nx-1,j,k)
!!$enddo
!!$enddo
!!$call MPI_ALLREDUCE(uxmax,uxmax1,1,real_type,MPI_MAX,MPI_COMM_WORLD,code)
!!$call MPI_ALLREDUCE(uxmin,uxmin1,1,real_type,MPI_MIN,MPI_COMM_WORLD,code)
!!$vphase=0.5*(uxmax1+uxmin1)
!!$cx=vphase*gdt(itr)*udx


if (itype.ne.9) then
   do k=1,xsize(3)
   do j=1,xsize(2)
      bxxn(j,k)=ux(nx,j,k)-cx*(ux(nx,j,k)-ux(nx-1,j,k))
      bxyn(j,k)=uy(nx,j,k)-cx*(uy(nx,j,k)-uy(nx-1,j,k))
      bxzn(j,k)=uz(nx,j,k)-cx*(uz(nx,j,k)-uz(nx-1,j,k))
   enddo
   enddo
   if (iscalar==1) then
      do k=1,xsize(3)
      do j=1,xsize(2)
         phi(nx,j,k)=phi(nx,j,k)-cx*(phi(nx,j,k)-phi(nx-1,j,k))
      enddo
      enddo
   endif
else
print *,'NOT READY'
stop
endif


return
end subroutine outflow 

!********************************************************************
!
subroutine fringe(ux1,uy1,uz1,ta1,tb1,tc1)
!
!********************************************************************
  
  USE param
  USE variables
  USE decomp_2d
  implicit none

  integer :: i,j,k
  real(mytype), dimension(xsize(1),xsize(2),xsize(3) ):: ux1,uy1,uz1,ta1,tb1,tc1

  !ZONE EPONGE SORTIE X
  real(mytype) :: x,xlim,xp,lambda
  !

  !plate position
  xp=10.
  !x debut zone eponge
  xlim=20. !xlx=60, xp=10
  

  !Pente zone eponge
  lambda=100.
  
  do k=1,xsize(3)
     do j=1,xsize(2)
        do i=1,xsize(1)
           !Calcul de x dans [-xlx/2;xlx/2]
           x=(i+xstart(1)-1.-1.)*dx-xp
           
           !Forcage qte de mvmt NS
           !Test si zone buffer
           if(x.ge.xlim) then
              ta1(i,j,k)=ta1(i,j,k)+ 0.5*(1.+tanh(lambda*(x-xlim)-4.))*(100. &
                   - ux1(i,j,k) )
              tb1(i,j,k)=tb1(i,j,k)- 0.5*(1.+tanh(lambda*(x-xlim)-4.))*uy1(i,j,k)
              tc1(i,j,k)=tc1(i,j,k)- 0.5*(1.+tanh(lambda*(x-xlim)-4.))*uz1(i,j,k)
           endif

        enddo
     enddo
  enddo
  
  return
end subroutine fringe

!**********************************************************************
!
subroutine ecoule(ux1,uy1,uz1)
!
!**********************************************************************

USE param
USE IBM
USE variables
USE decomp_2d

implicit none

integer  :: i,j,k,jj1,jj2 
real(mytype), dimension(xsize(1),xsize(2),xsize(3)) :: ux1,uy1,uz1
real(mytype) :: x,y,z,ym
real(mytype) :: r1,r2,r3,r
real(mytype) :: uh,ud,um,xv,bruit1

bxx1=0.;bxy1=0.;bxz1=0.
byx1=0.;byy1=0.;byz1=0.
bzx1=0.;bzy1=0.;bzz1=0. 

!ITYPE=1 --> Constant flow field
!ITYPE=2 --> Channel flow
!ITYPE=3 --> Wake flow
!ITYPE=4 --> Mixing layer with splitter plate
!ITYPE=5 --> Channel flow
!ITYPE=6 --> Taylor Green vortices
!ITYPE=7 --> Cavity flow
!ITYPE=8 --> Flat plate Boundary layer
!ITYPE=9 --> Tank 

if (itype.eq.1) then
   um=0.5*(u1+u2)
   do k=1,xsize(3)
   do j=1,xsize(2)
      bxx1(j,k)=um
      bxy1(j,k)=0.
      bxz1(j,k)=0.
   enddo
   enddo
endif

if (itype.eq.2) then
   do k=1,xsize(3)
   do j=1,xsize(2)
      if (istret.eq.0) y=(j+xstart(2)-1-1)*dy-yly/2.
      if (istret.ne.0) y=yp(j+xstart(2)-1)-yly/2.
!      print *,nrank,j+xstart(2)-1,yp(j+xstart(2)-1),1.-y*y
      do i=1,xsize(1)
         ux1(i,j,k)=ux1(i,j,k)+1.-y*y
      enddo
   enddo
   
   enddo 
endif

if (itype.eq.3) then
   
endif

if (itype.eq.4) then
  
endif

if (itype.eq.5) then
   if (nclx.ne.0) then
      print *,'NOT POSSIBLE'
      stop
   endif
   if (nclz.ne.0) then
      print *,'NOT POSSIBLE'
      stop
   endif
   if (ncly==0) then
      print *,'NOT POSSIBLE'
      stop
   endif
   do k=1,xsize(3)
   do j=1,xsize(2)
      if (istret.eq.0) y=(j+xstart(2)-1-1)*dy-yly/2.
      if (istret.ne.0) y=yp(j)-yly/2.
      do i=1,xsize(1)
         ux1(i,j,k)=ux1(i,j,k)+1.-y*y
      enddo
   enddo
   enddo
endif

if (itype.eq.6) then
   t=0.
   xv=1./100.
   xxk1=twopi/xlx
   xxk2=twopi/yly
   do k=1,xsize(3)
      z=(k+xstart(3)-1-1)*dz
   do j=1,xsize(2)
      y=(j+xstart(2)-1-1)*dy
      do i=1,xsize(1)
         x=(i-1)*dx
         ux1(i,j,k)=sin(2.*pi*x)*cos(2.*pi*y)*cos(2.*pi*z)
!sin(xxk1*x)*cos(xxk2*y)*exp(-(xxk1*xxk1+xxk2*xxk2)*xv*t)
         uy1(i,j,k)=sin(2.*pi*y)*cos(2.*pi*x)*cos(2.*pi*z)
!-xxk1/xxk2*sin(xxk2*y)*cos(xxk1*x)*exp(-(xxk1*xxk1+xxk2*xxk2)*xv*t)
         uz1(i,j,k)=sin(2.*pi*z)*cos(2.*pi*x)*cos(2.*pi*y)
!0.
         bxx1(j,k)=0.
         bxy1(j,k)=0.
         bxz1(j,k)=0.
      enddo
   enddo
   enddo   
endif

if (itype.eq.7) then

endif

if (itype.eq.8) then
   
endif

if (itype.eq.9) then
  
endif


if (itype.eq.10) then
   do k=1,xsize(3)
   do j=1,xsize(2)
      bxx1(j,k)=0.
      bxy1(j,k)=0.
      bxz1(j,k)=0.
   enddo
   enddo  
endif

return
end subroutine ecoule

!********************************************************************
!
subroutine init (ux1,uy1,uz1,ep1,phi1,gx1,gy1,gz1,phis1,hx1,hy1,hz1,phiss1)
!
!********************************************************************

USE decomp_2d
USE decomp_2d_io
USE variables
USE param
USE MPI

implicit none

real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ux1,uy1,uz1,phi1,ep1
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: gx1,gy1,gz1,phis1
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: hx1,hy1,hz1,phiss1

real(mytype) :: y,r,um,r1,r2,r3
integer :: k,j,i,fh,ierror
integer (kind=MPI_OFFSET_KIND) :: disp

if (iin.eq.1) then !generation of a random noise

   call random_number(ux1)
   call random_number(uy1)
   call random_number(uz1)

   do k=1,xsize(3)
   do j=1,xsize(2)
   do i=1,xsize(1)
      ux1(i,j,k)=noise*ux1(i,j,k)
      uy1(i,j,k)=noise*uy1(i,j,k)
      uz1(i,j,k)=noise*uz1(i,j,k)
   enddo
   enddo
   enddo

!modulation of the random noise
   do k=1,xsize(3)
   do j=1,xsize(2)
      if (istret.eq.0) y=(j+xstart(2)-1-1)*dy-yly/2.
      if (istret.ne.0) y=yp(j+xstart(2)-1)-yly/2.
      um=exp(-0.2*y*y)
      do i=1,xsize(1)
         ux1(i,j,k)=um*ux1(i,j,k)
         uy1(i,j,k)=um*uy1(i,j,k)
         uz1(i,j,k)=um*uz1(i,j,k)
      enddo
   enddo
   enddo

   if (iscalar==1) then
      do k=1,xsize(3)
      do j=1,xsize(2)
      do i=1,xsize(1)
   !      if ((j+xstart(2)-1).ge.nym) then
   !         phi1(i,j,k)=1.
   !      else
            phi1(i,j,k)=0.
   !      endif
         phis1(i,j,k)=phi1(i,j,k)
         phiss1(i,j,k)=phis1(i,j,k)
      enddo
      enddo
      enddo
   endif
endif

if (iin.eq.2) then !read a correlated noise generated before
endif

!MEAN FLOW PROFILE
call ecoule(ux1,uy1,uz1)
!INIT FOR G AND U=MEAN FLOW + NOISE
do k=1,xsize(3)
do j=1,xsize(2)
do i=1,xsize(1)
   ux1(i,j,k)=ux1(i,j,k)+bxx1(j,k)
   uy1(i,j,k)=uy1(i,j,k)+bxy1(j,k)
   uz1(i,j,k)=uz1(i,j,k)+bxz1(j,k)
   gx1(i,j,k)=ux1(i,j,k)
   gy1(i,j,k)=uy1(i,j,k)
   gz1(i,j,k)=uz1(i,j,k)
   hx1(i,j,k)=gx1(i,j,k)
   hy1(i,j,k)=gy1(i,j,k)
   hz1(i,j,k)=gz1(i,j,k)
enddo
enddo
enddo

if (ivirt==2) then
   call MPI_FILE_OPEN(MPI_COMM_WORLD, 'epsilon.dat', &
        MPI_MODE_RDONLY, MPI_INFO_NULL, &
        fh, ierror)
   disp = 0_MPI_OFFSET_KIND
   call decomp_2d_read_var(fh,disp,nx_global,ny_global,nz_global,1,ep1) 
   call MPI_FILE_CLOSE(fh,ierror)
   if (nrank==0) print *,'read epsilon file done from init'
endif

!!$if (ivirt==1) then
!!$   do k=1,xsize(3)
!!$      do j=1,xsize(2)
!!$         do i=1,xsize(1)
!!$            if(ep1(i,j,k)==1) then
!!$               ux1(i,j,k)=0.
!!$               uy1(i,j,k)=0.
!!$               uz1(i,j,k)=0.
!!$            endif
!!$         enddo
!!$      enddo
!!$   enddo
!!$endif
            

return
end subroutine init

!********************************************************************
!
subroutine divergence (ux1,uy1,uz1,ep1,ta1,tb1,tc1,di1,td1,te1,tf1,&
     td2,te2,tf2,di2,ta2,tb2,tc2,ta3,tb3,tc3,di3,td3,te3,tf3,pp3,&
     nxmsize,nymsize,nzmsize,ph1,ph3,ph4,nlock)
! 
!********************************************************************

USE param
USE IBM
USE decomp_2d
USE variables
USE MPI
   
implicit none

TYPE(DECOMP_INFO) :: ph1,ph3,ph4

!X PENCILS NX NY NZ  -->NXM NY NZ
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ta1,tb1,tc1,di1,ux1,uy1,uz1,ep1
real(mytype),dimension(nxmsize,xsize(2),xsize(3)) :: td1,te1,tf1 
!Y PENCILS NXM NY NZ  -->NXM NYM NZ
real(mytype),dimension(ph1%yst(1):ph1%yen(1),ysize(2),ysize(3)) :: td2,te2,tf2,di2
real(mytype),dimension(ph1%yst(1):ph1%yen(1),nymsize,ysize(3)) :: ta2,tb2,tc2
!Z PENCILS NXM NYM NZ  -->NXM NYM NZM
real(mytype),dimension(ph1%zst(1):ph1%zen(1),ph1%zst(2):ph1%zen(2),zsize(3)) :: ta3,tb3,tc3,di3
real(mytype),dimension(ph1%zst(1):ph1%zen(1),ph1%zst(2):ph1%zen(2),nzmsize) :: td3,te3,tf3,pp3

integer :: ijk,nvect1,nvect2,nvect3,i,j,k,nlock
integer :: nxmsize,nymsize,nzmsize,code
real(mytype) :: tmax,tmoy,tmax1,tmoy1


nvect1=xsize(1)*xsize(2)*xsize(3)
nvect2=ysize(1)*ysize(2)*ysize(3)
nvect3=(ph1%zen(1)-ph1%zst(1)+1)*(ph1%zen(2)-ph1%zst(2)+1)*nzmsize

if (nlock==1) then
   if (ivirt.eq.0) ep1(:,:,:)=0.
   do ijk=1,nvect1
      ta1(ijk,1,1)=(1.-ep1(ijk,1,1))*ux1(ijk,1,1)
      tb1(ijk,1,1)=(1.-ep1(ijk,1,1))*uy1(ijk,1,1)
      tc1(ijk,1,1)=(1.-ep1(ijk,1,1))*uz1(ijk,1,1)
   enddo
else
   ta1(:,:,:)=ux1(:,:,:)
   tb1(:,:,:)=uy1(:,:,:)
   tc1(:,:,:)=uz1(:,:,:)
endif



!WORK X-PENCILS
call decx6(td1,ta1,di1,sx,cfx6,csx6,cwx6,xsize(1),nxmsize,xsize(2),xsize(3),0)
call inter6(te1,tb1,di1,sx,cifxp6,cisxp6,ciwxp6,xsize(1),nxmsize,xsize(2),xsize(3),1)
call inter6(tf1,tc1,di1,sx,cifxp6,cisxp6,ciwxp6,xsize(1),nxmsize,xsize(2),xsize(3),1)

!     if (nrank==2) then
!         open(10,file='test11.dat',status='unknown',form='formatted')
!         do i=1,nxmsize
!         write(10,*) (real(i)-1.)*dx,td1(i,1,1),te1(i,1,1),tf1(i,1,1)
!         enddo
!        close(10)
!      endif


call transpose_x_to_y(td1,td2,ph4)!->NXM NY NZ
call transpose_x_to_y(te1,te2,ph4)
call transpose_x_to_y(tf1,tf2,ph4)


!WORK Y-PENCILS

!do k=1,ysize(3)
!do j=1,ny
!do i=ph1%yst(1),ph1%yen(1)
!   td2(i,j,k)=sin(2.*pi*yp(j))
!enddo
!enddo
!enddo

call intery6(ta2,td2,di2,sy,cifyp6,cisyp6,ciwyp6,(ph1%yen(1)-ph1%yst(1)+1),ysize(2),nymsize,ysize(3),1)
call decy6(tb2,te2,di2,sy,cfy6,csy6,cwy6,ppyi,(ph1%yen(1)-ph1%yst(1)+1),ysize(2),nymsize,ysize(3),0)
call intery6(tc2,tf2,di2,sy,cifyp6,cisyp6,ciwyp6,(ph1%yen(1)-ph1%yst(1)+1),ysize(2),nymsize,ysize(3),1)

!      if (nrank==1) then
!         open(10,file='test.dat',status='unknown',form='formatted')
!         do j=1,ny
!         write(10,*) ypi(j),ta2(1,j,1),sin(2.*pi*ypi(j))
!         enddo
!        close(10)
!     endif



call transpose_y_to_z(ta2,ta3,ph3)!->NXM NYM NZ
call transpose_y_to_z(tb2,tb3,ph3)
call transpose_y_to_z(tc2,tc3,ph3)



!WORK Z-PENCILS
call interz6(td3,ta3,di3,sz,cifzp6,ciszp6,ciwzp6,(ph1%zen(1)-ph1%zst(1)+1),&
     (ph1%zen(2)-ph1%zst(2)+1),zsize(3),nzmsize,1)    
call interz6(te3,tb3,di3,sz,cifzp6,ciszp6,ciwzp6,(ph1%zen(1)-ph1%zst(1)+1),&
     (ph1%zen(2)-ph1%zst(2)+1),zsize(3),nzmsize,1)
call decz6(tf3,tc3,di3,sz,cfz6,csz6,cwz6,(ph1%zen(1)-ph1%zst(1)+1),&
     (ph1%zen(2)-ph1%zst(2)+1),zsize(3),nzmsize,0)




do k=1,nzmsize
do j=ph1%zst(2),ph1%zen(2)
do i=ph1%zst(1),ph1%zen(1)
pp3(i,j,k)=td3(i,j,k)+te3(i,j,k)+tf3(i,j,k)
enddo
enddo
enddo


if (nlock==2) then
   pp3(:,:,:)=pp3(:,:,:)-pp3(ph1%zst(1),ph1%zst(2),nzmsize)
endif

tmax=-1609.
tmoy=0.
do k=1,nzmsize
do j=ph1%zst(2),ph1%zen(2)
do i=ph1%zst(1),ph1%zen(1)
   if (pp3(i,j,k).gt.tmax) tmax=pp3(i,j,k)     
   tmoy=tmoy+abs(pp3(i,j,k))
enddo
enddo
enddo
tmoy=tmoy/nvect3

!print *,nrank,tmax,tmoy

call MPI_REDUCE(tmax,tmax1,1,real_type,MPI_MAX,0,MPI_COMM_WORLD,code)
call MPI_REDUCE(tmoy,tmoy1,1,real_type,MPI_SUM,0,MPI_COMM_WORLD,code)!


if (nrank==0) then
     if (nlock==2) then
        print *,'DIV U final Max=',tmax1
        print *,'DIV U final Moy=',tmoy1/real(nproc)
     else
        print *,'DIV U* Max=',tmax1
        print *,'DIV U* Moyy=',tmoy1/real(nproc)
     endif
endif

return
end subroutine divergence

!********************************************************************
!
subroutine gradp(ta1,tb1,tc1,di1,td2,tf2,ta2,tb2,tc2,di2,&
     ta3,tc3,di3,pp3,nxmsize,nymsize,nzmsize,ph2,ph3)
!
!********************************************************************

USE param 
USE decomp_2d
USE variables

implicit none

TYPE(DECOMP_INFO) :: ph2,ph3
integer :: i,j,k,ijk,nxmsize,nymsize,nzmsize

real(mytype),dimension(ph3%zst(1):ph3%zen(1),ph3%zst(2):ph3%zen(2),nzmsize) :: pp3 
!Z PENCILS NXM NYM NZM-->NXM NYM NZ
real(mytype),dimension(ph3%zst(1):ph3%zen(1),ph3%zst(2):ph3%zen(2),zsize(3)) :: ta3,tc3,di3 
!Y PENCILS NXM NYM NZ -->NXM NY NZ
real(mytype),dimension(ph3%yst(1):ph3%yen(1),nymsize,ysize(3)) :: ta2,tc2
real(mytype),dimension(ph3%yst(1):ph3%yen(1),ysize(2),ysize(3)) :: tb2,td2,tf2,di2
!X PENCILS NXM NY NZ  -->NX NY NZ
real(mytype),dimension(nxmsize,xsize(2),xsize(3)) :: td1,te1,tf1 
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ta1,tb1,tc1,di1 




!WORK Z-PENCILS

call interiz6(ta3,pp3,di3,sz,cifip6z,cisip6z,ciwip6z,cifz6,cisz6,ciwz6,&
     (ph3%zen(1)-ph3%zst(1)+1),(ph3%zen(2)-ph3%zst(2)+1),nzmsize,zsize(3),1)
call deciz6(tc3,pp3,di3,sz,cfip6z,csip6z,cwip6z,cfz6,csz6,cwz6,&
     (ph3%zen(1)-ph3%zst(1)+1),(ph3%zen(2)-ph3%zst(2)+1),nzmsize,zsize(3),1)

!     do k=1,zsize(3)
!        do j=ph3%zst(2),ph3%zen(2)
!            do i=ph3%zst(1),ph3%zen(1)
!               print *,i,j,k,ta3(i,j,k)-pp3(i,j,k)
!            enddo
!        enddo
!      enddo

!      if (nrank==1) then
!         open(10,file='testA.dat',status='unknown',form='formatted')
!         do k=1,nz
!         write(10,*) (real(k)-0.5)*dz,ta3(1,j,1),pp3(1,j,1),tc2(1,j,1)
!        enddo
!        close(10)
!     endif

!WORK Y-PENCILS
call transpose_z_to_y(ta3,ta2,ph3) !nxm nym nz
call transpose_z_to_y(tc3,tc2,ph3)



!print *,'nrank',nrank,ph3%yst(1),ph3%yen(1)
!
!do k=1,ysize(3)
!do j=1,nym
!do i=ph3%yst(1),ph3%yen(1)
!   ta2(i,j,k)=cos(2.*pi*ypi(j))
!enddo
!enddo
!enddo

call interiy6(tb2,ta2,di2,sy,cifip6y,cisip6y,ciwip6y,cify6,cisy6,ciwy6,&
     (ph3%yen(1)-ph3%yst(1)+1),nymsize,ysize(2),ysize(3),1)
call deciy6(td2,ta2,di2,sy,cfip6y,csip6y,cwip6y,cfy6,csy6,cwy6,ppy,&
     (ph3%yen(1)-ph3%yst(1)+1),nymsize,ysize(2),ysize(3),1)
call interiy6(tf2,tc2,di2,sy,cifip6y,cisip6y,ciwip6y,cify6,cisy6,ciwy6,&
     (ph3%yen(1)-ph3%yst(1)+1),nymsize,ysize(2),ysize(3),1)

!      if (nrank==0) then
!         open(10,file='test1.dat',status='unknown',form='formatted')
!         do j=1,ny
!         write(10,*) yp(j),tb2(1,j,1),cos(2.*pi*yp(j))
!         enddo
!        close(10)
!     endif!


!      if (nrank==1) then
!         open(10,file='testA.dat',status='unknown',form='formatted')
!         do j=1,ny
!         write(10,*) (real(j)-1.)*dy,tb2(1,j,1),td2(1,j,1),tf2(1,j,1)
!        enddo
!        close(10)
!     endif

!print *,tb2
!     do k=1,ysize(3)
!         do j=1,ysize(2)
!            do i=ph3%yst(1),ph3%yen(1)
!               print *,i,j,k,tb2(i,j,k)
!            enddo
!         enddo
!      enddo

!WORK X-PENCILS

call transpose_y_to_x(tb2,td1,ph2) !nxm ny nz
call transpose_y_to_x(td2,te1,ph2)
call transpose_y_to_x(tf2,tf1,ph2)

!print *,te1

!     do k=ph3%xst(3),ph3%xen(3)
!         do j=ph3%xst(2),ph3%xen(2)
!            do i=ph3%xst(1),ph3%xen(1)
!               print *,i,j,k,te1(i,j,k)
!            enddo
!         enddo
!      enddo

call deci6(ta1,td1,di1,sx,cfip6,csip6,cwip6,cfx6,csx6,cwx6,&
     nxmsize,xsize(1),xsize(2),xsize(3),1)
call interi6(tb1,te1,di1,sx,cifip6,cisip6,ciwip6,cifx6,cisx6,ciwx6,&
     nxmsize,xsize(1),xsize(2),xsize(3),1)
call interi6(tc1,tf1,di1,sx,cifip6,cisip6,ciwip6,cifx6,cisx6,ciwx6,&
     nxmsize,xsize(1),xsize(2),xsize(3),1)



!we are in X pencils:
do k=1,xsize(3)
do j=1,xsize(2)
   dpdyx1(j,k)=tb1(1,j,k)/gdt(itr)
   dpdzx1(j,k)=tc1(1,j,k)/gdt(itr)
   dpdyxn(j,k)=tb1(nx,j,k)/gdt(itr)
   dpdzxn(j,k)=tc1(nx,j,k)/gdt(itr)
enddo
enddo


if (xsize(3)==1) then
   do j=1,xsize(2)
   do i=1,xsize(1)
      dpdxz1(i,j)=ta1(i,j,1)/gdt(itr)
      dpdyz1(i,j)=tb1(i,j,1)/gdt(itr)
   enddo
   enddo
endif
if (xsize(3)==nz) then
   do j=1,xsize(2)
   do i=1,xsize(1)
      dpdxzn(i,j)=ta1(i,j,nz)/gdt(itr)
      dpdyzn(i,j)=tb1(i,j,nz)/gdt(itr)
   enddo
   enddo
endif

if (xsize(2)==1) then
   do k=1,xsize(3)
   do i=1,xsize(1)
      dpdxy1(i,k)=ta1(i,1,k)/gdt(itr)
      dpdzy1(i,k)=tc1(i,1,k)/gdt(itr)
   enddo
   enddo
endif
if (xsize(2)==ny) then
   do k=1,xsize(3)
   do i=1,xsize(1)
      dpdxyn(i,k)=ta1(i,ny,k)/gdt(itr)
      dpdzyn(i,k)=tc1(i,ny,k)/gdt(itr)
   enddo
   enddo
endif

return
end subroutine gradp

!********************************************************************
!
subroutine corgp_IBM (ux,uy,uz,px,py,pz,nlock)
! 
!********************************************************************

USE param 
USE decomp_2d
USE variables

implicit none

integer :: ijk,nlock,nxyz
real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ux,uy,uz,px,py,pz



nxyz=xsize(1)*xsize(2)*xsize(3)

if (nlock.eq.1) then
   if (nz.gt.1) then
      do ijk=1,nxyz
         uy(ijk,1,1)=-py(ijk,1,1)+uy(ijk,1,1) 
         uz(ijk,1,1)=-pz(ijk,1,1)+uz(ijk,1,1) 
         ux(ijk,1,1)=-px(ijk,1,1)+ux(ijk,1,1)
      enddo
   else
      do ijk=1,nxyz
         uy(ijk,1,1)=-py(ijk,1,1)+uy(ijk,1,1) 
         ux(ijk,1,1)=-px(ijk,1,1)+ux(ijk,1,1)
      enddo
   endif
endif
if (nlock.eq.2) then
   if (nz.gt.1) then
      do ijk=1,nxyz
         uy(ijk,1,1)=py(ijk,1,1)+uy(ijk,1,1) 
         uz(ijk,1,1)=pz(ijk,1,1)+uz(ijk,1,1) 
         ux(ijk,1,1)=px(ijk,1,1)+ux(ijk,1,1)
      enddo
   else
      do ijk=1,nxyz
         uy(ijk,1,1)=py(ijk,1,1)+uy(ijk,1,1) 
         ux(ijk,1,1)=px(ijk,1,1)+ux(ijk,1,1)
      enddo
   endif
endif

return
end subroutine corgp_IBM

!*******************************************************************
!
subroutine body(ux,uy,uz,ep1)
!
!*******************************************************************

USE param 
USE decomp_2d
USE variables
USE IBM

implicit none

real(mytype), dimension(xstart(1):xend(1),xstart(2):xend(2),xstart(3):xend(3)) :: ux,uy,uz,ep1
integer :: i,j,k
real(mytype) :: xm,ym,r

ep1=0.
do k=xstart(3),xend(3)
do j=xstart(2),xend(2)
do i=xstart(1),xend(1)
   xm=(i-1)*dx 
   ym=yp(j)!(j-1)*dy
   r=sqrt((xm-cex)*(xm-cex)+(ym-cey)*(ym-cey)) 
   if (r-ra >= 0.) cycle
   ux(i,j,k)=0.
   uy(i,j,k)=0. 
   uz(i,j,k)=0.
   ep1(i,j,k)=1. 
enddo
enddo
enddo


return  
end subroutine body

!****************************************************************************
!
subroutine pre_correc(ux,uy,uz)
!
!****************************************************************************

USE decomp_2d
USE variables
USE param
USE var
USE MPI


implicit none

real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ux,uy,uz
integer :: i,j,k,code
real(mytype) :: ut,ut1,utt,ut11

if (itime==1) then
   dpdyx1=0.
   dpdzx1=0.
   dpdyxn=0.
   dpdzxn=0.
endif


!we are in X pencils:
do k=1,xsize(3)
do j=1,xsize(2)
   dpdyx1(j,k)=dpdyx1(j,k)*gdt(itr)
   dpdzx1(j,k)=dpdzx1(j,k)*gdt(itr)
   dpdyxn(j,k)=dpdyxn(j,k)*gdt(itr)
   dpdzxn(j,k)=dpdzxn(j,k)*gdt(itr)
enddo
enddo

if (xsize(3)==1) then
   do j=1,xsize(2)
   do i=1,xsize(1)
      dpdxz1(i,j)=dpdxz1(i,j)*gdt(itr)
      dpdyz1(i,j)=dpdyz1(i,j)*gdt(itr)
   enddo
   enddo
endif
if (xsize(3)==nz) then
   do j=1,xsize(2)
   do i=1,xsize(1)
      dpdxzn(i,j)=dpdxzn(i,j)*gdt(itr)
      dpdyzn(i,j)=dpdyzn(i,j)*gdt(itr)
   enddo
   enddo
endif

if (xsize(2)==1) then
   do k=1,xsize(3)
   do i=1,xsize(1)
      dpdxy1(i,k)=dpdxy1(i,k)*gdt(itr)
      dpdzy1(i,k)=dpdzy1(i,k)*gdt(itr)
   enddo
   enddo
endif
if (xsize(2)==ny) then
   do k=1,xsize(3)
   do i=1,xsize(1)
      dpdxyn(i,k)=dpdxyn(i,k)*gdt(itr)
      dpdzyn(i,k)=dpdzyn(i,k)*gdt(itr)
   enddo
   enddo
endif

!Computation of the flow rate Inflow/Outflow
!we are in X pencils:
if (nclx==2) then
   ut1=0.
   do k=1,xsize(3)
   do j=1,xsize(2)
      ut1=ut1+bxx1(j,k)
   enddo
   enddo
   ut1=ut1/xsize(2)/xsize(3)
   call MPI_ALLREDUCE(ut1,ut11,1,real_type,MPI_SUM,MPI_COMM_WORLD,code)
   ut11=ut11/nproc
   ut=0.
   do k=1,xsize(3)
   do j=1,xsize(2)
      ut=ut+bxxn(j,k)
   enddo
   enddo
   ut=ut/xsize(2)/xsize(3)
   call MPI_ALLREDUCE(ut,utt,1,real_type,MPI_SUM,MPI_COMM_WORLD,code)
   utt=utt/nproc

   if (nrank==0) print *,'FLOW RATE I/O',ut11,utt

   do k=1,xsize(3)
   do j=1,xsize(2)
      bxxn(j,k)=bxxn(j,k)-utt+ut11
   enddo
   enddo


endif

!********NCLX==2*************************************
!****************************************************
if (nclx.eq.2) then
   do k=1,xsize(3)
   do j=1,xsize(2)
      ux(1 ,j,k)=bxx1(j,k)
      uy(1 ,j,k)=bxy1(j,k)+dpdyx1(j,k)
      uz(1 ,j,k)=bxz1(j,k)+dpdzx1(j,k)
      ux(nx,j,k)=bxxn(j,k)
      uy(nx,j,k)=bxyn(j,k)+dpdyxn(j,k)
      uz(nx,j,k)=bxzn(j,k)+dpdzxn(j,k)
   enddo
   enddo
endif
!****************************************************
!********NCLY==2*************************************
!****************************************************
!WE ARE IN X PENCIL!!!!!!
if (ncly==2) then
   if (itype.eq.2) then

   if (p_row==1) then
      do k=1,xsize(3)
      do i=1,xsize(1)
         ux(i,1,k)=0.+dpdxy1(i,k)
         uy(i,1,k)=0.
         uz(i,1,k)=0.+dpdzy1(i,k)
      enddo
      enddo
      do k=1,xsize(3)
      do i=1,xsize(1)
         ux(i,xsize(2),k)=0.+dpdxyn(i,k)
         uy(i,xsize(2),k)=0.
         uz(i,xsize(2),k)=0.+dpdzyn(i,k)
      enddo
      enddo
   else
!find j=1 and j=ny
      if (xstart(2)==1) then
         do k=1,xsize(3)
         do i=1,xsize(1)
            ux(i,1,k)=0.+dpdxy1(i,k)
            uy(i,1,k)=0.
            uz(i,1,k)=0.+dpdzy1(i,k)
         enddo
         enddo
      endif
!      print *,nrank,xstart(2),ny-(nym/p_row)
       if (ny-(nym/p_row)==xstart(2)) then
         do k=1,xsize(3)
         do i=1,xsize(1)
            ux(i,xsize(2),k)=0.+dpdxyn(i,k)
            uy(i,xsize(2),k)=0.
            uz(i,xsize(2),k)=0.+dpdzyn(i,k)
         enddo
         enddo
      endif
 
   endif
   endif
endif
!****************************************************
!********NCLZ==2*************************************
!****************************************************
!****************************************************

!##################################################### 

return
end subroutine pre_correc

!####################################################
!
subroutine square(ycenter,zcenter,xthick,xlenght,ux,uy,uz,esp)
!
!####################################################

USE param 
USE decomp_2d
USE variables
USE IBM


implicit none

real(mytype), dimension(xstart(1):xend(1),xstart(2):xend(2),xstart(3):xend(3)) :: ux,uy,uz,esp
real(mytype) :: ycenter,zcenter,xthick,xlenght,slenght,xz1,xz2,xy1,xy2
integer :: j1,j2,z1,z2,iep,i,j,k,k1,k2,ilen

iep=int(xthick*ny/yly)
ilen=int(xlenght*ny/yly)

j1=int(ycenter*ny/yly)
k1=int(zcenter*nz/zlz)+ilen
k2=int(zcenter*nz/zlz)-ilen

do k=xstart(3),xend(3)
do j=xstart(2),xend(2)
do i=xstart(1),xend(1)
   if ((k.ge.(k2-iep)).and.(k.le.(k1+iep))) then
   if ((j.ge.(j1+ilen-iep)).and.(j.le.(j1+ilen+iep))) then
   if ((i.ge.225).and.(i.le.233)) then
      esp(i,j,k)=1.
      ux(i,j,k)=0.
      uy(i,j,k)=0.
      uz(i,j,k)=0.
   endif 
   endif
   endif
   if ((k.ge.(k2-iep)).and.(k.le.(k1+iep))) then
  if ((j.ge.(j1-ilen-iep)).and.(j.le.(j1-ilen+iep))) then
   if ((i.ge.225).and.(i.le.233)) then
      esp(i,j,k)=1.
      ux(i,j,k)=0.
      uy(i,j,k)=0.
      uz(i,j,k)=0.
   endif 
   endif
   endif
   if ((k.ge.(k1-iep)).and.(k.le.(k1+iep))) then
   if ((j.ge.(j1-ilen-iep)).and.(j.le.(j1+ilen+iep))) then
   if ((i.ge.225).and.(i.le.233)) then
      esp(i,j,k)=1.
      ux(i,j,k)=0.
      uy(i,j,k)=0.
      uz(i,j,k)=0.
   endif 
   endif
   endif
   if ((k.ge.(k2-iep)).and.(k.le.(k2+iep))) then
   if ((j.ge.(j1-ilen-iep)).and.(j.le.(j1+ilen+iep))) then
   if ((i.ge.225).and.(i.le.233)) then
      esp(i,j,k)=1.
      ux(i,j,k)=0.
      uy(i,j,k)=0.
      uz(i,j,k)=0.
   endif 
   endif
   endif
enddo
enddo
enddo


return
end subroutine square

!*******************************************************************
!
subroutine forcage_square(ux,uy,uz,esp)
!
!*******************************************************************

USE param 
USE decomp_2d
USE variables
USE IBM


implicit none

real(mytype), dimension(xstart(1):xend(1),xstart(2):xend(2),xstart(3):xend(3)) :: ux,uy,uz,esp
real(mytype),dimension(nz) :: xx1
real(mytype),dimension(ny) :: yy1
integer :: j, i, k, np,i1 ,ii
real(mytype) :: ep0,ep1,ep2,ep3
real(mytype) :: l0,l1,l2,l3,l4
real(mytype), dimension(4) :: l5,l6
real(mytype) :: y,z
esp(:,:,:)=0.
!tmin=3mesh nodes == 

ep3=2./5. !0.4  Tr=8.5 grid tmin=2.1, t2=4.2, t1=8.6, tmax=17.5 
ep2=4./5. !0.8
ep1=9./5 !
ep0=34./5.!

l0=yly/2. 
l1=yly/4. 
l2=yly/8. 
l3=yly/16. 
l4=yly/32.

!####fisrt fractal iteration##########################
 call square(l0,l0,ep0,l1,ux,uy,uz,esp)
!####Second fractal iteration#########################

return  
end subroutine forcage_square

!*******************************************************************
!
subroutine plate(ep1)
!
!*******************************************************************

USE param 
USE decomp_2d
USE decomp_2d_io
USE variables
USE IBM

implicit none

real(mytype), dimension(xsize(1),xsize(2),xsize(3)) :: ep1
integer, parameter ::  nl=2,s=4 !nl: nb of fractal iter ; s: number of sides (4 square)
real(mytype), dimension(nl+1) :: l !reference length for iter nl
integer, dimension(nl+1) :: dp !total number of points for iter nl
real(mytype), dimension(2) :: stpos,endpos !start and end position of each lines
real(mytype), dimension(:,:), allocatable :: pos,newpos !vector position
real(mytype), dimension(9,2) :: rho !position on the local line

integer :: i,j,k,n,p,d
real(mytype) :: x,y,z
real(mytype) :: lbda,r
real(mytype) :: y1
real(mytype) :: yd,yu
real(mytype) :: x1,x2,xp
integer :: kl,kr,jd,ju,jl1,ii

!WE ARE IN X PENCIL

!Plate parameters
lbda=1. !initial length
d=8.    !number of segments
r=-4+d  !ratio between successive lengths 4(cos(90)-1)+d

!cste plate thickness (x2-x1)
x1=0.
x2=dx !smaller based on expe but close for CFD!!!
xp=10.
!

!GET LENGTH AND NUMBER OF DATA POINTS
do n = 1,nl+1
   l(n) = lbda / (r**(n-1)) !element length
   dp(n) = s*(d**(n-1)) + n-(n-1) !number of data points
enddo
   
allocate(pos(dp(1),2))

!SAVE THE COORDS. OF THE BASE PLATE (z,y) (n=1)
!The first point is top left
pos(1,1)=0. 
pos(1,2)=0. 

pos(2,1)=lbda 
pos(2,2)=0.

pos(3,1)=lbda
pos(3,2)=-lbda    

pos(4,1)=0. 
pos(4,2)=-lbda

pos(5,1)=pos(1,1)
pos(5,2)=pos(1,2)

!IBM BASE SQUARE
do k=1,xsize(3)
   z=(k+xstart(3)-1-1)*dz-zlz/2.
   do j=1,xsize(2)
      y=(j+xstart(2)-1-1)*dy-yly/2.
      do i=1,xsize(1)
         x=(i+xstart(1)-1-1)*dx-xp
         if ( (z>=-l(1)*0.5).and.(z<=l(1)*0.5) ) then  
            if( (y>=-l(1)*0.5).and.(y<=l(1)*0.5) ) then
               if( (x.ge.x1).and.(x.le.x2) ) then
                  ep1(i,j,k)=1.     
               endif
            endif
         endif
      enddo
   enddo
enddo
!

!APPLY FRACTAL ITERATIONS
do n = 2,nl+1 !fractal iteration n=2 first

   allocate(newpos(dp(n),2))

   do p = 1,dp(n-1)-1 !number of data points

      stpos(1)=pos(p,1)
      stpos(2)=pos(p,2)
      
      endpos(1)=pos(p+1,1)
      endpos(2)=pos(p+1,2)

      rho=0.
      call transform_d8(stpos,endpos,l(n),rho)
      !SHIFT LOCAL COORDS TO HAVE (0,0) AT THE CENTER OF (z,y) PLANE
      rho(:,1)=rho(:,1)-lbda/2.
      rho(:,2)=rho(:,2)+lbda/2.

      do k=1,xsize(3)
         z=(k+xstart(3)-1-1)*dz-zlz/2.
         do j=1,xsize(2)
            y=(j+xstart(2)-1-1)*dy-yly/2.
            do i=1,xsize(1)
               x=(i+xstart(1)-1-1)*dx-xp
               

               !!4 differents cases are possible

               !1st case
               !1st removal
               if( ((z.gt.rho(5,1)).and.(z.lt.rho(8,1))) &
                    .and. ((y.gt.rho(6,2)).and. (y.le.rho(5,2))) ) then
                  if( (x.ge.x1).and.(x.le.x2) ) then
                     ep1(i,j,k)=0.
                  endif
               endif
               !1st add
               if( ((z.ge.rho(2,1)).and.(z.le.rho(5,1))) &
                    .and. ((y.ge.rho(2,2)).and. (y.le.rho(3,2))) ) then
                  if( (x.ge.x1).and.(x.le.x2) ) then
                     ep1(i,j,k)=1.
                  endif
               endif

               !2nd case
               !2nd removal
               if( ((y.lt.rho(5,2)).and.(y.gt.rho(8,2))) & 
                    .and. ((z.le.rho(5,1)).and.(z.gt.rho(6,1))) ) then
                  if( (x.ge.x1).and.(x.le.x2) ) then
                     ep1(i,j,k)=0.
                  endif
               endif
               !2nd add
               if( ((y.le.rho(2,2)).and.(y.ge.rho(5,2))) &
                    .and. ((z.ge.rho(2,1)).and. (z.le.rho(3,1))) ) then
                  if( (x.ge.x1).and.(x.le.x2) ) then
                     ep1(i,j,k)=1.
                  endif
               endif 

               !3rd case
               !3rd removal
               if( ((z.lt.rho(5,1)).and.(z.gt.rho(8,1))) &
                    .and. ((y.lt.rho(6,2)).and. (y.ge.rho(5,2))) ) then
                  if( (x.ge.x1).and.(x.le.x2) ) then
                     ep1(i,j,k)=0.
                  endif
               endif
               !3rd add
               if( ((z.le.rho(2,1)).and.(z.ge.rho(5,1))) &
                    .and. ((y.le.rho(2,2)).and. (y.ge.rho(3,2))) ) then
                  if( (x.ge.x1).and.(x.le.x2) ) then
                     ep1(i,j,k)=1.
                  endif
               endif

               !4th case
               !4th removal
               if( ((y.gt.rho(5,2)).and.(y.lt.rho(8,2))) & 
                    .and. ((z.ge.rho(5,1)).and.(z.lt.rho(6,1))) ) then
                  if( (x.ge.x1).and.(x.le.x2) ) then
                     ep1(i,j,k)=0.
                  endif
               endif
               !4th add
               if( ((y.ge.rho(2,2)).and.(y.le.rho(5,2))) &
                    .and. ((z.le.rho(2,1)).and. (z.ge.rho(3,1))) ) then
                  if( (x.ge.x1).and.(x.le.x2) ) then
                     ep1(i,j,k)=1.
                  endif
               endif
               
               
            enddo
         enddo
      enddo

      !BACK TO THE OLD COORDS
      rho(:,1)=rho(:,1)+lbda/2.
      rho(:,2)=rho(:,2)-lbda/2.
      !

      ii=1
      do j=d*(p-1)+1,(d+1)*p-(p-1)
         newpos(j,1)= rho(ii,1)
         newpos(j,2)= rho(ii,2)
         ii=ii+1
      enddo
      
   enddo

   deallocate(pos)
   allocate(pos(dp(n),2))
   
   do p=1,dp(n)
      pos(p,1)=newpos(p,1)
      pos(p,2)=newpos(p,2)
   enddo
   
   deallocate(newpos)
   
enddo
!
!SHIFT COORDS TO HAVE (0,0) AT THE CENTER OF (z,y) PLANE
pos(:,1)=pos(:,1)-lbda/2.
pos(:,2)=pos(:,2)+lbda/2.


!!$!IF YOU WANT TO SAVE THE FRONTIER POINT LOCATIONS
!!$open(10,file='positions.dat',form='formatted')
!!$do p=1,dp(nl+1)
!!$   write(10,*) pos(p,1),pos(p,2)
!!$enddo
!!$close(10)

!SAVE FOR VISU
call decomp_2d_write_one(1,ep1,'plate.dat',2)
  
deallocate(pos)

return  
end subroutine plate

!*******************************************************************
!
subroutine force_plate(ux,uy,uz,ep1)
!
!*******************************************************************

USE param 
USE decomp_2d
USE decomp_2d_io
USE variables
USE IBM

implicit none

real(mytype), dimension(xsize(1),xsize(2),xsize(3)) :: ux,uy,uz,ep1
integer :: i,j,k

!FORCE THE VELOCITY INSIDE THE PLATE
do k=1,xsize(3)
   do j=1,xsize(2)
      do i=1,xsize(1)
         if(ep1(i,j,k)==1) then
            ux(i,j,k)=0.
            uy(i,j,k)=0.
            uz(i,j,k)=0.
         endif
      enddo
   enddo
enddo
  
return  
end subroutine force_plate

subroutine transform_d8(stpos,endpos,l,rho)
USE param 
USE decomp_2d
USE decomp_2d_io
USE variables
USE IBM

integer :: i,j,k,n,p
real(mytype),dimension(2) :: stpos,endpos
real(mytype) :: l,theta,x1,y1,x2,y2,alph
real(mytype), dimension(9,2) :: rho


pi=acos(-1.d0)
alph=pi*0.5

x1 = stpos(1)
y1 = stpos(2)
x2 = endpos(1)
y2 = endpos(2)

theta = atan((y2 - y1) / (x2 - x1))

if (((x2-x1)<0)) then
   theta = theta + pi
end if
   
!! CALCULATE NEW COORDS.
rho(1,1) = stpos(1)
rho(1,2) = stpos(2)

rho(2,1) = rho(1,1) + l*cos(theta)
rho(2,2) = rho(1,2) + l*sin(theta)

rho(3,1) = rho(2,1) + l*cos(alph+theta)
rho(3,2)=rho(2,2)+l*sin(alph+theta)


rho(4,1) = rho(3,1) + l*cos(theta)
rho(4,2) = rho(3,2) + l*sin(theta)

rho(9,1) = endpos(1)
rho(9,2) = endpos(2)

rho(8,1) = rho(9,1) - l*cos(theta)
rho(8,2) = rho(9,2) - l*sin(theta)

rho(7,1) = rho(8,1) - l*cos(alph+theta)
rho(7,2) = rho(8,2) - l*sin(alph+theta)

rho(6,1) = rho(7,1) - l*cos(theta)
rho(6,2) = rho(7,2) - l*sin(theta)

rho(5,1) = (rho(1,1) + rho(9,1))/2
rho(5,2) = (rho(1,2) + rho(9,2))/2

end subroutine transform_d8
