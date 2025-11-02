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

### C++ / Build
- **C++ standard:** C++17 (project is tested with C++17-compatible toolchains).  
- **CMake:** ≥ 3.8 (recommended: 3.20+).  
- **Compilers (examples):**
  - Linux: GCC ≥ 7.0 or Clang ≥ 7.0
  - Windows: MSVC 2019 (Visual Studio 2019) or MinGW (if supported)
  - macOS: Apple Clang 
- **Optional / recommended tools:**
  - `nproc` or similar for parallel `make -j`
  - Git ≥ 2.20 (to handle submodules comfortably)

### Qt / QML
- **Qt:** ≥ 6.2.4 (project tested with Qt 6.2.4+).  
- Required Qt modules (used by NodeLink QML components):
  - `QtQuick`
  - `QtQuick.Controls`
  - `QtQml`
  - `QtQuick.Layouts`


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

### 0. Quick notes
- The repo uses Git **submodules** for some dependencies. You must clone/update submodules to get a working tree.  
- You can build from command-line (CMake + make / ninja) or with **Qt Creator**.

### 1. Clone repository (including submodules)
Recommended (single step):
```bash
git clone --recursive git@github.com:Roniasoft/NodeLink.git
cd NodeLink
```
If you already cloned without --recursive:
```bash
git submodule update --init --recursive
```  

If you want to update submodules to their remote branches later:
```bash
git submodule update --remote --merge
```  

(Linux / macOS — command-line example)
-----
```bash
  mkdir build
  cd build
  cmake .. -DCMAKE_BUILD_TYPE=Release
  make -j$(nproc)
  sudo make install
```  
Notes:
To change install location use **-DCMAKE_INSTALL_PREFIX=/your/path**.  


Build with Qt Creator
----------

1. Open `CMakeLists.txt` as project.
2. `Build -> Run CMake`
3. `Build -> Build All`
4. Click the button `Run`

Troubleshooting
----------
Missing Qt modules: make sure your Qt installation includes QtQuick, QtQuick.Controls, and other listed modules.  
Submodule folders empty: run git submodule update --init --recursive.  
CMake errors: delete build/ and re-run CMake to get a clean configure.  

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

This project is licensed under the **Apache License, Version 2.0**.

You are free to:
- **Use** the library in both open-source and commercial projects.
- **Modify** and **redistribute** it under the same license.
- **Include** it as part of larger Qt/QML applications.

When redistributing or using this library, you must:
- Include a copy of the [LICENSE](LICENSE) file.
- Provide proper attribution (e.g., link to this repository or mention "NodeLink by RONIA").

For the full terms and conditions, see the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).


