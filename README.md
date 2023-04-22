# NodeLink

Introduction
============

NodeLink is a versatile library that utilizes the capabilities of Qt Quick to allow for the creation of custom node editors which can be used for a wide range of applications. Its primary purpose is to facilitate the development of node editors and support the communication between these editors via “links”. This library allows for the visualization and manipulation of complex graphs while also providing the flexibility for customization and integration with other software. Ultimately, NodeLink serves as a powerful tool for developers who need to create intuitive and user-friendly interfaces for their applications. 


Usage
=============

The Nodelink library is a tool that can be used to connect different components within a system or application. To use this library, one can refer to the examples provided within the library and follow the instructions accordingly. The examples provided serve as a guide and demonstrate how to connect different nodes and manipulate data between them.

It is essential to note that the Nodelink library requires some knowledge in programming languages such as QML, JavaScript, and C++, as one needs to code and configure their applications to work with the library. However, with the right expertise, the Nodelink library can be effectively used to deliver reliable and efficient applications.

Platforms
---------

* Linux (x64, gcc-7.0, clang-7)
* OSX (Apple Clang - LLVM 3.6)
* Windows (Win32, x64, msvc2017, MinGW 5.3)

Dependencies
------------

* Qt > 6.4.0 (Will test on lower version soon)
* CMake 3.8


Current State (v1.0.0 alpha)
==================


Building
========

Linux
-----
```
  git clone git@github.com:Roniasoft/NodeLink.git
  cd RoniaKit
  mkdir build
  cd build
  cmake ..
  make -j && make install
  make -j && make install
```

Qt Creator
----------

1. Open `CMakeLists.txt` as project.
2. `Build -> Run CMake`
3. `Build -> Build All`
4. Click the button `Run`

Help Needed
===========

Any suggestions are welcome!

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

RONIA AB, RoniaKit, (2023), GitHub repository, https://github.com/Roniasoft/RoniaKit

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

![image](https://user-images.githubusercontent.com/50166193/233803535-45abd705-0ada-4283-ac87-715060bdcd2f.png)



  
## License

```text
MIT License

Copyright (c) 2023 Roniasoft

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
