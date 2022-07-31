#!/bin/bash

#Copy WRF Files

#echo -n "Fecha HH-MM-YYYY:  "
#read Domain

mkdir A03012021

cp -r /home/erroba/WRF-4.3.3/run  A03012021

cd A03012021/run

rm ndown.exe real.exe tc.exe wrf.exe

ln -s  /home/erroba/WRF-4.3.3/main/ndown.exe ndown.exe
ln -s  /home/erroba/WRF-4.3.3/main/real.exe real.exe
ln -s  /home/erroba/WRF-4.3.3/main/tc.exe tc.exe
ln -s  /home/erroba/WRF-4.3.3/main/wrf.exe wrf.exe

cd

#Copy WPS Files and links

cp -r /home/erroba/WPS-4.3.1  A03012021

cd A03012021/WPS-4.3.1

rm -f GRIBFILE*
rm -f geo_em*
rm -f met_em*
rm -f FILE*
rm -f PFILE*
rm -f geogrid.exe
rm -f GEOGRID.TBL
rm -f metgrid.exe
rm -f METGRIB.TBL
rm -f ungrib.exe
rm -f Vtable


ln -s /home/erroba/WPS-4.3.1/geogrid.exe geogrid.exe
ln -s /home/erroba/WPS-4.3.1/geogrid/GEOGRID.TBL GEOGRID.TBL
ln -s /home/erroba/WPS-4.3.1/metgrid.exe metgrid.exe
ln -s /home/erroba/WPS-4.3.1/metgrid/METGRID.TBL METGRID.TBL
ln -s /home/erroba/WPS-4.3.1/ungrib.exe ungrib.exe
ln -s /home/erroba/WPS-4.3.1/ungrib/Variable_Tables/Vtable.GFS Vtable

cd

#Set Environment

cd Build_WRF/LIBRARIES

export DIR=/home/erroba/Build_WRF/LIBRARIES
export CC=gcc
export CXX=g++
export FC=gfortran
export FCFLAGS=-m64
export F77=gfortran
export FFLAGS=-m64
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include

cd netcdf-4.1.3

export PATH=$DIR/netcdf/bin:$PATH
export NETCDF=$DIR/netcdf

cd ..

cd mpich-3.0.4

export PATH=$DIR/mpich/bin:$PATH

cd

cd A03012021/WPS-4.3.1/

export LD_LIBRARY_PATH=$DIR/grib2/lib
export WRFIO_NCD_LARGE_FILE_SUPPORT=1

cd

## Namelist generator for WPS and WRF

cd A03012021/WPS-4.3.1

rm namelist.wps

cat<<EOF >namelist.wps

&share
 wrf_core = 'ARW',
 max_dom = 3,
 start_date = '2021-01-03_06:00:00','2021-01-03_06:00:00', '2021-01-03_06:00:00',
 end_date   = '2021-01-04_06:00:00','2021-01-04_06:00:00', '2021-01-04_06:00:00',
 interval_seconds = 10800
 io_form_geogrid = 2,
 debug_level = 0,
/

&geogrid
 parent_id         = 1,1,2,
 parent_grid_ratio = 1,3,3,
 i_parent_start    = 1,36,32,
 j_parent_start    = 1,36,32,
 e_we          = 100,88,76,
 e_sn          = 100,88,76,
 geog_data_res = 'default','default', 'default'
 dx = 9000,
 dy = 9000,
 map_proj =  'lambert',
 ref_lat   = 29.228,
 ref_lon   = -111.162,
 truelat1  = 29.228,
 truelat2  = 29.228,
 stand_lon = -111.162,
 geog_data_path = '/home/erroba/Build_WRF/WPS_GEOG'
 ref_x = 50.0,
 ref_y = 50.0,
/
/

&ungrib
 out_format = 'WPS',
 prefix = 'FILE',
/

&metgrid
 fg_name = 'FILE',
 io_form_metgrid = 2,
/

&mod_levs
 press_pa = 201300 , 200100 , 100000 ,
             95000 ,  90000 ,
             85000 ,  80000 ,
             75000 ,  70000 ,
             65000 ,  60000 ,
             55000 ,  50000 ,
             45000 ,  40000 ,
             35000 ,  30000 ,
             25000 ,  20000 ,
             15000 ,  10000 ,
              5000 ,   1000
 /


&domain_wizard
 grib_data_path = 'null',
 grib_vtable = 'null',
 dwiz_name    =
 dwiz_desc    =
 dwiz_user_rect_x1 =2872
 dwiz_user_rect_y1 =2527
 dwiz_user_rect_x2 =3324
 dwiz_user_rect_y2 =2943
 dwiz_show_political =true
 dwiz_center_over_gmt =true
 dwiz_latlon_space_in_deg =10
 dwiz_latlon_linecolor =-8355712
 dwiz_map_scale_pct =100.0
 dwiz_map_vert_scrollbar_pos =2421
 dwiz_map_horiz_scrollbar_pos =2339
 dwiz_gridpt_dist_km =9.0
 dwiz_mpi_command =null
 dwiz_tcvitals =null
 dwiz_bigmap =Y
/

EOF

cd

#WRF namelist

cd A03012021/run

rm namelist.input

cat<<EOF >namelist.input

 &time_control
 run_days                            = 0,
 run_hours                           = 24,
 run_minutes                         = 0,
 run_seconds                         = 0,
 start_year                          = 2021, 2021, 2021,
 start_month                         = 01,   01, 01,
 start_day                           = 03,   03, 03,
 start_hour                          = 06,   06, 06,
 end_year                            = 2021, 2021, 2021,
 end_month                           = 01,   01, 01,
 end_day                             = 04,   04, 04,
 end_hour                            = 06,   06, 06,
 interval_seconds                    = 10800
 input_from_file                     = .true.,.true.,.true.,
 history_interval                    = 60,  10, 10,
 frames_per_outfile                  = 40, 37, 37
 restart                             = .false.,
 restart_interval                    = 5000,
 io_form_history                     = 2,
 io_form_restart                     = 2,
 io_form_input                       = 2,
 io_form_boundary                    = 2,
 debug_level                         = 0,
/

 &domains
 time_step                = 30,
time_step_fract_num      = 0,
time_step_fract_den      = 1,
max_dom                  = 3,
e_we                     = 100,       88, 76,
e_sn                     = 100,       88, 76,
e_vert                   = 35,       35, 35,
p_top_requested          = 5000,
num_metgrid_levels       = 34,
num_metgrid_soil_levels  = 4,
dx                       = 9000,     3000, 1000,
dy                       = 9000,     3000, 1000,
grid_id                  = 1,        2, 3,
parent_id                = 1,        1, 2,
i_parent_start           = 1,       36, 32,
j_parent_start           = 1,       36, 32,
parent_grid_ratio        = 1,        3, 3,
parent_time_step_ratio   = 1,        3, 3,
feedback                 = 1,
smooth_option            = 0,
/

 &physics
 mp_physics                          = 8,    8,    8,
 cu_physics                          = 0,    0,     0,
 ra_lw_physics                       = 4,    4,    4,
 ra_sw_physics                       = 4,    4,    4,
 bl_pbl_physics                      = 2,    2,    2,
 sf_sfclay_physics                   = 2,    2,    2,
 sf_surface_physics                  = 2,    2,    2,
 radt                                = 5,    5,    5,
 bldt                                = 0,     0,     0,
 cudt                                = 0,     0,     0,
bl_mynn_tkeadvect = .true.,
cu_rad_feedback = .false.,
shcu_physics = 5, 5, 5,
isfflx = 1,
ifsnow = 1,
icloud = 1,
icloud_bl = 0,
num_soil_layers = 4,
 num_land_cat                        = 21,
 sf_urban_physics                    = 0,     0,     0,
 aer_opt = 1,
 swint_opt = 2,
 usemonalb = .true.,

 /

 &diags
solar_diagnostics=1,
/

 &fdda
 /

 &dynamics
 hybrid_opt                          = 2, 
 w_damping                           = 0,
 diff_opt                            = 1,      1,      1,
 km_opt                              = 4,      4,      4,
 diff_6th_opt                        = 0,      0,      0,
 diff_6th_factor                     = 0.12,   0.12,   0.12,
 base_temp                           = 290.
 damp_opt                            = 3,
 zdamp                               = 5000.,  5000.,  5000.,
 dampcoef                            = 0.2,    0.2,    0.2
 khdif                               = 0,      0,      0,
 kvdif                               = 0,      0,      0,
 non_hydrostatic                     = .true., .true., .true.,
 moist_adv_opt                       = 1,      1,      1,
 scalar_adv_opt                      = 1,      1,      1,
 gwd_opt                             = 1,
 /

 &bdy_control
 spec_bdy_width                      = 5,
 specified                           = .true.
 /

 &grib2
 /

 &namelist_quilt
 nio_tasks_per_group = 0,
 nio_groups = 1,
 /

EOF

cat<<EOF >tslist
#-----------------------------------------------#
# 24 characters for name | pfx |  LAT  |   LON  |
#-----------------------------------------------
Abejas                    Abeja  28.904  -111.226
Cuichi                    Cuich  28.554  -111.359
Chipilon                  Chipi  29.235  -111.763
Kino                      Kino   28.694  -111.653

EOF

rm wrfinput*
rm wrfbdy*

cd

###################################################################################
# Start Preprocessing
###################################################################################

cd A03012021/WPS-4.3.1


./geogrid.exe >& log.geogrid

./link_grib.csh /home/erroba/DATA/

ln -sf ungrib/Variable_Tables/Vtable.GFS Vtable

./ungrib.exe

./metgrid.exe >& log.metgrid

cd

###################################################################################
# Start WRF Processing
###################################################################################

cd A03012021/run

rm -f rsl.*
rm -f wrfinput*
rm -f wrfbdy*
rm -f wrfout*

ln -sf /home/erroba/A03012021/WPS-4.3.1/met_em* .

mpirun -np 1 ./real.exe

./wrf.exe
