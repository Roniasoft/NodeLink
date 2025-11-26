# NodeLink

## Introduction
NodeLink is a qml node editor library that can be used for a wide range of applications. This library allows for the visualization and manipulation of complex graphs while also providing the flexibility for customization and integration with other software.

[![Made by ROMINA](https://img.shields.io/badge/Made%20by-ROMINA-blue)](https://github.com/Roniasoft/NodeLink)
![Version](https://img.shields.io/badge/Version-0.9.0-blue)

## Usage

The Nodelink library is a tool that can be used to connect different components within a system or application. To use this library, one can refer to the examples provided within the library and follow the instructions accordingly. The examples provided serve as a guide and demonstrate how to connect different nodes and manipulate data between them.

## What is NodeLink?

NodeLink is a Qt/QML-based framework for building node-based applications. It follows the Model-View-Controller (MVC) architecture, providing a clear separation of concerns and a modular design.

* **Model**: Represents the data and business logic of the application.
* **View**: Handles the UI rendering and user interactions.
* **Controller**: Manages the interactions between the Model and View.

This architecture allows for a high degree of customization and flexibility, making NodeLink suitable for a wide range of applications.

## Core Library

The NodeLink core library provides a robust framework for building node-based applications. It includes:

* A modular, MVC (Model-View-Controller) architecture
* A customizable node system with support for various data types
* A powerful signal-slot system for node interactions
* Extensive Qt/QML integration for seamless UI development

## Key Features

Here are some of the key features that make NodeLink a powerful tool for building node-based applications:

* **Modular Node System**: Create custom nodes with specific behaviors and interactions.
* **Signal-Slot System**: Enable complex node interactions using a powerful signal-slot system.
* **Qt/QML Integration**: Seamlessly integrate NodeLink with Qt/QML for UI development.
* **Customizable**: Highly customizable architecture and node system.
* **Extensive Documentation**: Comprehensive documentation and example projects.

---

## Examples Showcase
Learn NodeLink through real examples.

- **🔢 Calculator** — A simple math node graph. [➡️ More details](Examples/Calculator.md)

  ![Calculator Example Overview](images/Calculator_Main.png)

- **⚡ Logic Circuits** — Visual logic gates and real-time signals. [➡️ More details](Examples/LogicCircuit.md)

    ![LogicCircuit Example Overview](images/LogicCircuit_Main.png)

- **💬 Chatbot** — Rule-based chatbot built visually using regex nodes. [➡️ More details](Examples/Chatbot.md)

![Chatbot Example Overview](images/Chatbot_Main.png)

- **🖼️ Vison Link** — Build visual pipelines for image operations. [➡️ More details][(More details)](Examples/VisionLink.md)

![VisonLink Example Overview](images/VisionLink_Main.png)

- **📊 PerformanceAnalyzer** — Stress-test NodeLink with large graphs. [➡️ More details](Examples/PerformanceAnalyzer.md)

![Performance Analyzer Example Overview](images/PerformanceAnalyzer_Main.png)

- **🌱 Simple NodeLink** — The most basic example for new users. [➡️ More details](Examples/SimpleNodeLink.md)

![SimpleNodeLink Example Overview](images/SimpleNodeLink_Main.png)
---




## Installation Guide - Create Your First Custom Node in 10 Minutes

This guide will walk you through installing NodeLink and creating your first custom node in just 10 minutes. By the end of this tutorial, you'll have a working NodeLink application with a custom "HelloWorld" node that you can create, connect, and interact with.

[➡️ More details](InstallationGuide/InstallationGuide.md)

---

## Core Concepts & Components

### Architecture Overview

NodeLink follows a **Model-View-Controller (MVC)** architecture pattern with some variations adapted for QML/Qt Quick. This document explains the architecture, separation of concerns, and how components interact.

[➡️ More details](CoreConcepts/ArchitectureOverview.md)

---

### Core Components

This section explains the essential building blocks of NodeLink’s engine, including the Scene, Node, Port, Link, and Container models. It covers their responsibilities, data structure, signals, and how they interact with each other inside the graph model.

[➡️ More details](CoreConcepts/CoreComponents.md)

---

### Other Components

NodeLink includes several supporting components that extend the core architecture, such as the Selection Model, Undo/Redo system, GUI configuration objects, and utility classes. This section describes how these parts work together to provide a complete and flexible node-based framework.

[➡️ More details](CoreConcepts/OtherComponents.md)

---

### Customization Guide

This document explains how to customize NodeLink’s behavior and appearance, including creating new node types, overriding styles, modifying GUI configurations, and extending engine behavior. It is intended for developers building advanced or domain-specific features on top of NodeLink.

[➡️ More details](CoreConcepts/CustomizationGuide.md)


## API Reference

### QMLComponents

This document provides a comprehensive reference for all QML components, properties, functions, and signals available in the NodeLink framework. Use this reference to understand the API structure and how to interact with NodeLink components programmatically.

[➡️ More details](ApiReference/QmlComponents.md)

---

### C++ Classes

This document provides a comprehensive reference for all C++ classes available in the NodeLink framework. These classes are registered with the QML engine and can be used directly from QML code. They provide performance-critical operations, utility functions, and advanced features that benefit from C++ implementation.

[➡️ More details](ApiReference/CppClasses.md)

---

### Configuration Options

This document provides a comprehensive reference for all configuration options available in the NodeLink framework. These options allow you to customize the appearance, behavior, and styling of nodes, links, containers, and scenes.

[➡️ More details](ApiReference/ConfigurationOptions.md)

---

## Advanced Topics

### Custom Node Creation Guide


NodeLink provides a flexible and extensible framework for creating custom node types. This guide covers everything you need to know to create, register, and use custom nodes in your NodeLink application. Custom nodes are the building blocks of your visual programming interface, allowing users to create complex workflows by connecting different node types together.

[➡️ More details](AdvancedTopics/CustomNodeCreation.md)

---

### Data Type Propagation 

Data Type Propagation in NodeLink refers to the mechanism by which data flows through the node graph, from source nodes through processing nodes to result nodes. This document explains how data propagation works, different propagation algorithms, and how to implement custom data flow logic for your application.

[➡️ More details](AdvancedTopics/DataTypePropagation.md)

---

### Undo/Redo System

The Undo/Redo system in NodeLink is a comprehensive command-based architecture that allows users to undo and redo operations performed on the node graph. This system tracks all changes to nodes, links, containers, and their properties, providing a seamless way to revert or replay actions. The implementation uses the **Command Pattern** combined with **Observer Pattern** to automatically capture and record all modifications.

[➡️ More details](AdvancedTopics/UndoRedo.md)

![Undo/Redo System Overview](images/undo-redo-overview_23426.png) <!-- TODO: Insert overview diagram -->
---

### Serialization Format

NodeLink uses **QtQuickStream** for serialization and deserialization of scenes. All scenes, nodes, links, containers, and their properties are saved to JSON files with the `.QQS.json` extension. This document explains the serialization format, how it works, and how to use it in your applications.

[➡️ More details](AdvancedTopics/Serialization.md)

---

### Performance Optimization

NodeLink is designed to handle large scenes with thousands of nodes efficiently. This document covers performance optimization techniques, best practices, and patterns used throughout the framework to ensure smooth operation even with complex node graphs.

[➡️ More details](AdvancedTopics/PerformanceOptimization.md)

---