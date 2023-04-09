# Clean Architecture

## Part I: Introduction

### What is Design and Architecture?

The low-level details and the high-level structure are all part of the same whole. They form a continuous fabric that defines the shape of the system. There is simply a continuum of decisions from the highest to the lowest levels.

The goal of software architecture is to minimise the human resources required to build and maintain the required system.

### A Tale of Two Values

Function or architecture? Is it more important for the software system to work, or is it more important for the software system to be easy to change?

It is the responsibility of the software development team to assert the importance of architecture over the urgency of features.

## Part II: Programming Paradigms

A paradim tells you which programming structures to use, and when to use them. To date, there have been three such paradigms. For reasons we shall discuss later, there are unlikely to be any others.

### Paradigm Overview

*Structured programming imposes discipline on direct transfer of control.* Dijkstra replaced unrestrained goto statements with structured control constructs such as if, while, and for. These constructs are the foundation of all modern programming languages.

*Object-oriented programming imposes discipline on indirect transfer of control.* Two programmers noticed that the function call stack frame could moved to a heap, thereby allowing local variables declared by a function to exist long after the function returned. The function became a constructor for a class, the local variables became instance variables, and the nested functions became methods.

*Functional programming imposes discipline upon assignment.* A foundational notion of $\lambda$-calculus is immutability - that is, the notion that the values of symbols do not change. This effectively means that a functional language has no assignment statement. Most functional languages do, in fact, have some means to alter the value of a variable, but only under very strict discipline.

Each of these paradigms removes capabilities from the programmer. None of them adds new capabilities. The three paradigms together remove `goto` statements, function pointers, and assignment. Is there anything left to take away? Probably not.

In software architecture, we use polymorphism as the mechanism to cross architectural boundaries; we use functional programming to impose discipline on the location of and access to data; and we use structured programming as the algorithmic foundation of our modules. Notice how well these three align with *z*

### Structured Programming

Dijkstra realized that modules that used only `if/then/else` and `do/while` control structures could be recursively subdivided into smaller provable units. Two years later it was proved that all programmes can be constructed from just three structures: *sequence, selection, and iteration.* These three structures are the foundation of all modern programming languages.

Testing shows the presence, not the absence, of bugs. Software is like a science. We show correctness by failing to prove incorrectness, despite our best effort. Software architects strive to define modules, components and services that are easily falsifiable (testable).

### Object-Oriented Programming

#### Encapsulation

In C, header files provided perfect encapsulation. But then came OO C++, where for technical reasons, member variables of a class need to be declared in the header file. Thus, the languages that claim to provide OO have in fact only weakened the once perfect encapsulation we enjoyed with C. The way encapsulation is partially repaired is by introducing the `public`, `private` and `protected` keywords into the language.

#### Inheritance

Inheritance is simply the redeclaration of a group of variables and functions within an enclosing scope. This is something that C programmers were able to do before already as well, albeit manually. The only difference is that now the compiler does it for you.

#### Polymorphism

Polymorphism is an application of pointers to functions, which again, also already existed in C. Pointers to functions are dangerous, and OO languages eliminate these conventions.

Moreover, in C the flow of control was dictated by the behaviour of the system, and the source code dependencies were dictated by that flow of control. Now, with OO, through dependency inversion, there is inversion of control - the flow of control is dictated by the source code dependencies.

Thus, *OO imposes discipline on indirect transfer of control: It allows the plugin architecture to be used anywhere, for anything.*

Through the use of polymorphism, there is absolute control over every source code dependency in the system. It allows the architect to create a plugin architecture, in which modules that contain high-level policies are independent of modules that contain low-level details.

### Functional Programming

#### Immutability

In functional programming, variables are initialized but never changed.

*You cannot have a race condition or a concurrent update problem if no variable is ever updated. You cannot have deadlocks without mutable locks. All the problems that we face in concurrent applications cannot happen if there are no mutable variables.*

#### Segregation of Mutability

Without infinite storage and infinite processor speed, immutability is not that practicable. One of the most common compromises is to segregate the application into mutable and immutable components.

#### Event Sourcing

Now imagine that instead of storing the account balances, we store only the transactions. Whenever someone wants to know the balance of an account, we simply add up all the transactions for that account.

Event sourcing is a strategy wherein we store the transactions, but not the state.When state is required, we simply apply all the transactions from the beginning of time. As a consequence, our applications are not CRUD; they are just CR; nothing ever gets deleted or updated. (Of course, we can take shortcuts, and e.g. store a snapshot of the state every day.)

In conclusion, we have seen what not to do (as prescribed by the three paradigms).

## Part III: Design Principles

### SRP: The Single Responsibility Principle

*Each software module has one, and only one, reason to change.*

Software systems are changed to satisfy stakeholders, i.e. actors. Cohesion is the force that binds together the code responsible to a single actor. Coupling can cause the actions of one actor to affect the dependencies of another. By the SRP, code that different actors depend on must be segregated.

A common solution to this problem is the Facade pattern.

At the level of components, this principle is called the Common Closure Principle.

### OCP: The Open/Closed Principle

*For software systems to be easy to change, they must be designed to allow the behaviour of those systems to be changed by adding new code, rather than changing existing code.*

A software artifact outght to be extendible without having to modify that artifact.

This goal is accomplished by partitioning the system into components, and arranging those components into a dependency hierarchy that protects higher-level components from changes in lower-level components.

### LSP: The Liskov Substitution Principle

*To build software systems from interchangeable parts, those parts must adhere to a contract that allows those parts to be substituted for one another.*

A simple violation of substitutability can cause a sytem's architecture to be polluted with a significant amount  of extra mechanisms.

### ISP: The Interface Segregation Principle

*Avoid depending on things that aren't used.*

### DIP: The Dependency Inversion Principle

*High-level policies should not depend on low-level details. Rather, details should depend on policies.*

The most flexible systems are those in which source code dependencies refer only to abstractions, not to concretions.

Changes to concrete implementations do not always, or even usually, require changes to the interfaces that they implement. Good software designers and architects work hard to reduce the volatility of interfaces.

- Don't refer to volatile concrete classes. Refer to abstract interfaces instead. Generally, enforce the use of abstract factories.
- Inheritance is the strongest, and most rigid, of all the source code relationships. Consequently, it should be used with great care.

## Part IV: Component Principles

### Components

Components are the units of deployment. Well-designed components always retain the ability to be independently deployable and, therefore, independently developable.

These dynamically linked files, which can be plugged together at runtime, are the software components of our architectures.

### Component Cohesion

#### The Reuse/Release Equivalence Principle

The granule of reuse is the granule of release. Without release numbers, there would be no way to ensure that all the reused components are compatible with each other.

#### The Common Closure Principle

Gather into components those classes that change for the same reasons and at the same times. Separate into different components those classes that change at different times and for different reaseons.

#### The Common Reuse Principle

Don't force users of a component to depend on things they don't need.

### Component Coupling

#### The Stable Dependencies Problem

Depend in the direction of stability. Any component that we expect to be volatile should not be depended on by a component that is difficult to change. Otherwise, the volatile  component will also be difficult to change.

#### The Stable Abstractions Principle

A component should be as abstract as it is stable.

## Part V: Architecture

### What is Architecture?

The goal of the architect is to create a shape for the system that recognises policy as the most essential element of the system while making the details irrelevant to that policy. This allows decisions about those details to be delayed and deferred.

### Independence

A good architecture will allow a system to be born as a monolith, deployed in a single file, but then to grow into a set of independently deployable units and then all the way to independent services and/or microservices. Later, as things change, it should allow for reversing that progression and sliding all the way down into a monolith.

### Boundaries: Drawing Lines

Which decisions are premature? Decisions that have nothing to do with the business requirements.

You draw lines between things that matter and that don't. The GUI doesn't matter to the business rules, so you draw a line between them. Then you arrange the code in those components such that the arrows between them point in one direction - toward the core business. This is an application of the Dependency Inversion and Stable Abstractions principles, where dependency arrows are arranged to point from lower-level details to higher-level abstractions.

### Boundary Anatomy

The strongest boundary is a service. Services do not depend on their physical location. Communications at this level must deal with high levels of latency.

### Policy and Level

The farther a policy is from both the inputs and the outputs of the system, the higher its level. We want source code dependencies to be decoupled from data flow and coupled to level, with all source code dependencies pointing in the direction of the higher-level policies, and thus reducing the impact of change.

### Business Rules

Business rules are rules that make or save the business money.

An Entity is an object within our computer system that embodies a small set of critical business rules operating on Critical Business Data. It is unsullied with concerns about databases, user interfaces, or third-party frameworks. *The Entity is pure business and nothing else.*

*Use cases contain the rules that specify how and when the Critical Business Rules within the Entities are invoked.* Use cases control the dance of the Entities. Entities have no knowledge of the use cases that control them. The use case class accepts simple request data structures for its input, and returns simple response data structures as its output, that are not dependent on anything - they could be used by web or any other interfaces.

### Screaming Architecture

Good architectures are centred on use cases so that architectures can safely describe the structures that support those use cases without committing to frameworks, tools, and environments. The fact that your application is delivered over the web is a detail and should not dominate your system structure.

*If your system architecture is all about the use cases, and if you have kept your frameworks at arm's length, then you should be able to unit-test all those use cases without any of the frameworks in place.* You shouldn't need the web server running to run your tests. You shouldn't need the database connected to run your tests. Your Entity objects should be plain old objects that have no dependencies on frameworks or databases or other complications. Your use cases should coordinate your Entity objects.

### The Clean Architecture

Layers

- independent of frameworks
- independent of the UI
- independent of the database
- independent of any external agency
- testable - the business rules can be tested without the UI, database, web server, or any other external environment

![The Clean Architecture](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg)

#### The Dependency Rule

The overriding rule that makes this architecture work is the Dependency Rule: *Source code dependencies must point only inward, toward higher-level policies.*

Nothing in an inner circle can know anything at all about something in an outer circle. The name of something declared in an outer circle must not be mentioned in an inner circle. Data formats declared in an outer circle (e.g. http requests and responses) should not be used in an inner circle.

#### Crossing Boundary

The Dependency Inversion Principle allows for crossing boundaries, e.g. from controllers through use cases to presenters - through the use of interfaces.

### Presenters and Humble Objects

*The Humble Object pattern is used to divide something that is hard to test from something that is easy to test.*

The View is the humble object that is hard to test. The code in this object is kept as simple as possible. It moves data into the GUI but does not process that data.

The Presenter is the testable object. Its job is to accept data from the application and format it for presentation so that the View can simply move it to the screen. This is the View Model; thus there is nothing left for the View to do other than to load the data from the View Model into the screen, it is humble.

The Database gateways are polymorphic interfaces that contain methods for every create, read, update, or delete operation that can be performed by the application on the database. The interactors are testable, because the gateways can be replaced with appropriate stubs and test doubles. ORMs form another kind of Humble Object boundary between gateway interfaces and the database.

### Partial Boundaries

The Facade or Strategy pattern can be used here.

### Layers and Boundaries

### The Main Component

Think of `main` as a plugin to the application - a plugin that sets up the initial conditions and configurations, gathers all the outside resources, and then hands control over to the high-level policy of the application. Since it is a plugin, it is possible to have many `main` components, one for each configuration of your application.

### Services: Great and Small

To deal with the cross-cutting concerns that all significant systems face, services must be designed with internal component architectures that follow the Dependency Rule. Those services do not define the architectural boundaries of the system; instead, the components within the services do.

### The Test Boundary

Tests, by their very nature, follow the Dependency Rule; they are very detailed and concrete; and they always depend inward toward the code being tested. In fact, you can think of the tests as the outermost circle in the architecture. Nothing within the system depends on the tests, and the tests always depend inward on the components of the system.

### Clean Embedded Architecture

## Part VI: Details

### The Database Is a Detail

### The Web Is a Detail

### Frameworks Are Details

### The Missing Chapter

#### Package by Layer

#### Package by Feature

#### Ports and Adapters

#### Package by Component

#### The Devil Is in the Implementation Details

#### Organization versus Encapsulation

#### Other Decoupling Modes

#### Conclusion
