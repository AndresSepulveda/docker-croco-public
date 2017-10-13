base_dir:=$(CURDIR)
build_config_dir:=$(CURDIR)/build-config


ifeq ($(compiler),)
compiler=gfortran
endif

ifeq ($(roms_app),)
roms_app=UPWELLING
endif

ifeq ($(version),)
version=3.7
endif


include $(build_config_dir)/Makefile.inc
include $(build_config_dir)/Makefile-$(compiler).inc

package_dir:=$(CURDIR)/../packages
build_dir:=$(CURDIR)/build-$(compiler)
install_dir:=$(CURDIR)/install-$(compiler)

MPICC:=$(install_dir)/bin/mpicc
MPIFC:=$(install_dir)/bin/mpif90

# all: netcdf mpich2 roms
all: netcdf roms
 
$(build_dir):
	mkdir -p $(build_dir)
        
$(install_dir):
	mkdir -p $(install_dir)


# --- HDF-5 ---
#       
hdf5: $(build_dir)
	mkdir -p $(build_dir)/hdf5
	tar zxf $(package_dir)/$(hdf5_archive) --strip-component=1 -C$(build_dir)/hdf5
	cd $(build_dir)/hdf5 && \
	export CC=$(CC) && \
	export FC=$(FC) && \
	./configure --prefix=$(install_dir) --enable-fortran --disable-dap && \
	make all install
                                                              
# --- NetCDF ---
#
netcdf: $(build_dir)
	mkdir -p $(build_dir)/netcdf
	tar zxf $(package_dir)/$(netcdf_archive) --strip-component=1 -C$(build_dir)/netcdf
	cd $(build_dir)/netcdf && \
	export CC=$(CC) && \
	export FC=$(FC) && \
	export F90=$(FC) && \
	export F77=$(FC) && \
	export FFLAGS='$(FCFLAGS)' && \
	./configure --prefix=$(install_dir)   && \
	make all install


# --- mpich2 ---
#
# mpich2: $(build_dir)
# 	mkdir -p $(build_dir)/mpich2
# 	tar zxf $(package_dir)/$(mpich2_archive) --strip-component=1 -C$(build_dir)/mpich2
# 	cd $(build_dir)/mpich2 && \
# 	export CC=$(CC) && \
# 	export FC=$(FC) && \
# 	./configure --prefix=$(install_dir) && \
# 	make all install	

# --- ROMS ---
#
roms: $(build_dir)
	mkdir -p $(build_dir)/roms
	mkdir -p $(build_dir)/roms/bin/tmp
	cp $(build_config_dir)/build.bash-$(compiler) $(build_dir)/roms/bin/build.bash
	cp $(build_config_dir)/Linux-$(FC).mk $(base_dir)/../roms_src/Compilers/Linux-$(FC).mk
	export TMPDIR=$(build_dir)/roms/bin/tmp &&\
	export TMP=$(build_dir)/roms/bin/tmp &&\
	export TEMP=$(build_dir)/roms/bin/tmp &&\
	export INSTALL_DIR=$(install_dir) &&\
	export BASE_DIR=$(base_dir)/.. &&\
	export ROMS_APP=$(roms_app) &&\
	cd $(base_dir)/../roms_src &&\
	bash $(build_dir)/roms/bin/build.bash -j 4
