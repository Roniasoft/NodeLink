# NodeLink

Introduction
============
NodeLink is a qml node editor library that can be used for a wide range of applications. This library allows for the visualization and manipulation of complex graphs while also providing the flexibility for customization and integration with other software. 

Usage
=============

The Nodelink library is a tool that can be used to connect different components within a system or application. To use this library, one can refer to the examples provided within the library and follow the instructions accordingly. The examples provided serve as a guide and demonstrate how to connect different nodes and manipulate data between them.

Platforms
---------

* Linux (x64, gcc-7.0, clang-7)
* OSX (Apple Clang - LLVM 3.6)
* Windows (Win32, x64, msvc2017, MinGW 5.3)

Dependencies
------------

* Qt > 6.4.0 (Will test on lower version soon)
* CMake 3.8


Current State (v0.9.0)
==================

The main features are as follows:

- MVC design
- Background/Foreground drawings
- Custom Node UI
- Custom Node Data
- Custom Link/Connection
- Link/Connection Type (Bezzier, Straight Line, L Shape, etc)
- Scene Overview
- Dynamic Links/Ports
- Dynamic Scene
- Undo/Redo
- Zooming
- Save/Load
- Snapping

Help Needed
==================
- Zoom performance

Any suggestions are welcome!


Calculator Example
==================
![calculator_example](https://github.com/Roniasoft/NodeLink/assets/53909162/db16c995-082a-46d7-a1f0-4e5d16ebdf7d)




Building
========

Linux
-----
```
  git clone git@github.com:Roniasoft/NodeLink.git
  cd NodeLink
  mkdir build
  cd build
  cmake ..
  make -j && make install
```

Qt Creator
----------

1. Open `CMakeLists.txt` as project.
2. `Build -> Run CMake`
3. `Build -> Build All`
4. Click the button `Run`

Contribution
============

#. Be polite, respectful and collaborative.
#. For submitting a bug:

   #. Describe your environment (Qt version, compiler, OS etc)
   #. Describe steps to reproduce the issue

#. For submitting a pull request:

   #. Create a proposal task first. We can come up with a better design together.
   #. Create a pull-request. If applicable, create a simple example for your
      problem, describe the changes in details, provide use cases.

#. For submitting a development request:

   #. Describe your issue in details
   #. Provide some use cases.

Citing
======

RONIA AB, NodeLink, (2023), GitHub repository, https://github.com/Roniasoft/NodeLink

BibTeX::

    @misc{RONIA AB,
      author = {RONIA AB},
      title = {NodeLink. Qt Quick Library},
      year = {2023},
      publisher = {GitHub},
      journal = {GitHub repository},
      howpublished = {\url{https://github.com/Roniasoft/NodeLink}},
      commit = {6ba9c66cdbc8e6d00fd4a8c6b3bde05c616cfa6a}
    }
 
 
 Showcase
========

NodeLink Simple Example:
![image](https://user-images.githubusercontent.com/50166193/233803383-537335a5-d35d-4cfe-945b-6d048ff5950f.png)

![IMG_20230429_081006](https://user-images.githubusercontent.com/50166193/235283815-135c48e6-74d8-4c8e-97a3-71ce90bac8b0.jpg)

![image](https://user-images.githubusercontent.com/50166193/233803535-45abd705-0ada-4283-ac87-715060bdcd2f.png)



  
## License

This library is licensed under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0). See the [LICENSE](LICENSE) file for details.

