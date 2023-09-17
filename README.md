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

The main features are as follows:

- Use QtQuickStream to save and load NodeLink projects: QtQuickStream is a library for QtObjects that provides automatic serialization and deserialization of objects.    In the context of NodeLink, this means that you can easily save your project to a file and load it later, without having to manually write code to save and load        each individual object.
- Drawing basic node/link features: NodeLink allows you to create nodes and links between them. Nodes are the basic building blocks of your project, and can represent   anything from data points to complex algorithms. Links are connections between nodes, and can represent relationships or dependencies between them.
- Drawing links in different types and styles: In addition to basic links, NodeLink allows you to create links of different types and styles. For example, you could     have straight lines, curved lines, or arrows. You can also customize the color, and other visual properties of your links.

- Definition of the interface of all objects: The interface of an object defines its public methods and properties that can be accessed by other objects. In NodeLink,   all objects have a well-defined interface, which makes it easy to interact with them and manipulate them as needed.

- Basic Scene implementation: The scene is the main area where you create and manipulate your nodes and links. NodeLink provides basic scene functionality, such as       snapping to a grid, snapping to nodes, and automatic alignment and layouting of nodes.

 - Basic background: The background is the visual backdrop of your scene. NodeLink provides a basic background that you can customize with your own images or colors.
 - Basic foreground (currently null): The foreground is the visual layer that appears on top of your nodes and links. While NodeLink doesn't currently provide a foreground layer, this is an area where you could potentially add your own customizations.
 - Basic overview: The overview is a small window that provides an overview of your entire scene, and allows you to quickly navigate to different parts of it. NodeLink provides a basic overview that you can use to quickly move around your scene.

- Undo/Redo using QtQuickStream library: The undo/redo functionality allows you to undo and redo changes you make to your project. This is especially useful if you make a mistake or want to go back to a previous version of your project. NodeLink uses the QtQuickStream library to implement undo/redo, which makes it easy to save and restore your project state.

Calculator
==================
To see the calculator example, choose the correct example in Qt Creator:




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

