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
-
- Drawing basic node/link features: NodeLink allows you to create nodes and links between them. Nodes are the basic building blocks of your project, and can represent   anything from data points to complex algorithms. Links are connections between nodes, and can represent relationships or dependencies between them.
- Drawing links in different types and styles: In addition to basic links, NodeLink allows you to create links of different types and styles. For example, you could     have straight lines, curved lines, or arrows. You can also customize the color, and other visual properties of your links.

- Definition of the interface of all objects: The interface of an object defines its public methods and properties that can be accessed by other objects. In NodeLink,   all objects have a well-defined interface, which makes it easy to interact with them and manipulate them as needed.

- Basic Scene implementation: The scene is the main area where you create and manipulate your nodes and links. NodeLink provides basic scene functionality, such as       snapping to a grid, snapping to nodes, and automatic alignment and layouting of nodes.

 - Basic background: The background is the visual backdrop of your scene. NodeLink provides a basic background that you can customize with your own images or colors.
 - Basic foreground (currently null): The foreground is the visual layer that appears on top of your nodes and links. While NodeLink doesn't currently provide a foreground layer, this is an area where you could potentially add your own customizations.
 - Basic overview: The overview is a small window that provides an overview of your entire scene, and allows you to quickly navigate to different parts of it. NodeLink provides a basic overview that you can use to quickly move around your scene.

- Undo/Redo using QtQuickStream library: The undo/redo functionality allows you to undo and redo changes you make to your project. This is especially useful if you make a mistake or want to go back to a previous version of your project. NodeLink uses the QtQuickStream library to implement undo/redo, which makes it easy to save and restore your project state.

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

![IMG_20230429_081006](https://user-images.githubusercontent.com/50166193/235283815-135c48e6-74d8-4c8e-97a3-71ce90bac8b0.jpg)

![image](https://user-images.githubusercontent.com/50166193/233803535-45abd705-0ada-4283-ac87-715060bdcd2f.png)



  
## License

```text
Apache License

Copyright (c) 2023 Roniasoft

                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright (c) 2023 Roniasoft

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
