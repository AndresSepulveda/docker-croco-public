## Building ROMS

This README describes how to build ROMS, it's ancilliary components and various post-porocessing software.

First check this repository out into a build environment, ideally a machine with appropriate OS and the Intel Fortran compiler (currently `tehi1.acenet.metocean.co.nz`). Note that the build process will also work with the gfortran compiler.

For a fresh build, all packages need to be compiled (netcdf, mpich, roms). Default options are `compiler=intel`, `roms_app=UPWELLING`, which is the standard test case for ROMS.
```
make all
```

This will make two directories - `./build-intel` and `./install-intel`
The process unpacks packages from the `../packages` directory and compiles the code. The required targets are coppied into `./install-intel`

The process is controlled by `./Makefile` as well as `./build-config/Makefile.inc`

Any compile-time configuration files are also contained in ./build-config

The full build process may take 10 minutes or so.


### Compiling specific executable with particular physics

In this case, one should create a ```roms2d.h``` CPP definitions in ```~/include``` and run as bellow:

```
make roms roms_app=ROMS2D
```

Assuming mpich2 and netcdf were already built and ifort will be used. For different set of physics, different CPP definitions should be prescribed. All the options are listed in [WikiROMS](https://www.myroms.org/wiki/index.php/cppdefs.h)

